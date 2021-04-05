function [obs,nobs]=scan_obs_ppp(obsr)

global gls
nobs0=size(obsr,1); nobs=0; k=2;
obs=repmat(gls.obs_tmp,nobs0,1);

for i=1:nobs0
    %sat=obsr(i).sat;
    %[sys,~]=satsys(sat);
    %if sys==glc.SYS_GAL,k=3;else,k=2;end
    if obsr(i).L(1)==0||obsr(i).L(k)==0,continue;end
    if abs(obsr(i).P(1)-obsr(i).P(k))>=200,continue;end
    
    obs(nobs+1)=obsr(i);
    nobs=nobs+1;
end

if nobs==0,obs=NaN;return;end
if nobs<nobs0
    obs(nobs+1:end,:)=[];
end

return