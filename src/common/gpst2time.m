function t=gpst2time(week,sec)

gpst0=[1980,1, 6,0,0,0]; %gps time reference

t0=epoch2time(gpst0);

if sec<-1e9||sec>1e9,sec=0;end

t.time=t0.time+week*7*86400+fix(sec);
t.sec=sec-fix(sec);

return;