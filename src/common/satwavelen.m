function lam=satwavelen(sat,frq,nav)

global glc
lam=0; [sys,~]=satsys(sat);

if sys==glc.SYS_GPS
    if     frq==1,lam=glc.CLIGHT/glc.FREQ_GPS_L1; %L1
    elseif frq==2,lam=glc.CLIGHT/glc.FREQ_GPS_L2; %L2
    elseif frq==3,lam=glc.CLIGHT/glc.FREQ_GPS_L5; %L5
    end
elseif sys==glc.SYS_GLO
    if frq==1 %G1
        if nav.ng==0,return;end
        for i=1:nav.ng
            if nav.geph(i).sat~=sat,continue;end
            lam=glc.CLIGHT/(glc.FREQ_GLO_G1+glc.FREQ_GLO_D1*nav.geph(i).frq);
        end
    elseif frq==2 %G2
        if nav.ng==0,return;end
        for i=1:nav.ng
            if nav.geph(i).sat~=sat,continue;end
            lam=glc.CLIGHT/(glc.FREQ_GLO_G2+glc.FREQ_GLO_D2*nav.geph(i).frq);
        end
    elseif frq==3 %G3
        lam=glc.CLIGHT/glc.FREQ_GLO_G3;
    end
elseif sys==glc.SYS_GAL
    if     frq==1,lam=glc.CLIGHT/glc.FREQ_GAL_E1;   %E1
    elseif frq==2,lam=glc.CLIGHT/glc.FREQ_GAL_E5A;  %E5a
    elseif frq==3,lam=glc.CLIGHT/glc.FREQ_GAL_E5B;  %E5b
    elseif frq==4,lam=glc.CLIGHT/glc.FREQ_GAL_E5AB; %E5ab
    elseif frq==5,lam=glc.CLIGHT/glc.FREQ_GAL_E6;   %E5
    end
elseif sys==glc.SYS_BDS
    if     frq==1,lam=glc.CLIGHT/glc.FREQ_BDS_B1; %B1
    elseif frq==2,lam=glc.CLIGHT/glc.FREQ_BDS_B2; %B2
    elseif frq==3,lam=glc.CLIGHT/glc.FREQ_BDS_B3; %B3
    elseif frq==4,lam=glc.CLIGHT/glc.FREQ_BDS_B1C;%B1C
    elseif frq==5,lam=glc.CLIGHT/glc.FREQ_BDS_B2A;%B2a
    elseif frq==6,lam=glc.CLIGHT/glc.FREQ_BDS_B2B;%B2b    
    end
elseif sys==glc.SYS_QZS
    if     frq==1,lam=glc.CLIGHT/glc.FREQ_QZS_L1; %L1
    elseif frq==2,lam=glc.CLIGHT/glc.FREQ_QZS_L2; %L2
    elseif frq==3,lam=glc.CLIGHT/glc.FREQ_QZS_L5; %L5
    elseif frq==4,lam=glc.CLIGHT/glc.FREQ_QZS_L6;%L6/LEX
    end
end

return

