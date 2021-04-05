function [v,H,var,n,vsat,idx]=robust_spp(v0,H0,var0,nv,vsat,idx,flag)

[nr,nl]=size(H0);
ave_distance=zeros(nv,1); exc=zeros(nv,1); n=0; %#ok
v=zeros(nr,1); H=zeros(nr,nl); var=zeros(nr,nr); 

if flag==0
    MAX_DISTANCE=3; %for pseudorange
else
    MAX_DISTANCE=0.2; %for doppler
end

for i=1:nv
    vi=abs(v0(i));
    if vi<MAX_DISTANCE,continue;end
    v_other=abs(v0);v_other(i)=[];v_other(nv:end,:)=[];
    
    if vi>3*sum(v_other)/(nv-1)
        exc(i)=1;
        vsat(idx(i))=0;
    end
end

for i=1:nv
    if exc(i)==1,continue;end
    v(n+1)=v0(i);
    H(n+1,:)=H0(i,:);
    var(n+1,n+1)=var0(i,i);
    n=n+1;
end


return

