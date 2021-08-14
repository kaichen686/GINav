function [sec,day]=time2sec(time)

ep=time2epoch(time);
sec=ep(4)*3600+ep(5)*60+ep(6);
ep(4)=0;ep(5)=0;ep(6)=0;
day=epoch2time(ep);

return