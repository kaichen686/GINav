function [obs,nobs]=matchobs(rtk,imud,obss)

global gls
imu_sample_rate=rtk.opt.ins.sample_rate;
time0=obss.data(:,1)+obss.data(:,2);
 
time1=imud.time.time+imud.time.sec;

idx=abs(time1-time0)<(0.501/imu_sample_rate);

if any(idx)
    obs0=obss.data(idx,:);  nobs=size(obs0,1);
else
    obs=NaN; nobs=0; return;
end

obs_tmp=repmat(gls.obs_tmp,nobs,1);
for i=1:nobs
    obs_tmp(i).time.time=obs0(i,1);
    obs_tmp(i).time.sec=obs0(i,2);
    obs_tmp(i).sat=obs0(i,3);
    obs_tmp(i).P=obs0(i,4:6);
    obs_tmp(i).L=obs0(i,7:9);
    obs_tmp(i).D=obs0(i,10:12);
    obs_tmp(i).S=obs0(i,13:15);
    obs_tmp(i).LLI=obs0(i,16:18);
    obs_tmp(i).code=obs0(i,19:21);
end

[obs,nobs]=exclude_sat(obs_tmp,rtk);

return

