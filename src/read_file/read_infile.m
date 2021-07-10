function [obsr,obsb,nav,imu]=read_infile(opt,file)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read input file,include rover obs file, base obs file, eph file, sp3 file,
%clk file,atx file, DCB file,BSX file, erp file, blq file£¬ imu file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc gls
obsr=gls.obs; obsb=gls.obs; nav=gls.nav; imu=gls.imu;

% read rover observation file
if ~strcmp(file.obsr,'')
    [obsr,nav]=readrnxobs(obsr,nav,opt,file.obsr);
    if obsr.n==0
        error('Number of rover obs is zero!!!');
    end
else
    error('Have no observation file for rover!!!');
end

% read rover observation file
if ~strcmp(file.obsb,'')
    [obsb,nav]=readrnxobs(obsb,nav,opt,file.obsb);
    if obsb.n==0&&opt.mode>=glc.PMODE_DGNSS&&opt.mode<=glc.PMODE_STATIC
        error('Number of base obs is zero!!!');
    end
else
    if opt.mode>=glc.PMODE_DGNSS&&opt.mode<=glc.PMODE_STATIC
        error('Relative positioning mode,but have no observation file for base station!!!');
    end
end

% read broadcast ephemeris file
if ~strcmp(file.beph,'')
    nav=readrnxnav(nav,opt,file.beph);
else
    error('Have no broadcast ephemeris file!!!');
end

% read precise ephemeris file
if ~strcmp(file.sp3,'')
    nav=readsp3(nav,file.sp3);
elseif strcmp(file.sp3,'')&&(opt.mode==glc.PMODE_PPP_KINEMA||opt.mode==glc.PMODE_PPP_STATIC)
    error('PPP mode,but have no precise ephemeris file!!!');
end

% read precise clock file
if ~strcmp(file.clk,'')
    nav=readclk(nav,opt,file.clk);
elseif strcmp(file.clk,'')&&(opt.mode==glc.PMODE_PPP_KINEMA||opt.mode==glc.PMODE_PPP_STATIC)
    error('PPP mode,but have no precise clock file!!!');
end

% read antenna file
if ~strcmp(file.atx,'')
    nav=readatx(nav,file.atx);
elseif strcmp(file.atx,'')&&(opt.mode==glc.PMODE_PPP_KINEMA||opt.mode==glc.PMODE_PPP_STATIC)
    fprintf('Warning:PPP mode,but have no antenna file!');
end

% read DCB file
if ~strcmp(file.dcb(1),'')||~strcmp(file.dcb(2),'')||~strcmp(file.dcb(3),'')
    for i=1:3
        if ~strcmp(file.dcb(i),'')
            nav=readdcb(nav,obsr,char(file.dcb(i)));
            nav.no_CODE_DCB=0;
        end
    end
else
    if opt.mode==glc.PMODE_PPP_KINEMA||opt.mode==glc.PMODE_PPP_STATIC
        fprintf('Warning:PPP mode,but have no DCB file!');
    end
end

if ~strcmp(file.dcb_mgex,'')
    nav=readdcb_mgex(nav,opt,obsr,file.dcb_mgex);
end

% read erp file
if ~strcmp(file.erp,'')
    nav=readerp(nav,file.erp);
elseif strcmp(file.erp,'')&&(opt.mode==glc.PMODE_PPP_KINEMA||opt.mode==glc.PMODE_PPP_STATIC)
    fprintf('Warning:PPP mode,but have no erp file!');
end

% read blq file 
if ~strcmp(file.blq,'')
    nav=readblq(nav,obsr,obsb,file.blq);
end

% read imu file
if ~strcmp(file.imu,'')
    imu=readimu(opt,file.imu);
    if imu.n==0&&opt.ins.mode~=glc.GIMODE_NONE
        error('Number of imu data is zero!!!');
    end
elseif strcmp(file.imu,'')&&(opt.ins.mode==glc.GIMODE_LC||opt.ins.mode==glc.GIMODE_TC)
    error('GNSS/INS integration mode,but have no imu file!!!');
end

fprintf('Info:Data preparation has been completed\n');

return

