function [obs,nobs]=scan_obs_spp(obsr)

global glc gls
nobs0=size(obsr,1); nobs=0; 
obs=repmat(gls.obs_tmp,nobs0,1);

for i=1:nobs0
    dt=0;
    for f=1:glc.NFREQ
        dt=dt+obsr(i).P(f)*obsr(i).P(f);
    end
    if dt==0;continue;end
    obs(nobs+1)=obsr(i);
    nobs=nobs+1;
end

if nobs==0,obs=NaN;return;end
if nobs<nobs0
    obs(nobs+1:end,:)=[];
end

return

