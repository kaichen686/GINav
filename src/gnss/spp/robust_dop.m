function [v,H,P]=robust_dop(v0,H0,P0)

[nv0,nl]=size(H0);
exc=zeros(nv0,1); n=0; MAX_DISTANCE=0.2;
v=zeros(nv0,1); H=zeros(nv0,nl); P=zeros(nv0,nv0); ave_distance=zeros(nv0,1);

for i=1:nv0
    vi=abs(v0(i));
    if vi<MAX_DISTANCE,continue;end
    v_other=abs(v0);v_other(i)=[];
    ave_v=sum(abs(v_other))/(nv0-1);
    ave_distance(i)=sum(abs(vi-v_other))/(nv0-1); 
    if ave_distance(i)>3*ave_v&&ave_distance(i)>10
        exc(i)=1;
    end
end

for i=1:nv0
    if exc(i)==1,continue;end
    v(n+1)=v0(i);
    H(n+1,:)=H0(i,:);
    P(n+1,n+1)=P0(i,i);
    n=n+1;
end

if n<nv0
    v(n+1:end,:)=[]; H(n+1:end,:)=[]; P(n+1:end,:)=[]; P(:,n+1:end)=[];
end

return

