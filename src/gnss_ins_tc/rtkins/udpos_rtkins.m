function rtk=udpos_rtkins(rtk,tt) %#ok

ins=rtk.ins;
rtk.x(1:15)=0;   
rtk.P(1:15,1:15)=0;

% lever arm correction
pos=ins.pos+ins.Mpv*ins.Cnb*ins.lever;
vel=ins.vel+ins.Cnb*askew(ins.web)*ins.lever;

rtk.x(1:15)=[ins.att;vel;pos;ins.bg;ins.ba];
rtk.P(1:15,1:15)=ins.P;

return