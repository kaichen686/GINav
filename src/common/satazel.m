function azel=satazel(pos,LOS)

global glc

az=0;el=pi/2;

if pos(3)>-glc.RE_WGS84
    enu=ecef2enu(pos,LOS);
    if dot(enu,enu)<1e-12
        az=0;
    else
        az=atan2(enu(1),enu(2));
    end
    if az<0,az=az+2*pi;end
    el=asin(enu(3));
end

azel=[az,el];

return;


