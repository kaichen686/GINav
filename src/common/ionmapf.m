function k=ionmapf(pos,azel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc;

if pos(3)>=glc.HION 
    k=1; return;
end

k=1/cos(asin((glc.RE_WGS84+pos(3))/(glc.RE_WGS84+glc.HION)*sin(pi/2-azel(2))));

return;