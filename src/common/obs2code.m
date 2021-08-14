function [code,frq]=obs2code(obs,sys)

global glc
obscodes=glc.obscodes;
switch sys
    case glc.SYS_GPS,obsfreqs=glc.GPSfreqband;
    case glc.SYS_GLO,obsfreqs=glc.GLOfreqband;
    case glc.SYS_GAL,obsfreqs=glc.GALfreqband;
    case glc.SYS_BDS,obsfreqs=glc.BDSfreqband;
    case glc.SYS_QZS,obsfreqs=glc.QZSfreqband;
end


code=0;frq=0;
for i=2:60
    if ~strcmp(obscodes(i),obs),continue;end
    frq=obsfreqs(i);
    code=i;
    break
end

return

