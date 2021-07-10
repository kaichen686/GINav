function nav=uniqnav(nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc;

if nav.n>0
    nav=uniqeph(nav);
end

if nav.ng>0
    nav=uniqgeph(nav);
end

for i=1:glc.MAXSAT
    for j=1:glc.MAXFREQ
        nav.lam(i,j)=satwavelen(i,j,nav);
    end
end

return