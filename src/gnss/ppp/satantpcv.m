function dants=satantpcv(rs,rr,pcvs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ru=rr-rs;
rz=-rs;
eu=ru/norm(ru);
ez=rz/norm(rz);
cosa=dot(eu,ez);
if cosa<-1
    cosa=-1;
elseif cosa>1
    cosa=1;
end

nadir=acos(cosa);
dants=antmodel_s(pcvs,nadir);

return

