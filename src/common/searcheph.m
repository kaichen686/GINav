function [eph,stat]=searcheph(time,sat,iode,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%search the corresponding navigation meassage
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc;
eph_sel=[0,0,1,0,0];%ephemeris selections  /GPS,GLO,GAL,BDS,QZS
stat=1; sel=0; j=-1;

[sys,~]=satsys(sat);

switch sys
    case glc.SYS_GPS,tmax=glc.MAXDTOE+1;     sel=eph_sel(1);
    case glc.SYS_GAL,tmax=glc.MAXDTOE_GAL;   sel=eph_sel(3);
    case glc.SYS_BDS,tmax=glc.MAXDTOE_BDS+1; sel=eph_sel(4);
    case glc.SYS_QZS,tmax=glc.MAXDTOE_QZS+1; sel=eph_sel(5);
    otherwise, tmax=glc.MAXDTOE+1;            
end
tmin=tmax+1;

for i=1:nav.n
    if nav.eph(i).sat~=sat;continue;end
    if iode>0&&nav.eph(i).iode~=iode,continue;end
    if sys==glc.SYS_GAL&&sel~=0
        if sel==1&&~bitand(nav.eph(i).code,bitshift(1,9)), continue; end
        if sel==2&&~bitand(nav.eph(i).code,bitshift(1,8)), continue; end
    end
    t=abs(timediff(nav.eph(i).toe,time));
    if t>tmax, continue; end
    if iode>=0,eph=nav.eph(i);return;end
    if t<=tmin,j=i;tmin=t;end
end

if iode>=0||j<0
    eph=0; stat=0; return;
end

eph=nav.eph(j);

return;
