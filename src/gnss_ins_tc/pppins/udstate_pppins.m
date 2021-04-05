function rtk=udstate_pppins(rtk,obs,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update the state parameters (PPP/INS mode)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc

% update positon 
rtk=udpos_pppins(rtk);

% update clock(include GLONASS icb)
rtk=udclk_pppins(rtk);

% update tropospheric parameters
if rtk.opt.tropopt==glc.TROPOPT_EST||rtk.opt.tropopt==glc.TROPOPT_ESTG
    rtk=udtrop_pppins(rtk);
end

% update ionospheric parameters
if rtk.opt.ionoopt==glc.IONOOPT_EST
    rtk=udiono_pppins(rtk,obs,nav);
end

% update L5-receiver-dcb parameters
if rtk.opt.nf>=3
    rtk=uddcb_pppins(rtk);
end

% update ambiguity
rtk=udamb_pppins(rtk,obs,nav);

return

