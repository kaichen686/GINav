function value=interpvar(ang,var)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=ang/5;
i=fix(a);

if i<0
    value=var(1);
    return;
elseif i>19
    value=var(19);
    return;
end

value=(1-a+i)*var(i+1)+(a-i)*var(i+2);

return

