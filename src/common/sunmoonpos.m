function [rsun,rmoon,gmst]=sunmoonpos(tutc,erpv)

tut=timeadd(tutc,erpv(3));

%calculate sun and moon position in ECI
[rsun,rmoon]=sunmoonpos_eci(tut);

%calculate the transition matrix from ECI to ECEF
[U,gmst]=eci2ecef(tutc,erpv);

%calculate sun and moon position in ECEF
rsun=U*rsun;
rmoon=U*rmoon;

return