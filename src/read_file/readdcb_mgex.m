function nav=readdcb_mgex(nav,opt,obsr,fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read dcb for MGEX (include GPS GLONASS GALILEO BDS QZSS)
%if CODE_DCB can be used for GPS and GLONASS,don't use CAS_DCB for GPS and
%GLONASS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
type=0; time=str2time(opt.ts); DCBPAIR=glc.DCBPAIR;

if time.time==0
    time=obsr.data(1).time;
end

idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading DCB_MGEX file %s...',fname0);
fid=fopen(fname);

while ~feof(fid)
    line=fgets(fid);
    if ~isempty(strfind(line,'+BIAS/SOLUTION')),type=1;end 
    if ~isempty(strfind(line,'-BIAS/SOLUTION')),break;end
    if ~type,continue;end
    
    if ~strcmp(line(2:4),'DSB')||~strcmp(line(16:19),'    '),continue;end
    
    year =fix(str2num(line(36:39)));%#ok
    doy_s=fix(str2num(line(41:43)));%#ok
    doy_e=fix(str2num(line(56:58)));%#ok
    if year<=50,year=year+2000;end
    
    time_s=ydoy2time(year,doy_s); time_e=ydoy2time(year,doy_e);
    if ~(timediff(time,time_s)>=0&&timediff(time,time_e)<0),continue;end
    
    satid=line(12:14);
    sat=satid2no(satid);
    [sys,prn]=satsys(sat);

    dcb_pair=[line(26:28),'-',line(31:33)];
    cbias=str2num(line(72:92)); %#ok
    
    if sys==glc.SYS_GPS
        if ~nav.no_CODE_DCB,continue;end
        for i=1:glc.MAXDCBPAIR
            if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end 
        end
        nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
    elseif sys==glc.SYS_GLO
        if ~nav.no_CODE_DCB,continue;end
        for i=1:glc.MAXDCBPAIR
            if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end 
        end
        nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
    elseif sys==glc.SYS_GAL
        for i=1:glc.MAXDCBPAIR
            if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end
        end
        nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
    elseif sys==glc.SYS_BDS
        for i=1:glc.MAXDCBPAIR
            if prn>18 %BDS-3
                if strcmp(dcb_pair,DCBPAIR(sys,i)) 
                    if i==2,i=glc.BD3_C2IC6I;end %#ok
                    break;
                end 
            else %BDS-2
                if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end 
            end
        end
        nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
    elseif sys==glc.SYS_QZS
        for i=1:glc.MAXDCBPAIR
            if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end 
        end
        nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
    end
 
end

fclose(fid);
fprintf('over\n');

return

