function [sv,stat0]=ephpos(time,teph,sat,nav,iode,sv) %#ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc gls
stat0=1; tt=1e-3; sv1=gls.sv;
[sys,~]=satsys(sat);

if sys==glc.SYS_GPS||sys==glc.SYS_GAL||sys==glc.SYS_BDS||sys==glc.SYS_QZS
%     [eph,stat]=searcheph(teph,sat,iode,nav);
    [eph,stat]=searcheph_h(teph,sat,-1,nav.eph);
    if stat==0,stat0=0;return;end
    sv=eph2pos(time,eph,sv);
    time=timeadd(time,tt);
    sv1=eph2pos(time,eph,sv1);
    sv.svh=eph.svh;
elseif sys==glc.SYS_GLO
%     [geph,stat]=searchgeph(teph,sat,iode,nav);
    [geph,stat]=searchgeph_h(teph,sat,-1,nav.geph);
    if stat==0,stat0=0;return;end
    sv=geph2pos(time,geph,sv);
    time=timeadd(time,tt);
    sv1=geph2pos(time,geph,sv1);
    sv.svh=geph.svh;
else
    stat0=0; return;
end

sv.vel=(sv1.pos-sv.pos)/tt;
sv.dtsd=(sv1.dts-sv.dts)/tt;

return

