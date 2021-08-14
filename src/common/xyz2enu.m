function E=xyz2enu(pos)

sinp=sin(pos(1));cosp=cos(pos(1));sinl=sin(pos(2));cosl=cos(pos(2));
E=[-sinl       cosl        0.0;
   -sinp*cosl  -sinp*sinl  cosp;
    cosp*cosl  cosp*sinl  sinp];

return