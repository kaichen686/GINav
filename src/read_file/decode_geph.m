function [geph,stat]=decode_geph(ver,sat,toc,data)
global glc gls

geph=gls.geph;
stat=1;

[sys,~]=satsys(sat);
if sys~=glc.SYS_GLO
    stat=0;return;
end

geph.sat=sat;

% toc rounded by 15 min in utc
[week,tow]=time2gpst(toc);
toc=gpst2time(week,floor((tow+450)/900)*900);
dow=fix(floor(tow/86400));

% time of frame in utc
if ver<=2.99
    tod=data(3);
else
    tod=rem(data(3),86400);
end
tof=gpst2time(week,tod+dow*86400);
tof=adjday(tof,toc);

geph.toe=utc2gpst(toc);
geph.tof=utc2gpst(tof);

geph.iode=fix(rem(tow+10800,86400)/900+0.5);

geph.taun=-data(1);
geph.gamn=data(2);

geph.pos=[data(4);data(8);data(12)]*1e3;
geph.vel=[data(5);data(9);data(13)]*1e3;
geph.acc=[data(6);data(10);data(14)]*1e3;

geph.svh=fix(data(7));
geph.frq=fix(data(11));
geph.age=fix(data(15));

% some receiver output >128 for minus frequency number
if geph.frq>128
    geph.frq=geph.frq-256;
end

return

