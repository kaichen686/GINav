function pos=avepos(rtk,opt,obs,nav)

pos_all=zeros(1,3); n=0;

% initialize rtk sturct
rtk=initrtk(rtk,opt);

% set time span
tspan=timespan(rtk,obs);
if tspan<=0,error('Time span is zero!!!');end

while 1
    % search rover obs
    [obs_,nobs,obs]=searchobsr(obs);
    if nobs<0,break;end
    % exclude rover obs
    [obs_,nobs]=exclude_sat(obs_,rtk);
    if nobs==0,continue;end
    [rtk,stat]=sppos(rtk,obs_,nav);
    if stat==0,continue; end
    pos_all=pos_all+rtk.sol.pos;
    n=n+1;
end

if n~=0
    pos=pos_all/n;
else
    pos=zeros(1,3);
end

return

