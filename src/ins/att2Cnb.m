function Cnb = att2Cnb(att)

sina=sin(att); cosa=cos(att);
sinp=sina(1);  sinr=sina(2); siny=sina(3);
cosp=cosa(1);  cosr=cosa(2); cosy=cosa(3);
Cnb=[ cosr*cosy-sinp*sinr*siny, -cosp*siny,  sinr*cosy+sinp*cosr*siny;
      cosr*siny+sinp*sinr*cosy,  cosp*cosy,  sinr*siny-sinp*cosr*cosy;
                    -cosp*sinr,       sinp,                 cosp*cosr];

return