function handles=matchinfile(handles)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
opt=handles.opt;
file=handles.file;
filepath=opt.filepath; 
sitename=opt.sitename;

if ~exist(filepath,'dir')
    error('The directory of input file is not exist, please re-set data directory in configuration file!!!');
end

endword=filepath(end);
if ~strcmp(endword,glc.sep)
    filepath=[filepath,glc.sep];  
end
file.path=filepath;

% find the rover observation file
[file.obsr,ftime]=findobsrfile(filepath,sitename);
if ~strcmp(file.obsr,'')
    handles.obsr_edit.String=file.obsr;
end

% find the broadcast ephemeris file
file.beph=findbephfile(filepath,ftime,opt);
if ~strcmp(file.beph,'')
    handles.beph_edit.String=file.beph;
end


if opt.mode>=glc.PMODE_DGNSS&&opt.mode<=glc.PMODE_STATIC
    % find the base observation file
    file.obsb=findobsbfile(filepath,sitename);
    if ~strcmp(file.obsb,'')
        handles.obsb_edit.String=file.obsb;
    end
end

if opt.sateph==glc.EPHOPT_PREC
    % find the precise ephemeris file
    file.sp3=findpephfile(filepath,ftime);
    if ~strcmp(file.sp3,'')
        handles.sp3_edit.String=file.sp3;
    end
    % find the precise clock file
    file.clk=findclkfile(filepath,ftime);
    if ~strcmp(file.clk,'')
        handles.clk_edit.String=file.clk;
    end
end

% find atx file
if opt.mode~=glc.PMODE_SPP
    file.atx=findatxfile(filepath);
    if ~strcmp(file.atx,'')
        handles.atx_edit.String=file.atx;
    end
end

% find the DCB file
file.dcb=findDCBfile(filepath,ftime); 
for i=1:3
    if ~strcmp(file.dcb(i),'')
        handles.DCB_edit.String=[filepath,'*.DCB'];
        break;
    end
end

% find the BSX file
file.dcb_mgex=findBSXfile(filepath,ftime);
if ~strcmp(file.dcb_mgex,'')
    handles.BSX_edit.String=file.dcb_mgex;
end

% find the erp file
file.erp=finderpfile(filepath,ftime);
if ~strcmp(file.erp,'')
    handles.erp_edit.String=file.erp;
end

if opt.mode>=glc.PMODE_PPP_KINEMA
    % find the blq file
    file.blq=findblqfile(filepath);
    if ~strcmp(file.blq,'')
        handles.blq_edit.String=file.blq;
    end
end

if opt.ins.mode~=glc.GIMODE_OFF
    % find the imu file
    file.imu=findimufile(filepath);
    if ~strcmp(file.imu,'')
        handles.imu_edit.String=file.imu;
    end
end

handles=rmfield(handles,'file');
handles.file=file;

return
