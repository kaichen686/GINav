function [X,P,x_fb,stat]=sppins_filter(v,H,R,x_pre,P_pre)

nx=size(x_pre,1); 
X=zeros(nx,1); P=zeros(nx,nx); x_fb=zeros(nx,1); stat=1;

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

Cnb = att2Cnb(x_pre(1:3));
Cnb = (eye(3)+askew(x(1:3)))*Cnb;
if ~isreal(Cnb)
    stat=0; return;
end
att = Cnb2att(Cnb);
vel = x_pre(4:6)-x(4:6);
pos = x_pre(7:9)-x(7:9);
bg  = x_pre(10:12)+x(10:12);
ba  = x_pre(13:15)+x(13:15);

X(1:15,1)  = [att;vel;pos;bg;ba];
X(16:nx,1) = x_pre(16:end)+x(16:end);

x_fb=x;

return

