function [x,P]=Kfilter(v,H,R,x_pre,P_pre)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nstate=size(x_pre,1);
K=P_pre*H'*(H*P_pre*H'+R)^-1;
x=x_pre+K*v;
P=(eye(nstate)-K*H)*P_pre;

return

