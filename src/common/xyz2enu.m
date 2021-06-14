function E=xyz2enu(pos)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sinp=sin(pos(1));cosp=cos(pos(1));sinl=sin(pos(2));cosl=cos(pos(2));
E=[-sinl       cosl        0.0;
   -sinp*cosl  -sinp*sinl  cosp;
    cosp*cosl  cosp*sinl  sinp];

return