function ion = iono_klbc(time,pos,azel,ionpar)

global glc;
ion_default=[0.1118E-07,-0.7451E-08,-0.5961E-07, 0.1192E-06,...
        0.1167E+06,-0.2294E+06,-0.1311E+06, 0.1049E+07];%2004/1/1
    
if pos(3)<-10^3||azel(2)<=0
    ion=0;
    return;
end

if sqrt(dot(ionpar,ionpar))<=0
    ionpar=ion_default;
end

azel=azel*180/pi;
ion = zeros(size(azel,1));
lat=pos(1)*180/pi;
lon=pos(2)*180/pi;
az=azel(1);
el=azel(2);

%ionospheric parameters
a0 = ionpar(1);
a1 = ionpar(2);
a2 = ionpar(3);
a3 = ionpar(4);
b0 = ionpar(5);
b1 = ionpar(6);
b2 = ionpar(7);
b3 = ionpar(8);

%elevation from 0 to 90 degrees
el = abs(el);

%conversion to semicircles
lat = lat / 180;
lon = lon / 180;
az = az / 180;
el = el / 180;

f = 1 + 16*(0.53-el).^3;

psi = (0.0137 ./ (el+0.11)) - 0.022;

phi = lat + psi .* cos(az*pi);
phi(phi > 0.416)  =  0.416;
phi(phi < -0.416) = -0.416;

lambda = lon + ((psi.*sin(az*pi)) ./ cos(phi*pi));

ro = phi + 0.064*cos((lambda-1.617)*pi);

[~,sow]=time2gpst(time);
t = lambda*43200 + sow;
t = mod(t,86400);


a = a0 + a1*ro + a2*ro.^2 + a3*ro.^3;
a(a < 0) = 0;

p = b0 + b1*ro + b2*ro.^2 + b3*ro.^3;
p(p < 72000) = 72000;

x = (2*pi*(t-50400)) ./ p;

%ionospheric delay
index = find(abs(x) < 1.57);
ion(index,1) = glc.CLIGHT * f(index) .* (5e-9 + a(index) .* (1 - (x(index).^2)/2 + (x(index).^4)/24));
index = find(abs(x) >= 1.57);
ion(index,1) = glc.CLIGHT * f(index) .* 5e-9;

return;
    






	
	
