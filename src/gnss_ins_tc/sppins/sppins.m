function [rtk,stat]=sppins(rtk,obs,navs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% SPP/INS Tightly Coupled %%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%inputs: rtk  - rtk control struct
%        obs  - observation
%        navs - all navigation message
%output: rtk  - rtk control struct
%        stat0- state
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
stat=1; opt=rtk.opt; nobs=size(obs,1); niter=1; 

% default configuration
opt.tropopt=glc.IONOOPT_BRDC;
opt.ionoopt=glc.TROPOPT_SAAS;
opt.sateph =glc.EPHOPT_BRDC;

% update state
rtk=udstate_sppins(rtk);

% cumpute satellite position,clock bias,velocity,clock drift
sv=satposs(obs,navs,opt.sateph); 

xp=rtk.x; Pp=rtk.P; x_fb=zeros(rtk.nx,1);
for i=1:niter
    
    % pseudorange residual,measurement matrix,measurement noise matrix
    [v1,H1,R1,nv1,sat_]=rescode_sppins(i,obs,navs,sv,xp,Pp,opt,rtk);
    if nv1<3,stat=0;break;end
    
    % dopller residual,measurement matrix,measurement noise matrix
    [v2,H2,R2,nv2]=resdop_sppins(obs,navs,sv,sat_,xp,Pp,rtk);

%     % exclude abnormal pseudorange and doppler
%     if nv1>0
%         [v1,H1,R1,nv1]=robust_sppins(v1,H1,R1,0);
%     end
%     if nv2>0
%         [v2,H2,R2,nv2]=robust_sppins(v2,H2,R2,1);
%     end

  
    if nv1>0&&nv2>0
        v=[v1;v2]; H=[H1;H2]; R=blkdiag(R1,R2);
    elseif nv1>0&&nv2==0
        v=v1; H=H1; R=R1;
    elseif nv1==0&&nv2>0
        v=v2; H=H2; R=R2;
    else
        stat=0; break;
    end
        
    % measurement update
    [xp,Pp,x_fb0,stat]=sppins_filter(v,H,R,xp,Pp);
    if stat==0
        [week,sow]=time2gpst(obs(1).time);
        fprintf('Warning:GPS week = %d sow = %.3f,SPP/INS filter failed!\n',week,sow);
        break;
    end
    x_fb=x_fb+x_fb0;
    
end

if stat==1 
    rtk.x=xp; rtk.P=Pp;
    
    rtk.gi_time=obs(1).time;
    rtk.ngnsslock=rtk.ngnsslock+1;
    
    % update INS parameters
    rtk=sppins_feedback(rtk,x_fb);
    
    % update solution status
    rtk.sol.time=obs(1).time;
    rtk.sol.stat=glc.SOLQ_SPP;
    rtk.sol.ns=sat_.ns;
    rtk=udsol_sppins(rtk);

    rtk.oldsol=rtk.sol;
end

for i=1:glc.MAXSAT
    rtk.sat(i).vs=0;
    rtk.sat(i).azel=[0,0];
    rtk.sat(i).snr(1)=0;
    rtk.sat(i).resp(1)=0;
    rtk.sat(i).resc(1)=0;
end

for i=1:nobs
    rtk.sat(obs(i).sat).azel=sat_.azel(i,:);
    rtk.sat(obs(i).sat).snr(1)=obs(i).S(1);
    if sat_.vsat(i)==0,continue;end
    rtk.sat(obs(i).sat).vs=1;
    rtk.sat(obs(i).sat).resp(1)=sat_.resp(i);
    rtk.sat(obs(i).sat).oldobs=obs(i);
end

return

