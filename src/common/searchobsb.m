function [obs,nobs]=searchobsb(obss,time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%search base station observations
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc gls

obs=repmat(gls.obs_tmp,glc.MAXOBS,1);

time0=obss.data(:,1)+obss.data(:,2);
time1=time.time+time.sec;

idx=abs(time0-time1)<=glc.MAXAGE; time_tmp=time0(idx);
if ~any(idx),obs=NaN;nobs=0;return;end

dt=abs(time_tmp-time1); mindt=min(dt); 
idx=(dt==mindt); 
if any(idx)
    mintime0=time_tmp(idx); mintime=mintime0(1);
    idx=(time0==mintime);
    obs0=obss.data(idx,:);  nobs=size(obs0,1);
else
    obs=NaN; nobs=0; return;
end

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

obs(nobs+1:end,:)=[];

return

