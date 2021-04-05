function [week,sow]=time2gpst(t)

gpst0=[1980,1, 6,0,0,0]; %gps time reference

t0=epoch2time(gpst0);

sec=t.time-t0.time;
week=fix(sec/7/86400);
sow=sec-week*7*86400+t.sec;

return