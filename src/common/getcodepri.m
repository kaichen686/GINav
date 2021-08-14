function pri=getcodepri(sys,code,opt) %#ok

global glc

codepris=glc.codepris;
switch sys
    case glc.SYS_GPS,i=1;optstr='-GL';%#ok
    case glc.SYS_GLO,i=2;optstr='-RL';%#ok
    case glc.SYS_GAL,i=3;optstr='-EL';%#ok
    case glc.SYS_BDS,i=4;optstr='-BL';%#ok
    case glc.SYS_QZS,i=5;optstr='-QL';%#ok
end

pri=0;

[obs,j]=code2obs(code,sys);
if strcmp(obs,'')||j==0,return;end
obs=char(obs);

ind=strfind(char(codepris(i,j)),obs(2)); %i:sys j:freq
if any(ind)
    pri=15-ind;
else
    pri=0;
end

return


