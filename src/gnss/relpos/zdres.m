function [zd,stat]=zdres(flag,obs,sv,nav,rr,opt,rtk)

global glc
nobs=size(obs,1); nf=rtk.NF;
zazel=[0 pi/2]; stat=1;
zd0=struct('y',zeros(2*nf,1),'LOS',zeros(1,3),'azel',zeros(1,2));
zd=repmat(zd0,nobs,1);

if norm(rr)<=0,stat=0;return;end

%compute earth tide correction 
if opt.tidecorr
    dr=tidedisp(gpst2utc(obs(1).time),rr,7,nav.erp,nav.otlp(:,:,flag));
    rr=rr+dr;
end

pos=ecef2pos(rr);

for i=1:nobs
    
    rs = sv(i).pos; dts = sv(i).dts;
    
    [r,LOS]=geodist(rs,rr); azel=satazel(pos,LOS);
    if r<=0||azel(2)<opt.elmin,continue;end
    
    if satexclude(obs(i).sat,sv(i).vars,sv(i).svh)==0,continue;end
    
    r=r-dts*glc.CLIGHT;
    
    zhd=trop_saa(pos,zazel,0);
    r=r+tropmapf(obs(i).time,pos,azel)*zhd;
    
    dantr=antmodel(obs(i).sat,opt.pcvr(flag),opt.antdel(flag,:),azel,opt.posopt(2));
    
    zd(i)=zdres_sat(flag,r,obs(i),nav,azel,dantr,opt,rtk,zd(i));
    zd(i).LOS=LOS; zd(i).azel=azel;
end

return

