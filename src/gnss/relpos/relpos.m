function [rtk,stat0]=relpos(rtk,obsr,obsb,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%% relative positioning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input:  rtk - rtk control struct
%        obsr - rover observations
%        obsb - base observations
%        nav - navigation message
%output: rtk - rtk control struct
%        stat0 - state (0:error 1:ok)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%relative positioning include PPD, PPK and PPS
%PPD:post-processing differenced, based on double-differenced PR
%PPK:post-processing kinematic, based on double-differenced CP and PR
%PPS:post-processing static, based on double-differenced CP and PR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
opt=rtk.opt; nf=rtk.NF; dt=timediff(obsr(1).time,obsb(1).time);
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

svr=satposs(obsr,nav,opt.sateph);
svb=satposs(obsb,nav,opt.sateph);

% zero-differenced residuals for base
[zdb,stat_tmp]=zdres(2,obsb,svb,nav,rtk.basepos,opt,rtk);
if stat_tmp==0,stat0=0;return;end

ind=selcomsat(obsr,obsb,opt,zdb);
if ind.ns==0,stat0=0;return;end

% debug tracing
% fprintf('\n\n\n');
% fprintf('time=%d\n',obsr(1).time.time);
% fprintf('before time update\n');
% printx(rtk.x,rtk);
% printP(rtk.P,rtk);

% time update
rtk=udstate(rtk,obsr,obsb,nav,ind);

% debug tracing
% fprintf('after time update\n');
% printx(rtk.x,rtk);
% printP(rtk.P,rtk);

xp=rtk.x; Pp=zeros(rtk.nx,rtk.nx);
for i=1:opt.niter
    
    % zero-differenced residuals for rover
    [zdr,stat_tmp]=zdres(1,obsr,svr,nav,xp(1:3),opt,rtk);
    if stat_tmp==0,stat=glc.SOLQ_NONE;break;end
    
    % double-differenced residuals,measurement matrix and noise matrix
    [rtk,v,H,R,nv,~]=ddres(rtk,nav,dt,xp,Pp,zdr,zdb,ind);
    if nv<=0,stat=glc.SOLQ_NONE;break;end
    
    % debug tracing
%     printv(v);
%     printH(H);
%     printR(R);
    
    % measurement update
    Pp=rtk.P;
    [xp,Pp,stat_tmp]=Kfilter_h(v,H,R,xp,Pp);
    if stat_tmp==0
        [week,sow]=time2gpst(obs(1).time);
        fprintf('Warning:GPS week = %d sow = %.3f,filter error!\n',week,sow);
        stat=glc.SOLQ_NONE;
        break;
    end
    
    % debug tracing
%     fprintf('after measurement update\n');
%     printx(xp,rtk);
%     printP(Pp,rtk);
    
end

if stat~=glc.SOLQ_NONE
    % zero-differenced residuals for rover
    [zdr,stat_tmp]=zdres(1,obsr,svr,nav,xp(1:3),opt,rtk);
    if stat_tmp~=0
        % post-fit residuals for float solution
        [rtk,v,~,R,nv,vflag]=ddres(rtk,nav,dt,xp,Pp,zdr,zdb,ind);
        % validation of float solution
        if valpos_rel(rtk,v,R,vflag,nv,4)
            rtk.x=xp; rtk.P=Pp;
            rtk.sol.ns=0;
            for i=1:ind.ns
                for f=1:nf
                    sati=ind.sat(i);
                    if ~rtk.sat(sati).vsat(f),continue;end
                    rtk.sat(sati).lock(f)=rtk.sat(sati).lock(f)+1;
                    rtk.sat(sati).outc(f)=0;
                    if f==1,rtk.sol.ns=rtk.sol.ns+1;end
                end
            end
            if rtk.sol.ns<4,stat=glc.SOLQ_NONE;end
        else
            stat=glc.SOLQ_NONE;
        end 
    end 
end

% ambiguity resolution
if stat~=glc.SOLQ_NONE
    [rtk,~,xa,nb]=resamb(rtk);
    if nb>1
        % zero-differenced residuals for rover
        [zdr,stat_tmp]=zdres(1,obsr,svr,nav,xa(1:3),opt,rtk);
        if stat_tmp~=0
            % post-fit reisiduals for fixed solution
            [rtk,v,~,R,nv,vflag]=ddres(rtk,nav,dt,xa,Pp,zdr,zdb,ind);
            % validation of fixed solution
            if valpos_rel(rtk,v,R,vflag,nv,4)
                rtk.nfix=rtk.nfix+1;
                if rtk.nfix>=opt.minfix&&rtk.opt.modear==glc.ARMODE_FIXHOLD
                    % hold integer ambiguity
                    rtk=holdamb(rtk,xa);
                end
                stat=glc.SOLQ_FIX;
            end
        end
    end
end

% save solution status
if stat==glc.SOLQ_FIX
    rtk.sol.pos=rtk.xa(1:3)';
    rtk.sol.posP(1)=rtk.Pa(1,1); rtk.sol.posP(2)=rtk.Pa(2,2);
    rtk.sol.posP(3)=rtk.Pa(3,3); rtk.sol.posP(4)=rtk.Pa(1,2);
    rtk.sol.posP(5)=rtk.Pa(2,3); rtk.sol.posP(6)=rtk.Pa(1,3);
    if rtk.opt.dynamics==1
        rtk.sol.vel=rtk.xa(4:6)';
        rtk.sol.velP(1)=rtk.Pa(4,4); rtk.sol.velP(2)=rtk.Pa(5,5);
        rtk.sol.velP(3)=rtk.Pa(6,6); rtk.sol.velP(4)=rtk.Pa(4,5);
        rtk.sol.velP(5)=rtk.Pa(5,6); rtk.sol.velP(6)=rtk.Pa(4,6);
    end
else
    rtk.sol.pos=rtk.x(1:3)';
    rtk.sol.posP(1)=rtk.P(1,1); rtk.sol.posP(2)=rtk.P(2,2);
    rtk.sol.posP(3)=rtk.P(3,3); rtk.sol.posP(4)=rtk.P(1,2);
    rtk.sol.posP(5)=rtk.P(2,3); rtk.sol.posP(6)=rtk.P(1,3);
    if rtk.opt.dynamics==1
        rtk.sol.vel=rtk.xa(4:6)';
        rtk.sol.velP(1)=rtk.P(4,4); rtk.sol.velP(2)=rtk.P(5,5);
        rtk.sol.velP(3)=rtk.P(6,6); rtk.sol.velP(4)=rtk.P(4,5);
        rtk.sol.velP(5)=rtk.P(5,6); rtk.sol.velP(6)=rtk.P(4,6);
    end
    rtk.nfix=0;
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

