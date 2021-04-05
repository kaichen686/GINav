function sats=satno(sys,prn)

global glc;
sats=0;
if prn<=0, return;end

switch sys
    case glc.SYS_GPS
        if prn<glc.MINPRNGPS||glc.MAXPRNGPS<prn, return;end
        sats=prn-glc.MINPRNGPS+1;
    case glc.SYS_GLO
        if prn<glc.MINPRNGLO||glc.MAXPRNGLO<prn, return;end
        sats=glc.NSATGPS+prn-glc.MINPRNGLO+1;
    case glc.SYS_GAL
        if prn<glc.MINPRNGAL||glc.MAXPRNGAL<prn, return;end
        sats=glc.NSATGPS+glc.NSATGLO+prn-glc.MINPRNGAL+1;
    case glc.SYS_BDS
        if prn<glc.MINPRNBDS||glc.MAXPRNBDS<prn, return;end
        sats=glc.NSATGPS+glc.NSATGLO+glc.NSATGAL+prn-glc.MINPRNBDS+1;
    case glc.SYS_QZS
        if prn<glc.MINPRNQZS||glc.MAXPRNQZS<prn, return;end
        sats=glc.NSATGPS+glc.NSATGLO+glc.NSATGAL+glc.NSATBDS+prn-glc.MINPRNQZS+1;
end
 
return;