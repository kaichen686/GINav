function [sv,stat]=satpos(time,obs,nav,ephopt,sv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
teph=obs.time; sat=obs.sat;

switch ephopt
    case glc.EPHOPT_BRDC
        [sv,stat]=ephpos(time,teph,sat,nav,-1,sv); return;
    case glc.EPHOPT_PREC
        [sv,stat]=peph2pos(time,sat,nav,1,sv); return;
    otherwise
        stat=0;return;
end