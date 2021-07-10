function [rtk,stat]=pppins(rtk,obs,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%% PPP/INS Tightly Coupled %%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
nobs=size(obs,1); MAXITER=8; iter=1; 
exc=zeros(nobs,1); dr=zeros(3,1);

% initialize rtk.sat.fix
for i=1:glc.MAXSAT
    for j=1:rtk.opt.nf
        rtk.sat(i).fix(j)=0;
    end
end

% time update
rtk=udstate_pppins(rtk,obs,nav);

% cumpute satellite position,clock bias,velocity,clock drift
sv=satposs(obs,nav,rtk.opt.sateph);

% exclude measurements of eclipsing satellite (block IIA)
if rtk.opt.posopt(4)==1
    sv=testeclipse(obs,nav,sv);
end

% compute earth tides correction
if rtk.opt.tidecorr==1
    dr=tidedisp(gpst2utc(obs(1).time),rtk.sol.pos,7,nav.erp,nav.otlp);
end


while iter<=MAXITER
    
    % calculate residuals,measurement matrix,measurement noise matrix
    [v,H,R,~,exc,nv,rtk]=pppins_res(0,rtk.x,rtk,obs,nav,sv,dr,exc);
    if nv==0,break;end

    % measurement update
    [x,P,x_fb,stat_tmp]=pppins_filter(v,H,R,rtk.x,rtk.P);
    if stat_tmp==0
        [week,sow]=time2gpst(obs(1).time);
        fprintf('Warning:GPS week = %d sow = %.3f,PPP/INS filter failed!\n',week,sow);
        stat=0;break;
    end 
    
    % calculate posteriori residuals,validate the solution
    [~,~,~,~,exc,stat,rtk]=pppins_res(iter,x,rtk,obs,nav,sv,dr,exc);
    iter=iter+1;
    
    if stat==1
        rtk.x=x; rtk.P=P; break;
    end
    
end

if iter>MAXITER
    [week,sow]=time2gpst(obs(1).time);
    fprintf('Warning:GPS week=%d sow=%.3f,PPP/INS iteration overflows!\n',week,sow);
end

if stat==1
    rtk.gi_time=obs(1).time;
    rtk.ngnsslock=rtk.ngnsslock+1;
    
    % update INS parameters
    rtk=pppins_feedback(rtk,x_fb);
    
    % update solution
    rtk=update_stat_pppins(rtk,obs,glc.SOLQ_PPP);
    
end

return

