function t=bdt2time(week,sec)

bdt0 =[2006,1, 1,0,0,0]; %beidou time reference
t0=epoch2time(bdt0);

if sec<-1e9||sec>1e9,sec=0;end

t.time=t0.time+week*7*86400+fix(sec);
t.sec=sec-fix(sec);

return;