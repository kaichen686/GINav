function t=eph2clk(time,eph)

t=timediff(time,eph.toc);
for i=1:3
    t=t-(eph.f0+eph.f1*t+eph.f2*t^2);
end

t=eph.f0+eph.f1*t+eph.f2*t^2;

return