function [X,stat]=fix_state(x_float,x_fb)

nx=size(x_float,1); 
X=zeros(nx,1); stat=1;

Cnb = att2Cnb(x_float(1:3));
Cnb = (eye(3)+askew(x_fb(1:3)))*Cnb;
if ~isreal(Cnb)
    stat=0; return;
end

att = Cnb2att(Cnb);
vel = x_float(4:6)-x_fb(4:6);
pos = x_float(7:9)-x_fb(7:9);
bg  = x_float(10:12)+x_fb(10:12);
ba  = x_float(13:15)+x_fb(13:15);

X(1:15,1)  = [att;vel;pos;bg;ba];
X(16:nx,1) = x_float(16:end)+x_fb(16:end);

return

