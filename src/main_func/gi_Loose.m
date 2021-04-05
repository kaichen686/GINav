function [rtk_gi,rtk_gnss,stat0]=gi_Loose(rtk_gi,rtk_gnss,obsr,obsb,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gnss/ins loosely coupled mode
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%8/12/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
[rtk_gnss,~]=gnss_solver(rtk_gnss,obsr,obsb,nav);

if rtk_gnss.sol.stat~=glc.SOLQ_NONE
    [rtk_gi,rtk_gnss,stat0]=gnss_ins_lc(rtk_gi,rtk_gnss);
else
    stat0=0;
end

return