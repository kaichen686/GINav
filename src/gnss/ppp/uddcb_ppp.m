function rtk=uddcb_ppp(rtk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
VAR_DCB=30^2;
idx=rtk.id+1;

if rtk.x(idx)==0
    rtk=initx(rtk,1e-6,VAR_DCB,idx);
end

return