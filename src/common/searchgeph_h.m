function [geph_out,stat]=searchgeph_h(time,sat,iode,geph) %#ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%search the corresponding GLONASS navigation meassage with high efficiency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc;
stat=1; 
tmax=glc.MAXDTOE_GLO;
tmin=tmax+1;

idx0=geph(:,1)==sat;
if ~any(idx0),geph_out=NaN;stat=0;return;end
geph0=geph(idx0,:);
t0=abs(geph0(:,7)+geph0(:,8)-time.time-time.sec);
idx1=(t0<=tmax&t0<=tmin);
if ~any(idx1),geph_out=NaN;stat=0;return;end
t1=t0(idx1);
geph1=geph0(idx1,:);
idx2=t1==min(t1);
geph_=geph1(idx2,:);
geph2=geph_(end,:);

geph_out.sat=geph2(1); 
geph_out.iode=geph2(2); 
geph_out.frq=geph2(3);  
geph_out.svh=geph2(4); 
geph_out.sva=geph2(5); 
geph_out.age=geph2(6); 
geph_out.toe.time=geph2(7); 
geph_out.toe.sec=geph2(8); 
geph_out.tof.time=geph2(9); 
geph_out.tof.sec=geph2(10); 
                
geph_out.pos=geph2(11:13)'; 
geph_out.vel=geph2(14:16)'; 
geph_out.acc=geph2(17:19)'; 
geph_out.taun=geph2(20); 
                
geph_out.gamn=geph2(21); 
geph_out.dtaun=geph2(22); 

return


