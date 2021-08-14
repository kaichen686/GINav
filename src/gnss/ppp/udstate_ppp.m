function rtk=udstate_ppp(rtk,obs,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update the state parameters (PPP mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc

% update positon 
rtk=udpos_ppp(rtk);

% update clock(include GLONASS icb)
rtk=udclk_ppp(rtk);

% update tropospheric parameters
if rtk.opt.tropopt==glc.TROPOPT_EST||rtk.opt.tropopt==glc.TROPOPT_ESTG
    rtk=udtrop_ppp(rtk);
end

% update ionospheric parameters
if rtk.opt.ionoopt==glc.IONOOPT_EST
    rtk=udiono_ppp(rtk,obs,nav);
end

% update L5-receiver-dcb parameters
if rtk.opt.nf>=3
    rtk=uddcb_ppp(rtk);
end

% update ambiguity
rtk=udamb_ppp(rtk,obs,nav);

return

