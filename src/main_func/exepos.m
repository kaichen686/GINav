function exepos(opt,file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% execute positioning
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%8/12/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic

global glc gls
rtk=gls.rtk;

% read input file
[obsr,obsb,nav,imu]=read_infile(opt,file);

% initlize output file
rtk=initoutfile(rtk,opt,file,obsr);

% high efficiency by converting struct to matrix
obsr=adjobs(obsr,opt);
obsb=adjobs(obsb,opt);
nav =adjnav(nav,opt); 

% set base position for relative positioning mode
if opt.mode>=glc.PMODE_DGNSS&&opt.mode<=glc.PMODE_STATIC
    rtk=baserefpos(rtk,opt,obsb,nav);
end

% set anttena parameter for satellite and reciever
if opt.mode~=glc.PMODE_SPP
    nav=L2_L5pcv_copy(nav);
    if isfield(obsr,'sta'),stas(1)=obsr.sta;end
    if isfield(obsb,'sta'),stas(2)=obsb.sta;end
    time0.time=obsr.data(1,1);time0.sec=obsr.data(1,2);
    [nav,opt]=setpcv(time0,opt,nav,nav.ant_para,nav.ant_para,stas);
end

% process all data
if opt.ins.mode==glc.GIMODE_OFF
    % gnss
    gnss_processor(rtk,opt,obsr,obsb,nav);
elseif opt.ins.mode==glc.GIMODE_LC||opt.ins.mode==glc.GIMODE_TC
    % gnss/ins integration
    gi_processor(rtk,opt,obsr,obsb,nav,imu);
end

toc

return

