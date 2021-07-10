function [rtk,stat0]=rtkins(rtk,obsr,obsb,navs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% RTK/INS Tightly Coupled %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inputs: rtk  - rtk control struct
%        obsr - rover observation
%        obsb - base observation
%        navs - all navigation message
%output: rtk  - rtk control struct
%        stat0- state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%This function include PPD/INS TC and PPK/INS TC
%PPD/INS TC based on double-differenced pseudorange
%PPK/INS TC based on double-differenced carrier phase and pseudorange
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
opt=rtk.opt;
nf=rtk.NF; dt=timediff(obsr(1).time,obsb(1).time);
nobsr=size(obsr,1); nobsb=size(obsb,1);

if rtk.opt.mode<=glc.PMODE_DGNSS
    stat=glc.SOLQ_DGNSS;
else
    stat=glc.SOLQ_FLOAT;
end

for i=1:glc.MAXSAT
    [sys,~]=satsys(i);
    rtk.sat(i).sys=sys;
    for j=1:glc.NFREQ
        rtk.sat(i).vsat(j)=0;
    end
    for j=1:glc.NFREQ
        rtk.sat(i).snr(j)=0;
    end 
end

svr=satposs(obsr,navs,opt.sateph);
svb=satposs(obsb,navs,opt.sateph);

% zero-differenced residuals for base
[zdb,stat_tmp]=zdres_rtkins(2,obsb,svb,navs,rtk.basepos,opt,rtk);
if stat_tmp==0,stat0=0;return;end

ind=selcomsat(obsr,obsb,opt,zdb);
if ind.ns==0,stat0=0;return;end

% time update
rtk=udstate_rtkins(rtk,obsr,obsb,navs,ind);

xp=rtk.x; Pp=rtk.P; x_fb=zeros(rtk.nx,1);
for i=1:opt.niter
    
    % zero-differenced residuals for rover
    roverpos=blh2xyz(xp(7:9));
    [zdr,stat_tmp]=zdres_rtkins(1,obsr,svr,navs,roverpos,opt,rtk);
    if stat_tmp==0,stat=glc.SOLQ_NONE;break;end
    
    % double-differenced residuals,measurement matrix and noise matrix
    [rtk,v,H,R,nv,~]=ddres_rtkins(rtk,navs,dt,xp,Pp,zdr,zdb,ind);
    if nv<=0,stat=glc.SOLQ_NONE;break;end
    
    % measurement update
    [xp,Pp,x_fb0,stat_tmp]=rtkins_filter(v,H,R,xp,Pp); 
    if stat_tmp==0
        [week,sow]=time2gpst(obsr(1).time);
        fprintf('Warning:GPS week = %d sow = %.3f,filter failed!\n',week,sow);
        stat=glc.SOLQ_NONE;
        break;
    end
    x_fb=x_fb+x_fb0;
    
end

if stat~=glc.SOLQ_NONE
    % zero-differenced residuals for rover
    roverpos=blh2xyz(xp(7:9));
    [zdr,stat_tmp]=zdres_rtkins(1,obsr,svr,navs,roverpos,opt,rtk);
    if stat_tmp~=0
        % post-fit residuals for float solution
        [rtk,v,~,R,nv,vflag]=ddres_rtkins(rtk,navs,dt,xp,Pp,zdr,zdb,ind);
        % validation of float solution
        if valpos_rel(rtk,v,R,vflag,nv,4)
            rtk.x=xp; rtk.P=Pp;
            rtk.sol.ns=0;
            for i=1:ind.ns
                for f=1:nf
                    sati=ind.sat(i);
                    if ~rtk.sat(sati).vsat(f),continue;end
                    rtk.sat(sati).azel=zdr(ind.ir(i)).azel;
                    rtk.sat(sati).lock(f)=rtk.sat(sati).lock(f)+1;
                    rtk.sat(sati).outc(f)=0;
                    if f==1,rtk.sol.ns=rtk.sol.ns+1;end
                end
            end
            if rtk.sol.ns<3 %note ns !!!
                stat=glc.SOLQ_NONE;
            else
                rtk=rtkins_feedback(rtk,x_fb,1); %note!!!
            end 
        else
            stat=glc.SOLQ_NONE;
        end 
    end 
end

% ambiguity resolution
if stat~=glc.SOLQ_NONE
    [rtk,~,xa,nb]=resamb_rtkins(rtk); 
    if nb>1
        % zero-differenced residuals for rover
        roverpos=blh2xyz(xa(7:9));
        [zdr,stat_tmp]=zdres_rtkins(1,obsr,svr,navs,roverpos,opt,rtk);
        if stat_tmp~=0
            % post-fit reisiduals for fixed solution
            [rtk,v,~,R,nv,vflag]=ddres_rtkins(rtk,navs,dt,xa,Pp,zdr,zdb,ind);
            % validation of fixed solution
            if valpos_rel(rtk,v,R,vflag,nv,4)
                rtk.nfix=rtk.nfix+1;
                if rtk.nfix>=opt.minfix&&rtk.opt.modear==glc.ARMODE_FIXHOLD
                    % hold integer ambiguity
                    rtk=holdamb_rtkins(rtk,xa);
                end
                stat=glc.SOLQ_FIX;
            end
        end
    end
end

if stat~=0
    rtk.gi_time=obsr(1).time;
    rtk.ngnsslock=rtk.ngnsslock+1;
    
    % update solution status
    rtk.sol.time=obsr(1).time;
    rtk=udsol_rtkins(rtk,stat);
end

for i=1:nobsr
    for j=1:nf
        if obsr(i).L(j)==0,continue;end
        rtk.sat(obsr(i).sat).pt(1,j)=obsr(i).time;
        rtk.sat(obsr(i).sat).ph(1,j)=obsr(i).L(j);
    end
end

for i=1:nobsb
    for j=1:nf
        if obsb(i).L(j)==0,continue;end
        rtk.sat(obsb(i).sat).pt(2,j)=obsb(i).time;
        rtk.sat(obsb(i).sat).ph(2,j)=obsb(i).L(j);
    end
end

for i=1:ind.ns
    for j=1:nf
        rtk.sat(ind.sat(i)).snr(j)=obsr(ind.ir(i)).S(j);
    end
end

for i=1:glc.MAXSAT
    for j=1:nf
        if rtk.sat(i).fix(j)==2&&stat~=glc.SOLQ_FIX
            rtk.sat(i).fix(j)=1;
        end
        if bitand(rtk.sat(i).slip(j),1)
            rtk.sat(i).slipc(j)=rtk.sat(i).slipc(j)+1;
        end
    end
end

if stat~=glc.SOLQ_NONE,rtk.sol.stat=stat;end

stat0=(stat~=glc.SOLQ_NONE);

return

