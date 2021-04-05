function [obs,nobs]=scan_obs_ppk(rtk,obsr)

global gls
nobs0=size(obsr,1); nobs=0; opt=rtk.opt; SNRMASK=32; %#ok
obs=repmat(gls.obs_tmp,nobs0,1);

for i=1:nobs0
    if obsr(i).S(1)~=0&&obsr(i).S(1)/4.0<SNRMASK
        continue;
    end

    obs(nobs+1)=obsr(i);
    nobs=nobs+1;
end

if nobs==0,obs=NaN;return;end
if nobs<nobs0
    obs(nobs+1:end,:)=[];
end

return