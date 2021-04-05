function id=satno2id(sat)

global glc

[sys,prn]=satsys(sat);

switch sys
    case glc.SYS_GPS,id=sprintf('G%02d',prn-glc.MINPRNGPS+1);return;
    case glc.SYS_GLO,id=sprintf('R%02d',prn-glc.MINPRNGLO+1);return;
    case glc.SYS_GAL,id=sprintf('E%02d',prn-glc.MINPRNGAL+1);return;
    case glc.SYS_BDS,id=sprintf('C%02d',prn-glc.MINPRNBDS+1);return;
    case glc.SYS_QZS,id=sprintf('J%02d',prn-glc.MINPRNQZS+1);return;
end

id='';

return