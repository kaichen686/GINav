function t=timeadd(t0,sec)

t0.sec=t0.sec+sec;
tt=floor(t0.sec);
t.time=t0.time+fix(tt);
t.sec=t0.sec-tt;

return

