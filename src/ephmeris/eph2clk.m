function t=eph2clk(time,eph)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
t=timediff(time,eph.toc);
for i=1:3
    t=t-(eph.f0+eph.f1*t+eph.f2*t^2);
end

t=eph.f0+eph.f1*t+eph.f2*t^2;

return