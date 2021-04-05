function [obs,nobs,obss]=searchobsr(obss)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%search rover observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gls

if obss.idx>=obss.n
    obs=NaN;nobs=-1;return
end

obss.idx=obss.idx+1;
obs_tmp=obss.data(obss.idx,:);

time0=obss.data(:,1)+obss.data(:,2);
time1=obs_tmp(1)+obs_tmp(2);
idx=time0==time1;  pos=find(time0==time1);
if any(idx)
    obs0=obss.data(idx,:);  nobs=size(obs0,1); obss.idx=pos(end);
else
    nobs=0;obs=NaN;return;
end

obs=repmat(gls.obs_tmp,nobs,1);
for i=1:nobs
    obs(i).time.time=obs0(i,1);
    obs(i).time.sec=obs0(i,2);
    obs(i).sat=obs0(i,3);
    obs(i).P=obs0(i,4:6);
    obs(i).L=obs0(i,7:9);
    obs(i).D=obs0(i,10:12);
    obs(i).S=obs0(i,13:15);
    obs(i).LLI=obs0(i,16:18);
    obs(i).code=obs0(i,19:21);
end

return

