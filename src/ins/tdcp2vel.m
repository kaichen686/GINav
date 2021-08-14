function [vn,ins_align_flag]=tdcp2vel(rtk,nav,cur_obs,old_obs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
vn=zeros(1,3); ins_align_flag=0;
dt=timediff(cur_obs(1).time,old_obs(1).time);

cur_sv=satposs(cur_obs,nav,rtk.opt.sateph);
old_sv=satposs(old_obs,nav,rtk.opt.sateph);

cur_rr=rtk.sol.pos;  [cur_pos,Cne]=xyz2blh(cur_rr);
old_rr=rtk.sol.pos;  old_pos=xyz2blh(old_rr);

n_cur=size(cur_obs,1);
n_old=size(old_obs,1);
v=zeros(n_cur,1); H=zeros(n_cur,4); P=zeros(n_cur,n_cur);

nv=0;
for i=1:n_cur
    
    cur_obsi=cur_obs(i);cur_svi=cur_sv(i);
    lam=nav.lam(cur_obsi.sat,:);
    [sys,~]=satsys(cur_obsi.sat);
    if rtk.mask(sys)==0,continue;end
    
    if lam(1)==0,continue;end

    old_idx=0;
    for j=1:n_old
        if cur_obsi.sat==old_obs(j).sat
            old_idx=j;break;
        end
    end
    if old_idx==0,continue;end
    
    old_obsi=old_obs(old_idx); old_svi=old_sv(old_idx);
    
    if cur_svi.svh~=0||old_svi.svh~=0||norm(cur_svi.pos)<=0||norm(old_svi.pos)<=0
        continue;
    end
    if cur_obsi.L(1)==0||old_obsi.L(1)==0,continue;end
    
    [cur_range,cur_LOS]=geodist(cur_svi.pos,cur_rr'); 
    cur_azel=satazel(cur_pos,cur_LOS);
    [old_range,old_LOS]=geodist(old_svi.pos,old_rr'); 
    old_azel=satazel(old_pos',old_LOS); %#ok
    
    tdcp_obs=cur_obsi.L(1)*lam(1)-old_obsi.L(1)*lam(1);
    tdcp_pre=cur_range-old_range;
    
    v(nv+1,1)=tdcp_obs-tdcp_pre+glc.CLIGHT*(cur_svi.dts-old_svi.dts);
    
    H(nv+1,:)=[-cur_LOS,1];
    
    P(nv+1,nv+1)=(2*1^2/sin(cur_azel(2))^2)^-1;
    
    nv=nv+1;
    
    
end

if nv<4,return;end
if nv<n_cur
    v(nv+1:end,:)=[]; H(nv+1:end,:)=[]; P(nv+1:end,:)=[];P(:,nv+1:end)=[];
end

%robust
nv=size(v,1);exc=zeros(nv,1);
v0=zeros(nv,1); H0=zeros(nv,4); P0=zeros(nv,nv); n=0;
for i=1:nv
    vi=abs(v(i));
    v_other=abs(v);v_other(i)=[];
    ave_v=sum(abs(v_other))/(nv-1);
    % the average distance from the population value
    ave_distance=sum(abs(vi-v_other))/(nv-1); 
    if ave_distance>3*ave_v||(ave_distance>100&&ave_distance>1.2*ave_v)
        exc(i)=1;
    end
end
for i=1:nv
    if exc(i)==1,continue;end
    v0(n+1,1)=v(i);
    H0(n+1,:)=H(i,:);
    P0(n+1,n+1)=P(i,i);
    n=n+1;
end
if size(v0,1)<4,return;end
if n<nv
    v0(n+1:end,:)=[]; H0(n+1:end,:)=[]; P0(n+1:end,:)=[];P0(:,n+1:end)=[];
end

[dx,~]=least_square(v0,H0,P0);

ve=dx(1:3)/dt; 
vn=(Cne*ve)'; 

if dot(vn,vn)>3
    ins_align_flag=1;
end

return

