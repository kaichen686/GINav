function type=convcode(ver,str,sys)

global glc
type='   ';

if strcmp(str,'P1')
    if sys==glc.SYS_GPS,type='C1W';end
    if sys==glc.SYS_GLO,type='C1P';end
elseif strcmp(str,'P2')
    if sys==glc.SYS_GPS,type='C2W';end
    if sys==glc.SYS_GLO,type='C2P';end
elseif strcmp(str,'C1')
    if ver>=2.12
    elseif sys==glc.SYS_GPS,type='C1C';
    elseif sys==glc.SYS_GLO,type='C1C';
    elseif sys==glc.SYS_GAL,type='C1X';
    elseif sys==glc.SYS_QZS,type='C1C';
    end
elseif strcmp(str,'C2')
    if sys==glc.SYS_GPS
        if ver>=2.12
            type='C2W';
        else
            type='C2X';
        end
    elseif sys==glc.SYS_GLO,type='C2C';
    elseif sys==glc.SYS_BDS,type='C1X';
    elseif sys==glc.SYS_QZS,type='C2X';
    end

    
elseif ver>=2.12&&str(2)=='A'
    if     sys==glc.SYS_GPS,type=[str(1),'1C'];
    elseif sys==glc.SYS_GLO,type=[str(1),'1C'];
    elseif sys==glc.SYS_QZS,type=[str(1),'1C'];
    end
elseif ver>=2.12&&str(2)=='B'
    if     sys==glc.SYS_GPS,type=[str(1),'1X'];
    elseif sys==glc.SYS_QZS,type=[str(1),'1X'];
    end
elseif ver>=2.12&&str(2)=='C'
    if     sys==glc.SYS_GPS,type=[str(1),'2X'];
    elseif sys==glc.SYS_QZS,type=[str(1),'2X'];
    end
elseif ver>=2.12&&str(2)=='D'
    if     sys==glc.SYS_GLO,type=[str(1),'2C']; 
    end
    
    
elseif ver>=2.12&&str(2)=='1'
    if     sys==glc.SYS_GPS,type=[str(1),'1W'];
    elseif sys==glc.SYS_GLO,type=[str(1),'1P'];
    elseif sys==glc.SYS_GAL,type=[str(1),'1X'];
    elseif sys==glc.SYS_BDS,type=[str(1),'1X'];
    end
elseif ver<2.12&&str(2)=='1'
    if     sys==glc.SYS_GPS,type=[str(1),'1C'];
    elseif sys==glc.SYS_GLO,type=[str(1),'1C'];
    elseif sys==glc.SYS_GAL,type=[str(1),'1X'];
    elseif sys==glc.SYS_QZS,type=[str(1),'1C'];
    end
elseif str(2)=='2'
    if     sys==glc.SYS_GPS,type=[str(1),'2W'];
    elseif sys==glc.SYS_GLO,type=[str(1),'2P'];
    elseif sys==glc.SYS_BDS,type=[str(1),'1X'];
    elseif sys==glc.SYS_QZS,type=[str(1),'2X'];
    end
elseif str(2)=='5'
    if     sys==glc.SYS_GPS,type=[str(1),'5X'];
    elseif sys==glc.SYS_GAL,type=[str(1),'5X'];
    elseif sys==glc.SYS_QZS,type=[str(1),'5X'];
    end
elseif str(2)=='6'
    if     sys==glc.SYS_GAL,type=[str(1),'6X'];
    elseif sys==glc.SYS_BDS,type=[str(1),'6X'];
    elseif sys==glc.SYS_QZS,type=[str(1),'6X'];
    end
elseif str(2)=='7'
    if     sys==glc.SYS_GAL,type=[str(1),'7X'];
    elseif sys==glc.SYS_BDS,type=[str(1),'7X'];
    end
elseif str(2)=='8'
    if     sys==glc.SYS_GAL,type=[str(1),'8X'];
    end
end

return

