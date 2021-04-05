function pos=ecef2pos(r)

FE_WGS84=1.0/298.257223563; RE_WGS84=6378137; e2=FE_WGS84*(2.0-FE_WGS84);
r2=dot(r(1:2),r(1:2));
v=RE_WGS84;
z=r(2);
zk=0;

while abs(z-zk)>1E-4
    zk=z;
    sinp=z/sqrt(r2+z*z);
    v=RE_WGS84/sqrt(1.0-e2*sinp*sinp);
    z=r(3)+v*e2*sinp;
end

if r2>1E-12
    pos(1)=atan(z/sqrt(r2));
    pos(2)=atan2(r(2),r(1));
else
    if r(3)>0
        pos(1)=pi/2;
    else
        pos(1)=-pi/2;
    end
    pos(2)=0;
end
pos(3)=sqrt(r2+z*z)-v;

return

