function stat=test_sys(sys,m)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
switch sys
    case glc.SYS_GPS,stat=(m==1);return;
    case glc.SYS_GLO,stat=(m==2);return;
    case glc.SYS_GAL,stat=(m==3);return;
    case glc.SYS_BDS,stat=(m==4);return;
    case glc.SYS_QZS,stat=(m==5);return;
    otherwise,stat=0;return;
end

