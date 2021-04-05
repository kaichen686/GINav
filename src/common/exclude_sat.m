function [obs,nobs]=exclude_sat(obs0,rtk)

global gls
nobs0=size(obs0,1); nobs=0; obs=repmat(gls.obs_tmp,nobs0,1);
ts=rtk.opt.ts; te=rtk.opt.te;
mask=set_sysmask(rtk.opt.navsys);

for i=1:nobs0
    
    time=obs0(i).time;
    if ts.time~=0
        dt=timediff(time,ts);
        if dt<0,continue;end 
    end
    if te.time~=0
        dt=timediff(time,te);
        if dt>0,continue;end
    end

    %if obs0(i).sat==4;continue;end    
    [sys,~]=satsys(obs0(i).sat);
    if mask(sys)==0,continue;end
    
    obs(nobs+1)=obs0(i);
    nobs=nobs+1;
end

if nobs==0,obs=NaN;return;end
if nobs<nobs0
    obs(nobs+1:end,:)=[];
end

return


