function ins=vel_constraint(v,H,R,ins,stat)

global glc
if stat==glc.SOLQ_FIX
    x_pre=ins.xa; P_pre=ins.Pa;
else
    x_pre=ins.x; P_pre=ins.P;
end

nx=size(x_pre,1);
K=P_pre*H'*(H*P_pre*H'+R)^-1;
x=K*v;
P=(eye(nx)-K*H)*P_pre;

ins.Cnb = (eye(3)+askew(x(1:3)))*ins.Cnb;
ins.att = Cnb2att(ins.Cnb);
ins.vel = ins.vel-x(4:6);
ins.pos = ins.pos-x(7:9);
ins.bg  = ins.bg+x(10:12);
ins.ba  = ins.ba+x(13:15);

if stat==glc.SOLQ_FIX
    ins.xa = [ins.att;ins.vel;ins.pos;ins.bg;ins.ba];
    ins.Pa = P;
else
    ins.x = [ins.att;ins.vel;ins.pos;ins.bg;ins.ba];
    ins.P = P;
end

return

