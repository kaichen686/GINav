function [exs,eys]=sat_yaw(time,sat,type,opt,rs,vs)

global glc
erpv=zeros(5,1); exs=zeros(1,3); eys=zeros(1,3);

[rsun,~,~]=sunmoonpos(gpst2utc(time),erpv);

%beta and orbit angle
ri=[rs;vs];
ri(4)=ri(4)-glc.OMGE*ri(2);
ri(5)=ri(5)+glc.OMGE*ri(1);
n=cross(ri(1:3),ri(4:6));
p=cross(rsun,n);
es=rs/norm(rs);
esun=rsun/norm(rsun);
en=n/norm(n);
ep=p/norm(p);
beta=pi/2-acos(dot(esun,en));
E=acos(dot(es,ep));
tmp=dot(es,esun);
if tmp<=0
    tmp1=-E;
else
    tmp1=E;
end
mu=pi/2+tmp1;
if mu<-pi/2
    mu=mu+2*pi;
elseif mu>=pi/2
    mu=mu-2*pi;
end

%yaw-angle of satellite
yaw=yaw_angle(sat,type,opt,beta,mu);

ex=cross(en,es);
cosy=cos(yaw);
siny=sin(yaw);

for i=1:3
    exs(i)=-siny*en(i)+cosy*ex(i);
    eys(i)=-cosy*en(i)-siny*ex(i);
end

return
   
  