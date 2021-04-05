function dcb=gettgd(nav,obs,opt)

global glc
dcb=zeros(glc.NFREQ,1);
sat=obs.sat; [sys,prn]=satsys(sat);

idx=nav.eph(:,1)==sat;
if ~any(idx),return;end
eph0=nav.eph(idx,:);
tgd1=glc.CLIGHT*eph0(1,35);
tgd2=glc.CLIGHT*eph0(1,36);

if sys==glc.SYS_GPS||sys==glc.SYS_QZS
    gamma=(glc.FREQ_GPS_L1/glc.FREQ_GPS_L2)^2;
    dcb(1)=tgd1;
    dcb(2)=gamma*tgd1;
elseif sys==glc.SYS_GAL
    gamma=(glc.FREQ_GAL_E5A/glc.FREQ_GAL_E1)^2;
    dcb(1)=gamma*tgd1;
    dcb(2)=tgd1;
    dcb(3)=gamma*tgd1+(1-gamma)*tgd2;
elseif sys==glc.SYS_BDS
    if prn>18 %BD3
        frq=opt.bd3frq;
        for i=1:glc.NFREQ
            if frq(i)==1 
                dcb(i)=-tgd1;
            elseif frq(i)==2
                dcb(i)=0;
            elseif frq(i)==3
                dcb(i)=0;
            end
        end
    else %BD2
        frq=opt.bd2frq;
        for i=1:glc.NFREQ
            if frq(i)==1
                dcb(i)=-tgd1;
            elseif frq(i)==2
                dcb(i)=-tgd2;
            elseif frq(i)==3
                dcb(i)=0;
            end
        end
    end
end

return

