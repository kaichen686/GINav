function [headinfo,fid]=decode_rnxh(fid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Read the common part of the renix header information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc

% default file header information
headinfo.ver=2.10; headinfo.type=' ';
sys=glc.SYS_GPS;   tsys=glc.TSYS_GPS;

% read file header information
while 1
    if feof(fid),break;end
    line=fgets(fid);  label=line(61:end);
    if size(line,2)<=60
        continue;
    elseif ~isempty(strfind(label,'RINEX VERSION / TYPE'))
        headinfo.ver=str2double(line(1:9));
        headinfo.type=line(21);
        switch(line(41))
            case ' '
            case 'G',sys=glc.SYS_GPS;  tsys=glc.TSYS_GPS;
            case 'R',sys=glc.SYS_GLO;  tsys=glc.TSYS_UTC;
            case 'E',sys=glc.SYS_GAL;  tsys=glc.TSYS_GAL; 
            case 'C',sys=glc.SYS_BDS;  tsys=glc.TSYS_BDS; 
            case 'J',sys=glc.SYS_QZS;  tsys=glc.TSYS_QZS;
            case 'M',sys=glc.SYS_NONE; tsys=glc.TSYS_GPS; 
            otherwise,fprintf('not supported satellite system: %c\n',line(41));
        end
        headinfo.sys=sys;
        headinfo.tsys=tsys;
        break
    end
end

return

