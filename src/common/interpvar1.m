function pcv=interpvar1(azim,zeni,pcvr,f)

i=fix((pcvr.zen2-pcvr.zen1)/pcvr.dzen)+1;

if i~=19
    fprintf('zen_interval_count~=19\n');
end

izeni=fix((zeni-pcvr.zen1)/pcvr.dzen);
iazim=fix(azim/pcvr.dazi);

p=zeni/pcvr.dzen-izeni;
q=azim/pcvr.dazi-iazim;

if p>=1||p<0||q>=1||q<0
    fprintf('interpvar %f\t%f\n',p,q);
end

pcv=(1-p)*(1-q)*pcvr.var(f,(iazim+0)*i+(izeni+0)+1)+...
       p *(1-q)*pcvr.var(f,(iazim+0)*i+(izeni+1)+1)+...
       q *(1-p)*pcvr.var(f,(iazim+1)*i+(izeni+0)+1)+...
       p *   q *pcvr.var(f,(iazim+1)*i+(izeni+1)+1);
   
return