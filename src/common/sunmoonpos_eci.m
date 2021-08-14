function [rsun,rmoon]=sunmoonpos_eci(tut)

AU=149597870691.0; D2R=pi/180; RE_WGS84=6378137.0;
ep2000=[2000 1 1 12 0 0];

t=timediff(tut,epoch2time(ep2000))/86400.0/36525.0;

%astronomical parameter
f=ast_args(t);

%obliquity of the ecliptic
eps=23.439291-0.0130042*t;
sine=sin(eps*D2R); cose=cos(eps*D2R);

%sun position in eci
Ms=357.5277233+35999.05034*t;
ls=280.460+36000.770*t+1.914666471*sin(Ms*D2R)+0.019994643*sin(2.0*Ms*D2R);
rs=AU*(1.000140612-0.016708617*cos(Ms*D2R)-0.000139589*cos(2.0*Ms*D2R));
sinl=sin(ls*D2R); cosl=cos(ls*D2R);
rsun(1,1)=rs*cosl;
rsun(2,1)=rs*cose*sinl;
rsun(3,1)=rs*sine*sinl;

%moon position in eci
lm=218.32+481267.883*t+6.29*sin(f(1))-1.27*sin(f(1)-2.0*f(4))+...
    0.66*sin(2.0*f(4))+0.21*sin(2.0*f(1))-0.19*sin(f(2))-0.11*sin(2.0*f(3));
pm=5.13*sin(f(3))+0.28*sin(f(1)+f(3))-0.28*sin(f(3)-f(1))-...
    0.17*sin(f(3)-2.0*f(4));
rm=RE_WGS84/sin((0.9508+0.0518*cos(f(1))+0.0095*cos(f(1)-2.0*f(4))+...
    0.0078*cos(2.0*f(4))+0.0028*cos(2.0*f(1)))*D2R);
sinl=sin(lm*D2R); cosl=cos(lm*D2R);
sinp=sin(pm*D2R); cosp=cos(pm*D2R);
rmoon(1,1)=rm*cosp*cosl;
rmoon(2,1)=rm*(cose*cosp*sinl-sine*sinp);
rmoon(3,1)=rm*(sine*cosp*sinl+cose*sinp);

return

