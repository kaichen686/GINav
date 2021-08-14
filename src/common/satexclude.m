function stat=satexclude(sat,var,svh,opt)%#ok

global glc;
[sys,~]=satsys(sat);
if svh<0,stat=0;return; end

if sys==glc.SYS_QZS,svh=bitand(svh,254);end
if svh~=0,   stat=0;return;end
if var>300^2,stat=0;return;end
stat=1;


return;