function [rtk_gi,rtk_gnss,stat]=gnss_ins_lc(rtk_gi,rtk_gnss)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% GNSS/INS Loosely Coupled %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inputs: rtk_gi    - rtk_gi control struct
%        rtk_gnss  - rtk_gnss control struct
%output: rtk_gi    - rtk_gi control struct
%        rtk_gnss  - rtk_gnss control struct
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%8/12/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%GNSS/INS LC includes SPP/INS LC,PPD/INS LC,PPK/INS LC and PPP/INS LC
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
ins=rtk_gi.ins; opt=rtk_gnss.opt; stat=1;
VAR_POS=10^2; VAR_VEL=0.15^2; MAX_DPOS=10; MAX_DVEL=5; 

% XYZ to BLH
rr=rtk_gnss.sol.pos'; 
[pos_GNSS,Cne]=xyz2blh(rr); 

% VE to VN
ve=rtk_gnss.sol.vel; 
vel_GNSS=Cne*ve';

% XYZ variance to BLH variance
posP=rtk_gnss.sol.posP; T=Dblh2Dxyz(pos_GNSS);
P=[posP(1) posP(4) posP(6);
    posP(4) posP(2) posP(5);
    posP(6) posP(5) posP(3)];
if max(diag(P))>VAR_POS
    rr=zeros(3,1);
else
    P=T^-1*P*(T')^-1;
    VAR1=[P(1,1);P(2,2);P(3,3)];
end

% VE variance to VN variance
velP=rtk_gnss.sol.velP; 
P=[velP(1) velP(4) velP(6);
    velP(4) velP(2) velP(5);
    velP(6) velP(5) velP(3)];
if max(diag(P))>VAR_VEL
    ve=zeros(3,1);
else
    P=Cne*P*Cne';
    VAR2=[P(1,1);P(2,2);P(3,3)];
    if norm(VAR2)==0
        VAR2=[VAR_VEL;VAR_VEL;VAR_VEL];
    end
end

% lever arm correction for position and velocity
pos_INS=ins.pos+ins.Mpv*ins.Cnb*ins.lever;
vel_INS=ins.vel+ins.Cnb*askew(ins.web)*ins.lever;

% exclude large gross errors
if rtk_gi.ngnsslock>10&&norm(rr)~=0
    rr_INS=blh2xyz(pos_INS); dpos=abs(rr_INS-rr); 
    if max(dpos)>MAX_DPOS
        rr=zeros(3,1);
    end
end
if rtk_gi.ngnsslock>10&&norm(ve)~=0
    dvel=abs(vel_INS-vel_GNSS);
    if max(dvel)>MAX_DVEL
        ve=zeros(3,1);
    end
end

% calculate v,H and R
if norm(rr)~=0&&norm(ve)~=0
    v1=pos_INS-pos_GNSS'; v2=vel_INS-vel_GNSS; 
    if opt.mode==glc.PMODE_SPP||(opt.mode==glc.PMODE_DGNSS&&opt.dynamics==1)||...
            (opt.mode==glc.PMODE_KINEMA&&opt.dynamics==1)||...
            (opt.mode==glc.PMODE_PPP_KINEMA&&opt.dynamics==1)
        v=[v1;v2];
        R1=diag(VAR1); R2=diag(VAR2); R=blkdiag(R1,R2);
        H=zeros(6,15);
        H(1,7)=1;H(2,8)=1;H(3,9)=1;
        H(4,4)=1;H(5,5)=1;H(6,6)=1;
    else
        v=pos_INS-pos_GNSS';
        R=diag(VAR1);
        H=zeros(3,15);
        H(1,7)=1;H(2,8)=1;H(3,9)=1;
    end 
elseif norm(rr)~=0&&norm(ve)==0
    v=pos_INS-pos_GNSS';
    R=diag(VAR1); 
    H=zeros(3,15);
    H(1,7)=1;H(2,8)=1;H(3,9)=1;  
elseif norm(rr)==0&&norm(ve)~=0
    if opt.mode==glc.PMODE_SPP||(opt.mode==glc.PMODE_DGNSS&&opt.dynamics==1)||...
            (opt.mode==glc.PMODE_KINEMA&&opt.dynamics==1)||...
            (opt.mode==glc.PMODE_PPP_KINEMA&&opt.dynamics==1)
        v=vel_INS-vel_GNSS; 
        R=diag(VAR2);
        H=zeros(3,15);
        H(1,4)=1;H(2,5)=1;H(3,6)=1;  
    else
        stat=0;
    end
elseif norm(rr)==0&&norm(ve)==0
    stat=0;
end

% IGG-3 robust model, only for SPP/INS mode
if opt.ins.aid(2)==1&&opt.mode==glc.PMODE_SPP&&stat==1&&rtk_gi.ngnsslock>10
    
    Q=H*ins.P*H'+R;
    c0 = 2; c1 = 5;
    nv = size(v,1); std_res=zeros(nv,1); rfact=zeros(nv,1);
    
    for i=1:nv
        std_res(i)=abs(v(i))/sqrt(Q(i,i));
    end
    
    % robust factor
    for i=1:nv
        if std_res(i) <= c0
            rfact(i) = 1;
        elseif (std_res(i) >= c0) && (std_res(i) <= c1)
            rfact(i)= abs(std_res(i))/c0 * ((c1-c0)/(c1-abs(std_res(i))))^2;
        else
            rfact(i) = 10^6;
        end
    end
    
    for i=1:nv
        for j=1:nv
            if j~=i,continue;end
            R(i,j)=R(i,j)*sqrt(rfact(i)*rfact(j));
        end
    end

    idx=(rfact==10^6);
    v(idx,:)=[]; H(idx,:)=[]; R(idx,:)=[]; R(:,idx)=[];

    if isempty(v),stat=0;end
    
end

if stat==1
    % measurement update
    [ins,stat]=lc_filter(v,H,R,ins.x,ins.P,ins);
    if stat==0
        [week,sow]=time2gpst(rtk.sol.time);
        fprintf('Warning:GPS week = %d sow = %.3f,filter failed!\n',week,sow);
        return;
    end
end

if stat==1
    rtk_gi.ins=ins;
    rtk_gi.ngnsslock=rtk_gi.ngnsslock+1;
    rtk_gi.gi_time=rtk_gnss.sol.time;
    
    % update solution status
    rtk_gi=udsol_lc(rtk_gi,rtk_gnss);
end

return

