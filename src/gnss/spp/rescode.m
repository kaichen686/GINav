function [v,H,P,vsat,azel,resp,nv,ns]=rescode(iter,obs,nav,sv,x0,opt)

global glc
lam_carr0=glc.CLIGHT/glc.FREQ_GPS_L1;
nobs=size(obs,1); NSYS=glc.NSYS;
v=zeros(nobs+NSYS,1); H=zeros(nobs+NSYS,8); P=zeros(nobs+NSYS,nobs+NSYS);
vsat=zeros(nobs,1); azel=zeros(nobs,2); resp=zeros(nobs,1);
nv=0; ns=0; 
var=zeros(nobs+NSYS,nobs+NSYS); mask=zeros(5,1); idx=zeros(nobs,1);
rr=x0(1:3); dtr=x0(4); pos=ecef2pos(rr);

for i=1:nobs
    
    vsat(i)=0; azel(i,:)=[0,0]; resp(i)=0;
    
    [sys,~]=satsys(obs(i).sat);
    if sys==0,continue;end
    
    if i<nobs&&obs(i).sat==obs(i+1).sat,continue;end
    
    rs = sv(i).pos; dts = sv(i).dts; Vars=sv(i).vars;
    
    [r,LOS]=geodist(rs,rr); azel(i,:)=satazel(pos,LOS);
    if r<=0||azel(i,2)<opt.elmin,continue;end
       
    % pesudorange with code bias correction
    [pr,Vmea]=prange(obs(i),nav,opt,azel(i,:),iter);
    if pr==0,continue;end
    if abs(pr)<1e7||abs(pr)>5e7,continue;end
        
    % excluded satellite 
    stat=satexclude(obs(i).sat,Vars,sv(i).svh,opt);
    if stat==0,continue;end
    
    % ionospheric delay
    [ionoerr,Viono]=iono_cor(glc.IONOOPT_BRDC,obs(i).time,nav,obs(i).sat,pos,azel(i,:));
    lam_L1=nav.lam(obs(i).sat,1);
    if lam_L1>0,ionoerr=ionoerr*(lam_L1/lam_carr0)^2;end

    % tropospheric delay 
    [troperr,Vtrop]=trop_cor(glc.TROPOPT_SAAS,obs(i).time,nav,pos,azel(i,:));

    % pseudorange residuals
    v(nv+1)=pr-(r+dtr-glc.CLIGHT*dts+ionoerr+troperr);
    
    % design measurement matrix
    H(nv+1,:)=[-LOS,1,0,0,0,0];
    if     sys==glc.SYS_GLO,v(nv+1)=v(nv+1)-x0(5);H(nv+1,5)=1;mask(2)=1;
    elseif sys==glc.SYS_GAL,v(nv+1)=v(nv+1)-x0(6);H(nv+1,6)=1;mask(3)=1;
    elseif sys==glc.SYS_BDS,v(nv+1)=v(nv+1)-x0(7);H(nv+1,7)=1;mask(4)=1;
    elseif sys==glc.SYS_QZS,v(nv+1)=v(nv+1)-x0(8);H(nv+1,8)=1;mask(5)=1;
    else                   ,                                  mask(1)=1;
    end
    
    % variance matrix
    VARr=varerr_spp(opt,azel(i,2),sys);
    var(nv+1,nv+1)=VARr+Vars+Viono+Vtrop+Vmea;
    
    % record validate satellite,rasidual
    vsat(i)=1;  resp(i)=v(nv+1,1);  idx(nv+1)=i;
    
    nv=nv+1;
    ns=ns+1;
    
end

% add the virtual observation value to avoid rank defect
for i=1:5
    if mask(i)==1,continue;end
    v(nv+1,1)=0;
    H(nv+1,3+i)=1;
    var(nv+1,nv+1)=0.01;
    nv=nv+1;
end

% weight matrix
for i=1:nv
    P(i,i)=var(i,i)^-1;
end

if nv<nobs+NSYS
    v(nv+1:end,:)=[]; H(nv+1:end,:)=[]; P(nv+1:end,:)=[];P(:,nv+1:end)=[];
end

return

