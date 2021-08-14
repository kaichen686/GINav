function [satpos,satclk,vare,varc,stat]=pephpos(time,sat,nav)

global glc
stat=1; norder=10; %polynomial fitting order
tdiff=zeros(norder+1,1); p=zeros(3,norder+1);
satpos=zeros(3,1); s=zeros(3,1); satclk=0;
varc=0;vare=0;

if nav.np<norder||timediff(time,nav.peph(1).time)<-900||...
        timediff(time,nav.peph(end).time)>900
    stat=0; return;
end

%binary search
i=0;
j=nav.np-1;
while i<j
    k=fix((i+j)/2);
    if timediff(nav.peph(k+1).time,time)<0
        i=k+1;
    else
        j=k;
    end
end

if i<=0,index=0;  else,index=i-1;  end
index=index+1;

idx=index-norder/2; %start of fitting interval
if idx<1,idx=1;  elseif idx+norder>nav.np,idx=nav.np-norder;  end

nt=1;
for j=0:norder
    tdiff(nt)=timediff(nav.peph(idx+j).time,time); %time difference
    nt=nt+1;
    if dot(nav.peph(idx+j).pos(sat,1:3),nav.peph(idx+j).pos(sat,1:3))<=0
        stat=0; return;
    end
end

for j=0:norder
    pos=nav.peph(idx+j).pos(sat,:);
    
    %correciton for earh rotation
    sinl=sin(glc.OMGE*tdiff(j+1));
    cosl=cos(glc.OMGE*tdiff(j+1)); 
    
    p(1,j+1)=cosl*pos(1)-sinl*pos(2);
    p(2,j+1)=sinl*pos(1)+cosl*pos(2);
    p(3,j+1)=pos(3);
    
end

%polynomial interpolation using Neville's algorithm
for i=1:3
    satpos(i,1)=polyinter(tdiff,p(i,:)); 
end

%calculate satellite position variance
for i=1:3
    s(i)=nav.peph(index).std(sat,i);
end
std=sqrt(dot(s,s)); %error caused by ephemeris
if tdiff(1)>0 
    std=std+(5E-7*tdiff(1)^2)/2; %error caused by fitting
elseif tdiff(end)<0
    std=std+(5E-7*tdiff(end)^2)/2;
end
vare=std^2;

%linear interpolation for clock
t0=timediff(time,nav.peph(index).time);
t1=timediff(time,nav.peph(index+1).time);
c0=nav.peph(index).pos(sat,4);
c1=nav.peph(index+1).pos(sat,4);

if t0<=0
    satclk=c0;
    if satclk~=0
        varc=(nav.peph(index).std(sat,4)*glc.CLIGHT-1E-3*t0)^2;
    end
elseif t1>=0
    satclk=c1;
    if satclk~=0
        varc=(nav.peph(index+1).std(sat,4)*glc.CLIGHT+1E-3*t1)^2;
    end
elseif c0~=0 && c1~=0
    satclk=(c1*t0-c0*t1)/(t0-t1);
    if abs(t0)-abs(t1)>0
        varc=(nav.peph(index+1).std(sat,4)*glc.CLIGHT+1E-3*abs(t1))^2;
    else
        varc=(nav.peph(index).std(sat,4)*glc.CLIGHT+1E-3*abs(t0))^2;
    end
else
    satclk=0;
    varc=0;
end

return

