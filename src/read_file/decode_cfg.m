function opt=decode_cfg(opt,fname)

global  glc

fid=fopen(fname);

while ~feof(fid)
    line=fgets(fid);
    if strcmp(line(1),'#')||size(line,2)<5,continue;end
    
    if ~isempty(strfind(line(1:14),'data_dir'))
        buff=strsplit(line);
        opt.filepath=char(buff(3));
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'site_name'))
        buff=strsplit(line);
        opt.sitename=char(buff(3));
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'start_time'))
        buff=strsplit(line);
        time_opt=str2double(buff(3));
        if time_opt==1
            time1=char(buff(4)); idx= time1=='/';time1(idx)=' ';
            time2=char(buff(5)); idx= time2==':';time2(idx)=' ';
            time_string=[time1,' ',time2];
            opt.ts=time_string;
        end
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'end_time'))
        buff=strsplit(line);
        time_opt=str2double(buff(3));
        if time_opt==1
            time1=char(buff(4)); idx= time1=='/';time1(idx)=' ';
            time2=char(buff(5)); idx= time2==':';time2(idx)=' ';
            time_string=[time1,' ',time2];
            opt.te=time_string;
        end
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'t_interval'))
        buff=str2double(strsplit(line));
        opt.ti=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'gnss_mode'))
        buff=str2double(strsplit(line));
        opt.mode=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'navsys'))
        buff=strsplit(line);
        opt.navsys=char(buff(3));
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'nfreq'))
        buff=str2double(strsplit(line));
        opt.nf=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'elmin'))
        buff=str2double(strsplit(line));
        opt.elmin=buff(3)*glc.D2R;
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'sateph'))
        buff=str2double(strsplit(line));
        opt.sateph=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'ionoopt'))
        buff=str2double(strsplit(line));
        opt.ionoopt=buff(3);
        continue;
    end
    
    
    if ~isempty(strfind(line(1:14),'tropopt'))
        buff=str2double(strsplit(line));
        opt.tropopt=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'dynamics'))
        buff=str2double(strsplit(line));
        opt.dynamics=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'tidecorr'))
        buff=str2double(strsplit(line));
        opt.tidecorr=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'armode'))
        buff=str2double(strsplit(line));
        opt.modear=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'gloar'))
        buff=str2double(strsplit(line));
        opt.glomodear=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'bdsar'))
        buff=str2double(strsplit(line));
        opt.bdsmodear=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'elmaskar'))
        buff=str2double(strsplit(line));
        opt.elmaskar=buff(3)*glc.D2R;
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'elmaskhold'))
        buff=str2double(strsplit(line));
        opt.elmaskhold=buff(3)*glc.D2R;
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'LAMBDAtype'))
        buff=str2double(strsplit(line));
        opt.LAMBDAtype=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'thresar'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.thresar(1)=buff(3);
        opt.thresar(2)=buff(4);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'bd2frq'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.bd2frq(1)=buff(3);
        opt.bd2frq(2)=buff(4);
        opt.bd2frq(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'bd3frq'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.bd3frq(1)=buff(3);
        opt.bd3frq(2)=buff(4);
        opt.bd3frq(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'gloicb'))
        buff=str2double(strsplit(line));
        opt.gloicb=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'gnsproac'))
        buff=str2double(strsplit(line));
        opt.gnsproac=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'posopt'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.posopt(1)=buff(3);
        opt.posopt(2)=buff(4);
        opt.posopt(3)=buff(5);
        opt.posopt(4)=buff(6);
        opt.posopt(5)=buff(7);
        opt.posopt(6)=buff(8);
        opt.posopt(7)=buff(9);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'maxout'))
        buff=str2double(strsplit(line));
        opt.maxout=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'minlock'))
        buff=str2double(strsplit(line));
        opt.minlock=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'minfix'))
        buff=str2double(strsplit(line));
        opt.minfix=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'niter'))
        buff=str2double(strsplit(line));
        opt.niter=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'maxinno'))
        buff=str2double(strsplit(line));
        opt.maxinno=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'maxgdop'))
        buff=str2double(strsplit(line));
        opt.maxgdop=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'csthres'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.csthres(1)=buff(3);
        opt.csthres(2)=buff(4);
        opt.csthres(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:3),'prn'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.prn(1)=buff(3);
        opt.prn(2)=buff(4);
        opt.prn(3)=buff(5);
        opt.prn(4)=buff(6);
        opt.prn(5)=buff(7);
        opt.prn(6)=buff(8);
        continue;
    end
    
    if ~isempty(strfind(line(1:3),'std'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.std(1)=buff(3);
        opt.std(2)=buff(4);
        opt.std(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:3),'err'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.err(1)=buff(3);
        opt.err(2)=buff(4);
        opt.err(3)=buff(5);
        opt.err(4)=buff(6);
        opt.err(5)=buff(7);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'sclkstab'))
        buff=str2double(strsplit(line));
        opt.sclkstab=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'eratio'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.eratio(1)=buff(3);
        opt.eratio(2)=buff(4);
        opt.eratio(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'antdelsrc'))
        buff=str2double(strsplit(line));
        opt.antdelsrc=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'antdel'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.antdel(1,1)=buff(3);
        opt.antdel(1,2)=buff(4);
        opt.antdel(1,3)=buff(5);
        opt.antdel(2,1)=buff(6);
        opt.antdel(2,2)=buff(7);
        opt.antdel(2,3)=buff(8);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'basepostype'))
        buff=str2double(strsplit(line));
        opt.basepostype=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'baserefpos'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.basepos(1)=buff(3);
        opt.basepos(2)=buff(4);
        opt.basepos(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'ins_mode'))
        buff=str2double(strsplit(line));
        opt.ins.mode=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'ins_aid'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.ins.aid(1)=buff(3);
        opt.ins.aid(2)=buff(4);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'data_format'))
        buff=str2double(strsplit(line));
        opt.ins.data_format=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'sample_rate'))
        buff=str2double(strsplit(line));
        opt.ins.sample_rate=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'lever'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.ins.lever(1)=buff(3);
        opt.ins.lever(2)=buff(4);
        opt.ins.lever(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'init_att_unc'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.ins.init_att_unc(1)=buff(3)*glc.D2R;
        opt.ins.init_att_unc(2)=buff(4)*glc.D2R;
        opt.ins.init_att_unc(3)=buff(5)*glc.D2R;
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'init_vel_unc'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.ins.init_vel_unc(1)=buff(3);
        opt.ins.init_vel_unc(2)=buff(4);
        opt.ins.init_vel_unc(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'init_pos_unc'))
        idx=line==','; line(idx)=' ';
        buff=str2double(strsplit(line));
        opt.ins.init_pos_unc(1)=buff(3)/glc.RE_WGS84;
        opt.ins.init_pos_unc(2)=buff(4)/glc.RE_WGS84;
        opt.ins.init_pos_unc(3)=buff(5);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'init_bg_unc'))
        buff=str2double(strsplit(line));
        opt.ins.init_bg_unc=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'init_ba_unc'))
        buff=str2double(strsplit(line));
        opt.ins.init_ba_unc=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'psd_gyro'))
        buff=str2double(strsplit(line));
        opt.ins.psd_gyro=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'psd_acce'))
        buff=str2double(strsplit(line));
        opt.ins.psd_acce=buff(3);
        continue;
    end
    
    
    if ~isempty(strfind(line(1:14),'psd_bg'))
        buff=str2double(strsplit(line));
        opt.ins.psd_bg=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'psd_ba'))
        buff=str2double(strsplit(line));
        opt.ins.psd_ba=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'timef'))
        buff=str2double(strsplit(line));
        opt.sol.timef=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'posf'))
        buff=str2double(strsplit(line));
        opt.sol.posf=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'outvel'))
        buff=str2double(strsplit(line));
        opt.sol.outvel=buff(3);
        continue;
    end
    
    if ~isempty(strfind(line(1:14),'outatt'))
        buff=str2double(strsplit(line));
        opt.sol.outatt=buff(3);
        continue;
    end
    
end

fclose(fid);

return

