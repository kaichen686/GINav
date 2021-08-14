function sats=satid2no(satid)

global glc;
sats=0;

[prn,n]=sscanf(satid,'%d');
if n==1
%     prn=str2double(satid);
    if     glc.MINPRNGPS<=prn&&prn<=glc.MAXPRNGPS,sys=glc.SYS_GPS;
    elseif glc.MINPRNQZS<=prn&&prn<=glc.MAXPRNQZS,sys=glc.SYS_QZS;
    else  ,return ;
    end 
    sats=satno(sys,prn);
end

[str,n]=sscanf(satid,'%c%d',2);
if n<2,return;end
code=char(str(1)); prn=str(2);
switch code
    case 'G',sys=glc.SYS_GPS;prn=prn+glc.MINPRNGPS-1;
    case 'R',sys=glc.SYS_GLO;prn=prn+glc.MINPRNGLO-1;
    case 'E',sys=glc.SYS_GAL;prn=prn+glc.MINPRNGAL-1;
    case 'C',sys=glc.SYS_BDS;prn=prn+glc.MINPRNBDS-1;
    case 'J'
        sys=glc.SYS_QZS;prn=prn+glc.MINPRNQZS-1;
    otherwise, return;
end
sats=satno(sys,prn);

return

