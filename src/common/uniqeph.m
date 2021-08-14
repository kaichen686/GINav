function nav=uniqeph(nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gls;
eph0=nav.eph;
A=zeros(nav.n,3);
eph1=repmat(gls.eph,nav.n,1);

% sort
for i=1:nav.n
    A(i,:)=[eph0(i).ttr.time,eph0(i).toe.time,eph0(i).sat];
end
[~,index]=sortrows(A);
for i=1:nav.n
    eph1(i)=eph0(index(i));
end
clear eph0;

% unique
j=1;
for i=2:nav.n
    if eph1(i).sat~=eph1(j).sat||eph1(i).iode~=eph1(j).iode
        j=j+1;
        eph1(j)=eph1(i);
    end
end
nav.n=j;

eph2=repmat(gls.eph,nav.n,1);
for i=1:nav.n
    eph2(i)=eph1(i);
end
clear eph1;

nav=rmfield(nav,'eph');
nav.eph=eph2;

return

