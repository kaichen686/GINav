function R=ddcov(nb,n,Ri,Rj,nv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
R=zeros(nv,nv);
k=0;

for b=1:n
    for i=1:nb(b)
        for j=1:nb(b)
            if i==j
                R(k+i,k+j)=Ri(k+i)+Rj(k+j);
            else
                R(k+i,k+j)=Ri(k+i);
            end
        end
    end
    k=k+nb(b);
end

return