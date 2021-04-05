function dr=tide_pl(eu,rp,GMp,pos)

global glc
GME=3.986004415E+14; %earth gravitational constant
H3=0.292; L3=0.015;
dr=zeros(3,1);

r=norm(rp);
if r<=0,return;end

ep=rp/r;

K2=GMp/GME*glc.RE_WGS84^4/r^3;
K3=K2*glc.RE_WGS84/r;
latp=asin(ep(3)); lonp=atan2(ep(2),ep(1));
cosp=cos(latp); sinl=sin(pos(1)); cosl=cos(pos(1));

%step1 in phase (degree2)
p=(3*sinl*sinl-1)/2;
H2=0.6078-0.0006*p;
L2=0.0847+0.0002*p;
a=dot(ep,eu);
dp=K2*3*L2*a;
du=K2*(H2*(1.5*a^2-0.5)-3*L2*a^2);

%step1 in phase (degree3)
dp=dp+K3*L3*(7.5*a^2-1.5);
du=du+K3*(H3*(2.5*a^3-1.5*a)-L3*(7.5*a^2-1.5)*a);

%step1 out-of-phase (only radial)
du=du+3.0/4.0*0.0025*K2*sin(2.0*latp)*sin(2.0*pos(1))*sin(pos(2)-lonp);
du=du+3.0/4.0*0.0022*K2*cosp*cosp*cosl*cosl*sin(2.0*(pos(2)-lonp));

dr(1)=dp*ep(1)+du*eu(1);
dr(2)=dp*ep(2)+du*eu(2);
dr(3)=dp*ep(3)+du*eu(3);

return

