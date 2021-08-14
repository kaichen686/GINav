function sv=geph2pos(time,geph,sv)

TSTEP=60.0; 
ERREPH_GLO=5.0; 

t=timediff(time,geph.toe);
dts=-geph.taun+geph.gamn*t;

x(1:3)=geph.pos;
x(4:6)=geph.vel;

if t<0,tt=-TSTEP;else,tt=TSTEP;end

while abs(t)>1E-9
    if abs(t)<TSTEP,tt=t;end
    x=glorbit(tt,x,geph.acc);
    t=t-tt;
end

rs=x(1:3);
vars=ERREPH_GLO^2;

sv.pos=rs'; sv.dts=dts; sv.vars=vars;

return