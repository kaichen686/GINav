function [obs,frq]=code2obs(code,sys)

global glc

obscodes=glc.obscodes;
switch sys
    case glc.SYS_GPS,obsfreqs=glc.GPSfreqband;
    case glc.SYS_GLO,obsfreqs=glc.GLOfreqband;
    case glc.SYS_GAL,obsfreqs=glc.GALfreqband;
    case glc.SYS_BDS,obsfreqs=glc.BDSfreqband;
    case glc.SYS_QZS,obsfreqs=glc.QZSfreqband;
end

if (code<=1||glc.MAXCODE<code) 
    obs='';frq=0;
    return
end

obs=obscodes(code); frq=obsfreqs(code);

return

