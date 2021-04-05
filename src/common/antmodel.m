function dantr=antmodel(sat,pcvr,del,azel,opt)

global glc;

[sys,~]=satsys(sat);
e=zeros(3,1); off=zeros(3,1); dantr=zeros(3,1);
cosel=cos(azel(2));
e(1)=sin(azel(1))*cosel;
e(2)=cos(azel(1))*cosel;
e(3)=sin(azel(2));

% not consider the azimuth
if size(pcvr.type,2)==0
    for i=1:glc.NFREQ
        if sys==glc.SYS_GPS||sys==glc.SYS_GAL||sys==glc.SYS_BDS||sys==glc.SYS_QZS
            ii=i;
            if i==3,ii=2;end
        elseif sys==glc.SYS_GLO
            ii=i+glc.NFREQ;
            if i==3,ii=2+glc.NFREQ;end
        end
        
        for j=1:3,off(j)=pcvr.off(ii,j)+del(j);end
        
        if opt==1
            pcv=interpvar0(0,90-azel(2)*glc.R2D,pcvr.var(ii,:),0);
        else
            pcv=0;
        end
        dantr(i)=-dot(off,e)+pcv;
    end
end

% consider the azimuth
for i=1:glc.NFREQ
    if sys==glc.SYS_GPS||sys==glc.SYS_GAL||sys==glc.SYS_BDS||sys==glc.SYS_QZS
        ii=i;
        if i==3,ii=2;end
    elseif sys==glc.SYS_GLO
        ii=i+glc.NFREQ;
        if i==3,ii=2+glc.NFREQ;end
    end
    
    for j=1:3,off(j)=pcvr.off(ii,j)+del(j);end
    
    if opt==1
        if pcvr.dazi~=0
            pcv=interpvar1(azel(1)*glc.R2D,90-azel(2)*glc.R2D,pcvr,ii);
        else
            pcv=interpvar0(0,90-azel(2)*glc.R2D,pcvr.var(ii,:),0);
        end
    else
        pcv=0;
    end
    dantr(i)=-dot(off,e)+pcv;
end

return

