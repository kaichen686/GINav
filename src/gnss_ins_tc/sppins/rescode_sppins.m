function [v,H,R,nv,sat_]=rescode_sppins(iter,obs,nav,sv,x,P,opt,rtk)

global glc
nobs=size(obs,1); NSYS=glc.NSYS;
v=zeros(nobs+NSYS,1); H=zeros(nobs+NSYS,rtk.nx); R=zeros(nobs+NSYS,nobs+NSYS);
vsat=zeros(nobs,1); azel=zeros(nobs,2); resp=zeros(nobs,1);
nv=0; ns=0; mask=zeros(5,1); 
lam_carr0=glc.CLIGHT/glc.FREQ_GPS_L1;


pos=x(7:9)'; rr=blh2xyz(pos); T=Dblh2Dxyz(pos);

for i=1:nobs
    
    vsat(i)=0; azel(i,:)=[0,0]; resp(i)=0;
    
    [sys,~]=satsys(obs(i).sat);
    if sys==0,continue;end
    
    if i<nobs&&obs(i).sat==obs(i+1).sat,continue;end
    
    rs = sv(i).pos; dts = sv(i).dts; Vars=sv(i).vars;
    
    [r,LOS]=geodist(rs,rr); azel(i,:)=satazel(pos,LOS);
    if r<=0||azel(i,2)<opt.elmin,continue;end
       
    % pesudorange with code bias correction
    [pr,Vmea]=prange(obs(i),nav,opt,azel(i,:),iter); %#ok
    if pr==0,continue;end
    if abs(pr)>5e7,continue;end
        
    % excluded satellite 
    stat=satexclude(obs(i).sat,Vars,sv(i).svh,opt);
    if stat==0,continue;end
    
    % ionospheric delay
    [ionoerr,Viono]=iono_cor(glc.IONOOPT_BRDC,obs(i).time,nav,obs(i).sat,pos,azel(i,:)); %#ok
    lam_L1=nav.lam(obs(i).sat,1);
    if lam_L1>0,ionoerr=ionoerr*(lam_L1/lam_carr0)^2;end

    % tropospheric delay 
    [troperr,Vtrop]=trop_cor(glc.TROPOPT_SAAS,obs(i).time,nav,pos,azel(i,:)); %#ok

    % design measurement matrix
    H(nv+1,:)=0;
    H(nv+1,7:9)=LOS*T;
    if sys==glc.SYS_GPS
        dtr=x(rtk.ic+1); mask(1)=1;
        H(nv+1,rtk.ic+1)=1; 
    elseif sys==glc.SYS_GLO
        dtr=x(rtk.ic+1)+x(rtk.ic+2); mask(2)=1;
        H(nv+1,rtk.ic+1)=1; H(nv+1,rtk.ic+2)=1;
    elseif sys==glc.SYS_GAL
        dtr=x(rtk.ic+1)+x(rtk.ic+3); mask(3)=1;
        H(nv+1,rtk.ic+1)=1; H(nv+1,rtk.ic+3)=1;
    elseif sys==glc.SYS_BDS
        dtr=x(rtk.ic+1)+x(rtk.ic+4); mask(4)=1;
        H(nv+1,rtk.ic+1)=1; H(nv+1,rtk.ic+4)=1;
    elseif sys==glc.SYS_QZS
        dtr=x(rtk.ic+1)+x(rtk.ic+5); mask(5)=1;
        H(nv+1,rtk.ic+1)=1; H(nv+1,rtk.ic+5)=1;
    end
    
    % pseudorange residuals
    v(nv+1)=pr-(r+dtr-glc.CLIGHT*dts+ionoerr+troperr);

    % variance matrix
    VARr=varerr_spp(opt,azel(i,2),sys);
    R(nv+1,nv+1)=VARr;
    
    % record validate satellite,rasidual
    vsat(i)=1; 
    resp(i)=v(nv+1,1);
    
    nv=nv+1;
    ns=ns+1;
    
end

sat_.vsat=vsat; sat_.azel=azel; sat_.resp=resp; sat_.ns=ns;

v(nv+1:end,:)=[]; H(nv+1:end,:)=[]; R(nv+1:end,:)=[];R(:,nv+1:end)=[];

% IGG-3 model proposed by YuanXi Yang
if opt.ins.aid(2)==1&&rtk.ngnsslock>10
    
    Q=H*P*H'+R;
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
    
    idx=find(rfact==10^6);
    ratio=size(idx,1)/nv;
    if ratio<0.7
        for i=1:nv
            for j=1:nv
                if j~=i,continue;end
                R(i,j)=R(i,j)*sqrt(rfact(i)*rfact(j));
            end
        end
    end
    
end

return

