function [dts,stat0]=ephclk(time,obs,nav)

global glc
dts=0; stat0=1;
teph=obs.time; sat=obs.sat;
[sys,~]=satsys(sat);

if sys==glc.SYS_GPS||sys==glc.SYS_GAL||sys==glc.SYS_BDS||sys==glc.SYS_QZS
%     [eph,stat]=searcheph(teph,sat,-1,nav);
    [eph,stat]=searcheph_h(teph,sat,-1,nav.eph);
    if stat==0,stat0=0;return;end
    dts=eph2clk(time,eph);
elseif sys==glc.SYS_GLO
%     [geph,stat]=searchgeph(teph,sat,-1,nav);
    [geph,stat]=searchgeph_h(teph,sat,-1,nav.geph);
    if stat==0,stat0=0;return;end
    dts=geph2clk(time,geph);
else
    stat0=0; return;
end

return