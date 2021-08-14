function rtk=initoutfile(rtk,opt,file,obsr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc

if opt.ins.mode==glc.GIMODE_OFF
    if opt.mode==glc.PMODE_SPP
        mode='SPP';
    elseif opt.mode==glc.PMODE_DGNSS
        mode='PPD';
    elseif opt.mode==glc.PMODE_KINEMA
        mode='PPK';
    elseif opt.mode==glc.PMODE_STATIC
        mode='PPS';
    elseif opt.mode==glc.PMODE_PPP_KINEMA
        mode='PPP_K';
    elseif opt.mode==glc.PMODE_PPP_STATIC
        mode='PPP_S';
    end
elseif opt.ins.mode==glc.GIMODE_LC
    if opt.mode==glc.PMODE_SPP
        mode='SPP_LC';
    elseif opt.mode==glc.PMODE_DGNSS
        mode='PPD_LC';
    elseif opt.mode==glc.PMODE_KINEMA
        mode='PPK_LC';
    elseif opt.mode==glc.PMODE_PPP_KINEMA
        mode='PPP_LC';
    end
elseif opt.ins.mode==glc.GIMODE_TC
    if opt.mode==glc.PMODE_SPP
        mode='SPP_TC';
    elseif opt.mode==glc.PMODE_DGNSS
        mode='PPD_TC';
    elseif opt.mode==glc.PMODE_KINEMA
        mode='PPK_TC';
    elseif opt.mode==glc.PMODE_PPP_KINEMA
        mode='PPP_TC';
    end
end

fullname=char(file.obsr);
idx1=find(fullname==glc.sep); idx2=find(fullname=='.');
outfilename=[fullname(idx1(end)+1:idx2(end)-1),'_',mode,'.pos'];

fullpath=which('GINavExe.m');
[path,~,~]=fileparts(fullpath);
pathname=[path,glc.sep,'result',glc.sep];
rtk.outfile=[pathname,outfilename];

outsolhead(rtk,opt,obsr);

return

