function nav=uniqgeph(nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gls;
geph0=nav.geph;
A=zeros(nav.ng,3);
geph1=repmat(gls.geph,nav.ng,1);

%sort geph
for i=1:nav.ng
    A(i,:)=[geph0(i).tof.time,geph0(i).toe.time,geph0(i).sat];
end
[~,index]=sortrows(A);
for i=1:nav.ng
    geph1(i)=geph0(index(i));
end
clear geph0;

%unique geph
j=1;
for i=2:nav.ng
    if geph1(i).sat~=geph1(j).sat||geph1(i).toe.time~=geph1(j).toe.time||geph1(i).svh~=geph1(j).svh
        j=j+1;
        geph1(j)=geph1(i);
    end
end

nav.ng=j;
geph2=repmat(gls.geph,nav.ng,1);
for i=1:nav.ng
    geph2(i)=geph1(i);
end
clear geph1;

nav=rmfield(nav,'geph');
nav.geph=geph2;

return

