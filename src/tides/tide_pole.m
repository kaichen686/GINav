function denu=tide_pole(tut,pos,erpv)

AS2R=pi/180/3600;

% iers mean pole
[xp_bar,yp_bar]=iers_mean_pole(tut);

m1=erpv(1)/AS2R-xp_bar*1e-3;
m2=-erpv(2)/AS2R+yp_bar*1e-3;

% sin(2*theta) = sin(2*phi), cos(2*theta)=-cos(2*phi)
cosl=cos(pos(2));
sinl=sin(pos(2));
denu(1)=  9E-3*sin(pos(1))    *(m1*sinl-m2*cosl); %de= Slambda (m) 
denu(2)= -9E-3*cos(2.0*pos(1))*(m1*cosl+m2*sinl); %dn=-Stheta  (m) 
denu(3)=-33E-3*sin(2.0*pos(1))*(m1*cosl+m2*sinl); %du= Sr      (m) 

return