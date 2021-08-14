function sv=eph2pos(time,eph,sv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% claculate satellite position and velocity using broadcast ephemeris
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc
MU_GPS   =3.9860050E14;     % gravitational constant         
MU_GAL   =3.986004418E14;   % earth gravitational constant   
MU_BDS   =3.986004418E14;   % earth gravitational constant  
OMGE_GAL =7.2921151467E-5;  % earth angular velocity (rad/s) 
OMGE_BDS =7.292115E-5;      % earth angular velocity (rad/s)
RTOL_KEPLER =1E-13;  
MAX_ITER_KEPLER =30;
SIN_5 =-0.0871557427476582; % sin(-5.0 deg) 
COS_5  =0.9961946980917456; % cos(-5.0 deg) 

if eph.A<=0,return;end

tk=timediff(time,eph.toe);
[sys,prn]=satsys(eph.sat);
switch sys
    case glc.SYS_GAL, mu=MU_GAL;omge=OMGE_GAL;
    case glc.SYS_BDS, mu=MU_BDS;omge=OMGE_BDS;
    otherwise,        mu=MU_GPS;omge=glc.OMGE;
end

M=eph.M0+(sqrt(mu/(eph.A*eph.A*eph.A))+eph.deln)*tk;

n=0; E=M; Ek=0;
while abs(E-Ek)>RTOL_KEPLER&&n<MAX_ITER_KEPLER
    Ek=E;
    E=E-(E-eph.e*sin(E)-M)/(1-eph.e*cos(E));
    n=n+1;
end

if n>=MAX_ITER_KEPLER
    return;
end
sinE=sin(E);cosE=cos(E);

u=atan2(sqrt(1.0-eph.e*eph.e)*sinE,cosE-eph.e)+eph.omg;
r=eph.A*(1.0-eph.e*cosE); 
i=eph.i0+eph.idot*tk; 
sin2u=sin(2.0*u); cos2u=cos(2.0*u);
u=u+eph.cus*sin2u+eph.cuc*cos2u; 
r=r+eph.crs*sin2u+eph.crc*cos2u; 
i=i+eph.cis*sin2u+eph.cic*cos2u; 
x=r*cos(u); y=r*sin(u); cosi=cos(i);

if sys==glc.SYS_BDS&&(eph.flag==2||(eph.flag==0&&prn<=5))
    O=eph.OMG0+eph.OMGd*tk-omge*eph.toes;
    sinO=sin(O); cosO=cos(O);
    xg=x*cosO-y*cosi*sinO;
    yg=x*sinO+y*cosi*cosO;
    zg=y*sin(i);
    sino=sin(omge*tk); coso=cos(omge*tk);
    rs= [xg*coso+yg*sino*COS_5+zg*sino*SIN_5;
        -xg*sino+yg*coso*COS_5+zg*coso*SIN_5;
        -yg*SIN_5+zg*COS_5];
else
    O=eph.OMG0+(eph.OMGd-omge)*tk-omge*eph.toes; 
    sinO=sin(O); cosO=cos(O);
    rs=[x*cosO-y*cosi*sinO; 
        x*sinO+y*cosi*cosO;
        y*sin(i)];
end


tk=timediff(time,eph.toc);
dts=eph.f0+eph.f1*tk+eph.f2*tk*tk;
dts=dts-2*sqrt(mu*eph.A)*eph.e*sinE/(glc.CLIGHT)^2;
vars=var_uraeph(sys,eph.sva);

sv.pos=rs;
sv.dts=dts;
sv.vars=vars;  

return

