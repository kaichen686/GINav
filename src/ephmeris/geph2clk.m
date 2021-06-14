function  dts=geph2clk(time,geph)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=timediff(time,geph.toe);
for i=1:3
    t=t-(-geph.taun+geph.gamn*t);
end

dts=-geph.taun+geph.gamn*t;

return