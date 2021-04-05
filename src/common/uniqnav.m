function nav=uniqnav(nav)

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