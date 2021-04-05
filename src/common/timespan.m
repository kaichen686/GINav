function tspan=timespan(rtk,obsr)

conf_ts=rtk.opt.ts; conf_te=rtk.opt.te;
obs_ts.time=obsr.data(1,1); obs_ts.sec=obsr.data(1,2);
obs_te.time=obsr.data(end,1); obs_te.sec=obsr.data(end,2);
dt=obsr.dt;

if conf_ts.time~=0&&timediff(conf_ts,obs_ts)>=0
    ts=conf_ts;
else
    ts=obs_ts;
end

if conf_te.time~=0&&timediff(conf_te,obs_te)<=0
    te=conf_te;
else
    te=obs_te;
end

tspan=fix(timediff(te,ts)/dt)+1;

return