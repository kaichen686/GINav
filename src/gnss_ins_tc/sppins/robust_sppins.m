function [v,H,R,n]=robust_sppins(v0,H0,R0,flag)

[nv,nl]=size(H0); ave_distance=zeros(nv,1); exc=zeros(nv,1);
v=zeros(nv,1); H=zeros(nv,nl); R=zeros(nv,nv); n=0;

if flag==0
    MAX_DISTANCE=1.5; %for pseudorange
else
    MAX_DISTANCE=0.2; %for doppler
end

for i=1:nv
    vi=abs(v0(i));
    v_other=abs(v0);v_other(i)=[];
    ave_v=sum(abs(v_other))/(nv-1);
    
    % the average distance from the population value
    ave_distance(i)=sum(abs(vi-v_other))/(nv-1); 
    if ave_distance(i)>1.5*ave_v
        exc(i)=1;
    end
end

for i=1:nv
    if exc(i)==1,continue;end
    v(n+1)=v0(i);
    H(n+1,:)=H0(i,:);
    R(n+1,n+1)=R0(i,i);
    n=n+1;
end

if n<nv
    v(n+1:end,:)=[]; H(n+1:end,:)=[]; R(n+1:end,:)=[]; R(:,n+1:end)=[];
end

return

