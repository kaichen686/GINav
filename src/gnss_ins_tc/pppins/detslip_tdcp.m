function rtk=detslip_tdcp(rtk,cur_obs,old_obs,nav,f)

global glc
dt=timediff(cur_obs(1).time,old_obs(1).time);
if abs(dt)>5
    return;
end

cur_sv=satposs(cur_obs,nav,rtk.opt.sateph);
old_sv=satposs(old_obs,nav,rtk.opt.sateph);

cur_pos=rtk.ins.pos;     cur_rr=blh2xyz(cur_pos);
old_pos=rtk.ins.oldpos;  old_rr=blh2xyz(old_pos);

n_cur=size(cur_obs,1);
n_old=size(old_obs,1);

nv=0; vsat=zeros(n_cur,1); v=zeros(n_cur,1);

for i=1:n_cur
    
    cur_obsi=cur_obs(i); cur_svi=cur_sv(i);
    lam=nav.lam(cur_obsi.sat,:);
    [sys,~]=satsys(cur_obsi.sat);
    if rtk.mask(sys)==0,continue;end
    
    if lam(f)==0,continue;end

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
    if cur_obsi.L(f)==0||old_obsi.L(f)==0,continue;end
    
    [cur_range,~]=geodist(cur_svi.pos,cur_rr); 
    [old_range,~]=geodist(old_svi.pos,old_rr); 
    
    tdcp_obs=cur_obsi.L(f)*lam(f)-old_obsi.L(f)*lam(f);
    tdcp_pre=cur_range-old_range;
    
    v(i,1)=tdcp_obs-tdcp_pre+glc.CLIGHT*(cur_svi.dts-old_svi.dts);
    
    nv=nv+1;

    vsat(i)=1;

end

dt_drift=rtk.x(rtk.ic+6);
v=v-dt_drift;

slip=zeros(n_cur,1);
for i=1:n_cur
    sat=cur_obs(i).sat;
    if vsat(i)==0
        rtk.sat(sat).slip(f)=bitor(rtk.sat(sat).slip(f),1);
        continue;
    end

    vi=abs(v(i));
    v_other=abs(v);v_other(i)=[];
    ave_v=sum(abs(v_other))/(nv-1);
    ave_distance=sum(abs(vi-v_other))/(nv-1);
    if ave_distance>3*ave_v&&abs(v(i))>0.15
        slip(i)=1;
    end
end

idx=find(slip==1);
ratio=size(idx,1)/n_cur;
if ratio>=0.5
    return;
end

for i=1:n_cur
    sat=cur_obs(i).sat;
    if slip(i)==1
        rtk.sat(sat).slip(f)=bitor(rtk.sat(sat).slip(f),slip(i));
    end
end

return

