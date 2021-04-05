function sys=code2sys(code)

global glc
switch code
    case ' ',sys=glc.SYS_GPS;
    case 'G',sys=glc.SYS_GPS;
    case 'R',sys=glc.SYS_GLO;
    case 'E',sys=glc.SYS_GAL;
    case 'C',sys=glc.SYS_BDS;
    case 'J',sys=glc.SYS_QZS;
    otherwise,sys=glc.SYS_NONE;
end

return