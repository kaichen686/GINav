function [rtk,stat]=gi_Tight(rtk,obsr,obsb,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gnss/ins tightly coupled mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%8/12/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
opt=rtk.opt; time=rtk.gi_time; 
if time.time~=0,rtk.tt=timediff(obsr(1).time,time);end

if opt.mode==glc.PMODE_SPP||opt.mode>=glc.PMODE_PPP_KINEMA
    % scan obs for spp
    [obsr,nobs]=scan_obs_spp(obsr);
    if nobs==0,stat=0;return;end
    % correct BDS2 multipath error
    if ~isempty(strfind(opt.navsys,'C'))
        obsr=bds2mp_corr(rtk,obsr);
    end
end

if opt.mode>=glc.PMODE_PPP_KINEMA
    % scan obs for ppp
    [obsr,nobs]=scan_obs_ppp(obsr);
    if nobs==0,stat=0;return;end
    % repair receiver clock jump (only for GPS)
    [rtk,obsr]=clkrepair(rtk,obsr,nav);
end

if opt.mode==glc.PMODE_SPP
    % SPP/INS
    [rtk,stat]=sppins(rtk,obsr,nav);
elseif opt.mode==glc.PMODE_DGNSS||opt.mode==glc.PMODE_KINEMA
    % PPD/INS or PPK/INS
    if ~isstruct(obsb),stat=0;return;end
    rtk.sol.age=timediff(obsr(1).time,obsb(1).time);
    [rtk,stat]=rtkins(rtk,obsr,obsb,nav);
else
    % PPP/INS
    [rtk,stat]=pppins(rtk,obsr,nav); 
end
 
return

