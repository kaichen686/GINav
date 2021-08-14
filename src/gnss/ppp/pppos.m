function [rtk,stat]=pppos(rtk,obs,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% precise point positioning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input:  rtk - rtk control struct
%        obs - observations
%        nav - navigation message
%output: rtk - rtk control struct
%        stat - state (0:error 1:ok)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc
nobs=size(obs,1); MAXITER=8; iter=1; stat=0;
exc=zeros(nobs,1); dr=zeros(3,1);

% initialize rtk.sat.fix
for i=1:glc.MAXSAT
    for j=1:rtk.opt.nf
        rtk.sat(i).fix(j)=0;
    end
end

% debug tracing
% fprintf('\n \n \n');
% fprintf('time= %d',obs(1).time.time);fprintf('\n');
% fprintf('before time update');
% printx_ppp(rtk.x,rtk);
% printP(rtk.P,rtk);

% time update
rtk=udstate_ppp(rtk,obs,nav);

% debug tracing
% fprintf('after time update');
% printx_ppp(rtk.x,rtk);
% printP(rtk.P,rtk);

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
    [v,H,R,~,exc,nv,rtk]=ppp_res(0,rtk.x,rtk,obs,nav,sv,dr,exc);
    if nv==0,break;end
    
    % debug tracing
%     printv(v);
%     printH(H);
%     printR(R);

    % measurement update
    [X,P,stat_tmp]=Kfilter_h(v,H,R,rtk.x,rtk.P);
    if stat_tmp==0
        [week,sow]=time2gpst(obs(1).time);
        fprintf('Warning:GPS week = %d sow = %.3f,filter error!\n',week,sow);
        stat=0;break;
    end
    
    % debug tracing
%     fprintf('after measurement update');
%     printx_ppp(X,rtk);
%     printP(P,rtk);
    
    % calculate posteriori residuals,validate the solution
    [~,~,~,~,exc,stat,rtk]=ppp_res(iter,X,rtk,obs,nav,sv,dr,exc);
    iter=iter+1;
    
    if stat==1
        rtk.x=X; rtk.P=P;
        break;
    end
    
end

if iter>MAXITER
    [week,sow]=time2gpst(obs(1).time);
    fprintf('Warning:GPS week=%d sow=%.3f, ppp iteration overflows',week,sow);
end

if stat==1
    % PPP ambiguity resolution (Not supported for the time being)
    
    % update solution
    rtk=update_stat(rtk,obs,glc.SOLQ_PPP);

    % hold fixed ambiguity (Not supported for the time being)
    
end

return

