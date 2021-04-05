function [U,gmst]=eci2ecef(tutc,erpv)

persistent tutc_ U_ gmst_
ep2000=[2000 1 1 12 0 0];
AS2R=pi/180/3600;

if isempty(tutc_)
    tutc_.time=0; tutc_.sec=0;
end

if abs(timediff(tutc,tutc_))<0.01
    U=U_; gmst=gmst_; return;
end
tutc_=tutc;

%terrestrial time
tgps=utc2gpst(tutc_);
t=(timediff(tgps,epoch2time(ep2000))+19.0+32.184)/86400.0/36525.0; %t是一个差�?
t2=t^2; t3=t^3;

%astronomical parameter
f=ast_args(t);

%iau 1976 precession
ze=(2306.2181*t+0.30188*t2+0.017998*t3)*AS2R;
th=(2004.3109*t-0.42665*t2-0.041833*t3)*AS2R;
z =(2306.2181*t+1.09468*t2+0.018203*t3)*AS2R;
eps=(84381.448-46.8150*t-0.00059*t2+0.001813*t3)*AS2R;
R1=Rxyz(-z,3); R2=Rxyz(th,2); R3=Rxyz(-ze,3);
P=R1*R2*R3;

[dpsi,deps]=nut_iau1980(t,f);
R1=Rxyz(-eps-deps,1);R2= Rxyz(-dpsi,3); R3=Rxyz(eps,1);
N=R1*R2*R3;

%greenwich aparent sidereal time (rad)
gmst_=utc2gmst(tutc_,erpv(3));
gast=gmst_+dpsi*cos(eps);
gast=gast+(0.00264*sin(f(5))+0.000063*sin(2.0*f(5)))*AS2R;

%calculate the transformation matrix from ECI to ECEF
R1=Rxyz(-erpv(1),2); R2=Rxyz(-erpv(2),1); R3=Rxyz(gast,3);
W=R1*R2;
R=W*R3;
U_=R*N*P;

U=U_;
gmst=gmst_;

return

