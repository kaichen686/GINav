function [satclk0,varc0,stat]=pephclk(time,sat,nav,satclk0,varc0)

global glc
stat=1;

if nav.nc<2||timediff(time,nav.peph(1).time)<-900||...
        timediff(time,nav.peph(end).time)>900
    return;
end

%binary search
i=0; j=nav.nc-1;
while i<j
    k=fix((i+j)/2);
    if timediff(nav.pclk(k+1).time,time)<0
        i=k+1;
    else
        j=k;
    end
end

if i<=0,idx=0; else,idx=i-1; end
idx=idx+1;

%linear interpolation for clock
t0=timediff(time,nav.pclk(idx).time);
t1=timediff(time,nav.pclk(idx+1).time);
c0=nav.pclk(idx).clk(sat);
c1=nav.pclk(idx+1).clk(sat);

if t0<=0
    satclk=c0;
    if satclk==0,stat=0;return;end
    varc=(nav.pclk(idx).std(sat)*glc.CLIGHT-1E-3*t0)^2;
elseif t1>=0
    satclk=c1;
    if satclk==0,stat=0;return;end
    varc=(nav.pclk(idx+1).std(sat)*glc.CLIGHT+1E-3*t1)^2;
elseif c0~=0 && c1~=0
    satclk=(c1*t0-c0*t1)/(t0-t1);
    if abs(t0)-abs(t1)>0
        varc=(nav.pclk(idx+1).std(sat)*glc.CLIGHT+1E-3*abs(t1))^2;
    else
        varc=(nav.pclk(idx).std(sat)*glc.CLIGHT+1E-3*abs(t0))^2;
    end
else
    stat=0; return;
end

if satclk~=0
    satclk0=satclk;
    varc0=varc;
end

return

