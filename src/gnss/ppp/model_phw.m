function [phw,stat]=model_phw(time,sat,type,opt,rs,rr,vs,phw0)

stat=1; ds=zeros(1,3); dr=zeros(1,3);
if opt==0,phw=phw0;stat=0;return;end

%satellite yaw attitude model
[exs,eys]=sat_yaw(time,sat,type,opt,rs,vs);

%unit vector satellite to receiver
r=rr-rs;
ek=r/norm(r);

%unit vectors of receiver antenna
[~,E]=xyz2blh(rr);
exr(1)= E(2); exr(2)= E(5); exr(3)= E(8); %x = north
eyr(1)=-E(1); eyr(2)=-E(4); eyr(3)=-E(7); %y = west

%phase windup effect
eks=cross(ek,eys);
ekr=cross(ek,eyr);
for i=1:3
    ds(i)=exs(i)-ek(i)*dot(ek,exs')-eks(i);
    dr(i)=exr(i)-ek(i)*dot(ek,exr')+ekr(i);
end
cosp=dot(ds,dr)/norm(ds)/norm(dr);
if cosp<-1
    cosp=-1;
elseif cosp>1
    cosp=1;
end

ph=acos(cosp)/2/pi;
drs=cross(ds,dr);
tmp=dot(ek,drs);
if tmp<0
    ph=-ph;
end
phw=ph+floor(phw0-ph+0.5);

return

