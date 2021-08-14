function [x,P]=Kfilter(v,H,R,x_pre,P_pre)

nstate=size(x_pre,1);
K=P_pre*H'*(H*P_pre*H'+R)^-1;
x=x_pre+K*v;
P=(eye(nstate)-K*H)*P_pre;

return

