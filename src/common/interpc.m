function K=interpc(coef,lat)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j=fix(lat/15);
if j<1
    K=coef(1); return;
end

if j>4
    K=coef(5); return;
end

K=coef(j)*(1-lat/15+j)+coef(j+1)*(lat/15-j);

return