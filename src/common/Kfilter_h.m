function [x,P,stat]=Kfilter_h(v,H,R,x_pre,P_pre)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%the calculation efficiency is improved by compressing matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nv=size(v,1); nx=size(x_pre,1);
x=zeros(nx,1); P=zeros(nx,nx); stat=1;

zip_idx=zeros(nx,1);nz=0;
for i=1:nx
    if x_pre(i)~=0&&P_pre(i,i)~=0
        zip_idx(nz+1)=i;
        nz=nz+1;
    end
end
zip_idx(nz+1:end)=[];

H_=zeros(nv,nz); x_pre_=zeros(nz,1); P_pre_=zeros(nz,nz);
for i=1:nz
    x_pre_(i,1)=x_pre(zip_idx(i));
    for j=1:nz
        P_pre_(i,j)=P_pre(zip_idx(i),zip_idx(j));
    end
    for j=1:nv
        H_(j,i)=H(j,zip_idx(i));
    end
end

Q=H_*P_pre_*H_'+R;
if det(Q)==0
    stat=0; return;
end

nstate=size(x_pre_,1);
K=P_pre_*H_'*Q^-1;
x_out_=x_pre_+K*v;
P_out_=(eye(nstate)-K*H_)*P_pre_;

for i=1:nz
    x(zip_idx(i))=x_out_(i,1);
    for j=1:nz
        P(zip_idx(i),zip_idx(j))=P_out_(i,j);
    end
end

return

