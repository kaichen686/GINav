function stat=valsol(time,v,P,vsat,azel,opt)

global glc
%chi-sqr(n) (alpha=0.001)
chisqr=[      
    10.8,13.8,16.3,18.5,18.5,22.5,24.3,26.1,27.9,29.6,...
    31.3,32.9,34.5,36.1,37.7,39.3,40.8,42.3,43.8,45.3,...
    46.8,48.3,49.7,51.2,52.6,54.1,55.5,56.9,58.3,59.7,...
    61.1,62.5,63.9,65.2,66.6,68.0,69.3,70.7,72.1,73.4,...
    74.7,76.0,77.3,78.6,80.0,81.3,82.6,84.0,85.4,86.7,...
    88.0,89.3,90.6,91.9,93.3,94.7,96.0,97.4,98.7,100 ,...
    101 ,102 ,103 ,104 ,105 ,107 ,108 ,109 ,110 ,112 ,...
    113 ,114 ,115 ,116 ,118 ,119 ,120 ,122 ,123 ,125 ,...
    126 ,127 ,128 ,129 ,131 ,132 ,133 ,134 ,135 ,137 ,...
    138 ,139 ,140 ,142 ,143 ,144 ,145 ,147 ,148 ,149 ];
stat=1; nx=3+glc.NSYS;

%chi-square test for residuals
nv=size(v,1); var=P^-1;
for i=1:nv
    v(i)=v(i)/sqrt(var(i,i));
end
if nv>nx && dot(v,v)>chisqr(nv-nx)
    [wn,sow]=time2gpst(time);
    fprintf('Warning:GPS week = %d sow = %.3f,chi-square test error! v=%.3f \n',wn,sow,dot(v,v));
    stat=0;
    return;
end

%validate GDOP
ns=0; n=size(vsat,1); azels=zeros(n,2);
for i=1:n
    if vsat(i)==0,continue;end
    azels(ns+1,:)=azel(i,:);
    ns=ns+1;
end
if ns<n
    azels(ns+1:end,:)=[];
end

dop = dops(azels);
if dop(1)<0 || dop(1)>opt.maxgdop
    [wn,sow]=time2gpst(time);
    fprintf('Warning:GPS week = %d sow = %.3f,GDOP test error! GDOP=%.3f \n',wn,sow,dop(1));
    stat=0;
    return;
end

return

