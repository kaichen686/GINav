function outsolhead(rtk,opt,obsr)

global glc
solopt=opt.sol;
sep=' '; str_vel=''; str_att='';
modes={'SPP','PPD','PPK','PPS','PPP Kinematic','PPP Static','SPP/INS LC',...
    'PPD/INS LC','PPK/INS LC','PPP/INS LC','SPP/INS TC','PPD/INS TC',...
    'PPK/INS TC','PPP/INS TC'};
ionoopts={'off','broadcast model','iono-free LC','estimation'};
tropopts={'off','Saastamoinen model','ZTD estimation','ZTD+grid'};

%% version
str=sprintf('%s program   : %s\n','%',opt.ver);

%% start and end time
if opt.ts==glc.OPT_TS
    time=obsr.data(1).time;
    epoch=time2epoch(time);
else
    time=str2time(opt.ts);
    epoch=time2epoch(time);
end
year=num2str(epoch(1));
if epoch(2)<10
    month=sprintf('%d%d',0,epoch(2));
else
    month=num2str(epoch(2));
end
if epoch(3)<10
    day=sprintf('%d%d',0,epoch(3));
else
    day=num2str(epoch(3));
end
if epoch(4)<10
    hour=sprintf('%d%d',0,epoch(4));
else
    hour=num2str(epoch(4));
end
if epoch(5)<10
    minute=sprintf('%d%d',0,epoch(5));
else
    minute=num2str(epoch(5));
end
if epoch(6)<10
    second=sprintf('%d%0.1f',0,epoch(6));
else
    second=sprintf('%0.1f',epoch(6));
end
str=[str,sprintf('%s obs start : %s/%s/%s%s%s:%s:%s\n',...
    '%',year,month,day,sep,hour,minute,second)];
    
if opt.te==glc.OPT_TE
    time=obsr.data(end).time;
    epoch=time2epoch(time);
else
    time=str2time(opt.te);
    epoch=time2epoch(time);
end
year=num2str(epoch(1));
if epoch(2)<10
    month=sprintf('%d%d',0,epoch(2));
else
    month=num2str(epoch(2));
end
if epoch(3)<10
    day=sprintf('%d%d',0,epoch(3));
else
    day=num2str(epoch(3));
end
if epoch(4)<10
    hour=sprintf('%d%d',0,epoch(4));
else
    hour=num2str(epoch(4));
end
if epoch(5)<10
    minute=sprintf('%d%d',0,epoch(5));
else
    minute=num2str(epoch(5));
end
if epoch(6)<10
    second=sprintf('%d%0.1f',0,epoch(6));
else
    second=sprintf('%0.1f',epoch(6));
end
str=[str,sprintf('%s obs end   : %s/%s/%s%s%s:%s:%s\n',...
    '%',year,month,day,sep,hour,minute,second)];

%% processing mode
if opt.ins.mode==glc.GIMODE_OFF
    mode=char(modes(opt.mode));
elseif opt.ins.mode==glc.GIMODE_LC
    if opt.mode==glc.PMODE_SPP
        mode=char(modes(7));
    elseif opt.mode==glc.PMODE_DGNSS
        mode=char(modes(8));
    elseif opt.mode==glc.PMODE_KINEMA
        mode=char(modes(9));
    elseif opt.mode==glc.PMODE_PPP_KINEMA
        mode=char(modes(10));
    end  
elseif opt.ins.mode==glc.GIMODE_TC
    if opt.mode==glc.PMODE_SPP
        mode=char(modes(11));
    elseif opt.mode==glc.PMODE_DGNSS
        mode=char(modes(12));
    elseif opt.mode==glc.PMODE_KINEMA
        mode=char(modes(13));
    elseif opt.mode==glc.PMODE_PPP_KINEMA
        mode=char(modes(14));
    end 
end
str=[str,sprintf('%s mode      : %s\n','%',mode)];

%% navigation system
str_sys=sprintf('%s system    : ','%');
if ~isempty(strfind(opt.navsys,'G'))
    str_sys=[str_sys,'GPS '];
end
if ~isempty(strfind(opt.navsys,'R'))
    str_sys=[str_sys,'GLONASS '];
end
if ~isempty(strfind(opt.navsys,'E'))
    str_sys=[str_sys,'GALILEO '];
end
if ~isempty(strfind(opt.navsys,'C'))
    str_sys=[str_sys,'BDS '];
end
if ~isempty(strfind(opt.navsys,'J'))
    str_sys=[str_sys,'QZSS'];
end
str=[str,sprintf('%s\n',str_sys)];

%% number of frequencies
str=[str,sprintf('%s nfreqs    : %d\n','%',opt.nf)];

%% elevation mask
str=[str,sprintf('%s elev mask : %.1f deg\n','%',opt.elmin*180/pi)];

%% ephemeris
if opt.sateph==glc.EPHOPT_BRDC
    str=[str,sprintf('%s ephemeris : %s\n','%','broadcast')];
elseif opt.sateph==glc.EPHOPT_PREC
    str=[str,sprintf('%s ephemeris : %s\n','%','precise')];
end

%% ionospheric
ionoopt=char(ionoopts{opt.ionoopt+1});
str=[str,sprintf('%s ionos opt : %s\n','%',ionoopt)];

%% tropspheric
tropopt=char(tropopts{opt.tropopt+1});
str=[str,sprintf('%s trops opt : %s\n','%',tropopt)];


%%
str=[str,sprintf('%s','%')];
fp=fopen(rtk.outfile,'w');
fprintf(fp,'%s',str);
fprintf(fp,'\n');
fclose(fp);

%%
if solopt.timef==glc.SOLT_GPST
    str_time=sprintf('%s  %-12s%s','%','GPST',sep);
elseif solopt.timef==glc.SOLT_UTC
    str_time=sprintf('%s  %-20s%s','%','UTC',sep);
else
    error('Time output options is wrong!!!');
end

if solopt.posf==glc.SOLF_XYZ
    str_pos=sprintf('%14s%s%14s%s%14s%s%3s%s%3s%s%8s%s%8s%s%8s%s%8s%s%8s%s%8s%s%6s%s%6s',...
                    'x-ecef(m)',sep,'y-ecef(m)',sep,'z-ecef(m)',sep,'Q',sep,'ns',sep,...
                   'sdx(m)',sep,'sdy(m)',sep,'sdz(m)',sep,'sdxy(m)',sep,...
                   'sdyz(m)',sep,'sdzx(m)',sep,'age(s)',sep,'ratio');
    if solopt.outvel==1
        str_vel=sprintf('%s%10s%s%10s%s%10s%s%9s%s%8s%s%8s%s%8s%s%8s%s%8s',...
                        sep,'vx(m/s)',sep,'vy(m/s)',sep,'vz(m/s)',sep,'sdvx',sep,...
                       'sdvy',sep,'sdvz',sep,'sdvxy',sep,'sdvyz',sep,'sdvzx');
    end
elseif solopt.posf==glc.SOLF_LLH
    str_pos=sprintf('%14s%s%14s%s%10s%s%3s%s%3s%s%8s%s%8s%s%8s%s%8s%s%8s%s%8s%s%6s%s%6s',...
                       'latitude(deg)',sep,'longitude(deg)',sep,'height(m)',sep,...
                       'Q',sep,'ns',sep,'sdn(m)',sep,'sde(m)',sep,'sdu(m)',sep,...
                       'sdne(m)',sep,'sdeu(m)',sep,'sdun(m)',sep,'age(s)',sep,'ratio');
    if solopt.outvel==1
        str_vel=sprintf('%s%10s%s%10s%s%10s%s%9s%s%8s%s%8s%s%8s%s%8s%s%8s',...
                        sep,'vn(m/s)',sep,'ve(m/s)',sep,'vu(m/s)',sep,'sdvn',sep,...
                        'sdve',sep,'sdvu',sep,'sdvne',sep,'sdveu',sep,'sdvun');
    end
else
    error('Position output options is wrong!!!');
end

if solopt.outatt==1
    str_att=sprintf('%s%10s%s%10s%s%10s%s%9s%s%8s%s%8s%s%8s%s%8s%s%8s',...
                    sep,'pitch(deg)',sep,'roll(deg)',sep,'yaw(deg)',sep,'sdp',sep,...
                    'sdr',sep,'sdy',sep,'sdpr',sep,'sdry',sep,'sdyp');
end
    
if opt.ins.mode==glc.GIMODE_OFF
    str=[str_time,str_pos];
    if ~strcmp(str_vel,'')
        str=[str,str_vel];
    end
else
    str=[str_time,str_pos];
    if ~strcmp(str_vel,'')
        str=[str,str_vel];
    end
    if ~strcmp(str_att,'')
        str=[str,str_att];
    end
end

fp=fopen(rtk.outfile,'a');
fprintf(fp,'%s',str);
fprintf(fp,'\n');
fclose(fp);

return

