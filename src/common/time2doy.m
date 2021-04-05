function doy=time2doy(time)

ep=time2epoch(time);
ep(2)=1;ep(3)=1;ep(4)=0;ep(5)=0;ep(6)=0;
doy=timediff(time,epoch2time(ep))/86400+1;

return
