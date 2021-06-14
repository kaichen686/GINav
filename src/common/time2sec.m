function [sec,day]=time2sec(time)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ep=time2epoch(time);
sec=ep(4)*3600+ep(5)*60+ep(6);
ep(4)=0;ep(5)=0;ep(6)=0;
day=epoch2time(ep);

return