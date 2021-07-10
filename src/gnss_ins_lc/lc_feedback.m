function [ins,stat]=lc_feedback(ins,x_fb,P_fb)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stat=1;

if ~isreal(x_fb)||~isreal(P_fb)
    stat=0; return;
end

Cnb = (eye(3)+askew(x_fb(1:3)))*ins.Cnb;
if ~isreal(Cnb)
    stat=0;return;
end

ins.Cnb = Cnb;
ins.att = Cnb2att(ins.Cnb);
ins.vel = ins.vel-x_fb(4:6);
ins.pos = ins.pos-x_fb(7:9);
ins.bg  = ins.bg+x_fb(10:12);
ins.ba  = ins.ba+x_fb(13:15);
ins.x = [ins.att;ins.vel;ins.pos;ins.bg;ins.ba];
ins.P = P_fb;

return