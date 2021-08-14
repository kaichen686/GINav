function [geph,stat]=searchgeph(time,sat,iode,nav)

global glc;
stat=1; j=-1;
tmax=glc.MAXDTOE_GLO;
tmin=tmax+1;

for i=1:nav.ng
    if nav.geph(i).sat~=sat,continue; end
    if iode>=0&&nav.geph(i).iode~=iode,continue; end
    t=abs(timediff(nav.geph(i).toe,time));
    if t>tmax,continue; end
    if iode>=0, geph=nav.geph(i);return;end
    if t<=tmin,j=i;tmin=t;end
end

if iode>=0||j<0
    geph=NaN; stat=0; return;
end

geph=nav.geph(j);
return;
