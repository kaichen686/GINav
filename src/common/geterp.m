function erpv=geterp(time,erp)

erpv=zeros(5,1);
ep=[2000,1,1,12,0,0];

if erp.n<=0,return;end
    
mjd=51544.5+(timediff(gpst2utc(time),epoch2time(ep)))/86400.0;

if mjd<=erp.data(1).mjd
    day=mjd-erp.data(1).mjd;
    erpv(1)=erp.data(1).xp     +erp.data(1).xpr*day;
    erpv(2)=erp.data(1).yp     +erp.data(1).ypr*day;
    erpv(3)=erp.data(1).ut1_utc-erp.data(1).lod*day;
    erpv(4)=erp.data(1).lod;
    return;
end

if mjd>=erp.data(erp.n).mjd
    day=mjd-erp.data(erp.n).mjd;
    erpv(1)=erp.data(erp.n).xp     +erp.data(erp.n).xpr*day;
    erpv(2)=erp.data(erp.n).yp     +erp.data(erp.n).ypr*day;
    erpv(3)=erp.data(erp.n).ut1_utc-erp.data(erp.n).lod*day;
    erpv(4)=erp.data(erp.n).lod;
    return;
end

j=0;
k=erp.n-1;
while j<k-1
    i=fix((j+k)/2);
    if mjd<erp.data(i+1).mjd
        k=i;
    else
        j=i;
    end
end
j=j+1;
if erp.data(j).mjd==erp.data(j+1).mjd
    a=0.5;
else
    a=(mjd-erp.data(j).mjd)/(erp.data(j+1).mjd-erp.data(j).mjd);
end

erpv(1)=(1-a)*erp.data(j).xp     +a*erp.data(j+1).xp;
erpv(2)=(1-a)*erp.data(j).yp     +a*erp.data(j+1).yp;
erpv(3)=(1-a)*erp.data(j).ut1_utc+a*erp.data(j+1).ut1_utc;
erpv(4)=(1-a)*erp.data(j).lod    +a*erp.data(j+1).lod;

return

