function [eph_out,stat]=searcheph_h(time,sat,iode,eph) %#ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%search the corresponding navigation meassage with high efficiency
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc;
eph_sel=[0,0,1,0,0];%ephemeris selections(GPS,GLO,GAL,BDS,QZS)
stat=1; sel=0; 

[sys,~]=satsys(sat);

switch sys
    case glc.SYS_GPS,tmax=glc.MAXDTOE+1;     sel=eph_sel(1);
    case glc.SYS_GAL,tmax=glc.MAXDTOE_GAL;   sel=eph_sel(3);
    case glc.SYS_BDS,tmax=glc.MAXDTOE_BDS+1; sel=eph_sel(4);
    case glc.SYS_QZS,tmax=glc.MAXDTOE_QZS+1; sel=eph_sel(5);
    otherwise, tmax=glc.MAXDTOE+1;            
end
tmin=tmax+1;

idx0=eph(:,1)==sat;
if ~any(idx0),eph_out=NaN;stat=0;return;end
eph0=eph(idx0,:);
if sys==glc.SYS_GAL&&sel~=0
    if sel==1
        idx_GAL=(bitand(eph0(:,7),bitshift(1,9))~=0);
        if ~any(idx_GAL),eph_out=NaN;stat=0;return;end
        eph0=eph0(idx_GAL,:);
    end
    if sel==2
        idx_GAL=(bitand(eph0(:,7),bitshift(1,8))~=0);
        if ~any(idx_GAL),eph_out=NaN;stat=0;return;end
        eph0=eph0(idx_GAL,:);
    end
end
t0=abs(eph0(:,11)+eph0(:,12)-time.time-time.sec);
idx1=(t0<=tmax&t0<=tmin);
if ~any(idx1),eph_out=NaN;stat=0;return;end
t1=t0(idx1);
eph1=eph0(idx1,:);
idx2=t1==min(t1);
eph_=eph1(idx2,:);
eph2=eph_(end,:);

eph_out.sat=eph2(1);
eph_out.iode=eph2(2); 
eph_out.iodc=eph2(3); 
eph_out.sva=eph2(4); 
eph_out.svh=eph2(5); 
eph_out.week=eph2(6); 
eph_out.code=eph2(7); 
eph_out.flag=eph2(8); 
eph_out.toc.time=eph2(9); 
eph_out.toc.sec=eph2(10);
               
eph_out.toe.time=eph2(11);
eph_out.toe.sec=eph2(12);
eph_out.ttr.time=eph2(13);
eph_out.ttr.sec=eph2(14);
eph_out.A=eph2(15);
eph_out.e=eph2(16);
eph_out.i0=eph2(17);
eph_out.OMG0=eph2(18);
eph_out.omg=eph2(19);
eph_out.M0=eph2(20);
               
eph_out.deln=eph2(21);
eph_out.OMGd=eph2(22);
eph_out.idot=eph2(23);
eph_out.crc=eph2(24);
eph_out.crs=eph2(25);
eph_out.cuc=eph2(26);
eph_out.cus=eph2(27);
eph_out.cic=eph2(28);
eph_out.cis=eph2(29);
eph_out.toes=eph2(30);
               
eph_out.fit=eph2(31);
eph_out.f0=eph2(32);
eph_out.f1=eph2(33);
eph_out.f2=eph2(34);
eph_out.tgd=eph2(35:38);
eph_out.Adot=eph2(39);
eph_out.ndot=eph2(40);

return;

