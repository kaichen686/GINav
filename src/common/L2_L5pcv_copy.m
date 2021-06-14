function nav=L2_L5pcv_copy(nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nav.ant_para.n==0,return;end
for i=1:nav.ant_para.n
    if norm(nav.ant_para.pcv(i).off(3,:))>0,continue;end
    nav.ant_para.pcv(i).off(3,:)=nav.ant_para.pcv(i).off(2,:);
    nav.ant_para.pcv(i).var(3,:)=nav.ant_para.pcv(i).var(2,:);
end

return