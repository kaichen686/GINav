function [ins,stat]=lc_filter(v,H,R,x_pre,P_pre,ins)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nx=size(x_pre,1); stat=1;

Q=H*P_pre*H'+R;
if det(Q)==0
    stat=0; return;
end

K=P_pre*H'*Q^-1;
x=K*v;
P=(eye(nx)-K*H)*P_pre;

if ~isreal(x)||~isreal(P)
    stat=0;
end

Cnb = (eye(3)+askew(x(1:3)))*ins.Cnb;
if ~isreal(Cnb)
    stat=0;return;
end

ins.Cnb = Cnb;
ins.att = Cnb2att(ins.Cnb);
ins.vel = ins.vel-x(4:6);
ins.pos = ins.pos-x(7:9);
ins.bg  = ins.bg+x(10:12);
ins.ba  = ins.ba+x(13:15);
ins.x = [ins.att;ins.vel;ins.pos;ins.bg;ins.ba];
ins.P = P;

return

