function [x,VAR]=least_square(v,H,P)

%normal vector
N = (H'*P*H);

%cumpute unknown parameter
x = (N^-1)*H'*P*v;

%convariance of parameter
VAR = N^-1;

return