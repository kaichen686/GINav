function k=ionmapf(pos,azel)

global glc;

if pos(3)>=glc.HION 
    k=1; return;
end

k=1/cos(asin((glc.RE_WGS84+pos(3))/(glc.RE_WGS84+glc.HION)*sin(pi/2-azel(2))));

return;