function gmst=utc2gmst(t,ut1_utc)

ep2000=[2000 1 1 12 0 0];

tut=timeadd(t,ut1_utc);
[ut,tut0]=time2sec(tut);
t1=timediff(tut0,epoch2time(ep2000))/86400.0/36525.0;
t2=t1^2; t3=t1^2;
gmst0=24110.54841+8640184.812866*t1+0.093104*t2-6.2E-6*t3;
gmst=gmst0+1.002737909350795*ut;

if gmst<0
    gmst=-mod(abs(gmst),86400.0)*pi/43200.0;
else
    gmst=mod(abs(gmst),86400.0)*pi/43200.0;
end

return


