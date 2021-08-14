function [xp_bar,yp_bar]=iers_mean_pole(tut)

ep2000=[2000,1,1,0,0,0];

y=timediff(tut,epoch2time(ep2000))/86400.0/365.25;

if y<3653.0/365.25  %until 2010
    y2=y*y; y3=y2*y;
    xp_bar=55.974+1.8243*y+0.18413*y2+0.007024*y3;%(mas)
    yp_bar=346.346+1.7896*y-0.10729*y2-0.000908*y3;   
else %after 2010
    xp_bar=23.513+7.6141*y;%(mas)
    yp_bar=358.891-0.6287*y;
end

return