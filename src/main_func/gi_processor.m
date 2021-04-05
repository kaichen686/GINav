function gi_processor(rtk,opt,obsr,obsb,nav,imu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% start gnss/ins processor to generate navigation solutions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%8/12/2020
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc gls
ins_align_flag=0; ins_realign_flag=0; ti=0;
rtk_align_falg=0; MAX_GNSS_OUTAGE=30;
oldobstime=gls.gtime;

hbar=waitbar(0,'Preparation...','Name','GINav', 'CreateCancelBtn', 'delete(gcbf);');
H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
hfig=figure;set(gcf,'Position',[x y w h]);

% initialize rtk_align sturct
rtk_align=initrtk(rtk,opt);

% set time span
tspan=timespan(rtk_align,obsr);
if tspan<=0,error('Time span is zero!!!');end

while 1
    
    if ti+1>tspan,break;end
    
    % search imu data
    [imud,imu,stat]=searchimu(imu);
    if stat==0
        str=sprintf('Processing... %.1f%%',100*tspan/tspan);
        waitbar(tspan/tspan,hbar,str);
        break;
    end
    
    % match rover obs
    [obsr_,nobsr]=matchobs(rtk_align,imud,obsr);
    
    % match base obs
    if (opt.mode==glc.PMODE_DGNSS||opt.mode==glc.PMODE_KINEMA)&&nobsr~=0
        [obsb_,nobsb]=searchobsb(obsb,obsr_(1).time);
        if nobsb~=0,[obsb_,~]=exclude_sat(obsb_,rtk_align);end
    else
        obsb_=NaN;
    end

    if nobsr~=0
        ti=ti+1;
        str=sprintf('Processing... %.1f%%',100*ti/tspan);
        waitbar(ti/tspan,hbar,str);
        
        % aviod duplicate observations
        if (oldobstime.time~=0&&timediff(oldobstime,obsr_(1).time)==0)...
                ||obsr_(1).time.sec~=0
            if ins_align_flag~=0
                ins=ins_mech(ins,imud);
                ins=ins_time_updata(ins);
            end
            oldobstime=obsr_(1).time;
            continue;
        end
        oldobstime=obsr_(1).time;

        if ins_align_flag==0
            % INS initial alignment
            [rtk_align,ins_align_flag]=ins_align(rtk_align,obsr_,obsb_,nav);
            if ins_align_flag==1
                ins=rtk_align.ins;
                rtk_gi=gi_initrtk(rtk,opt,rtk_align);
                if opt.ins.mode==glc.GIMODE_LC
                    rtk_gnss=rtk_align;
                end
                
                % write solution to output file
                ins.time=rtk_gi.sol.time;
                rtk_gi=ins2sol(rtk_gi,ins);
                outsol(rtk_gi);
                
                % kinematic plot
                plot_trajectory_kine(hfig,rtk_gi);
                fprintf('Info:INS initial alignment ok\n');
                
                % record previous information
                ins.oldpos=ins.pos;
                ins.oldobsr=obsr_;
                ins.oldobsb=obsb_;
            else
                % kinematic plot
                plot_trajectory_kine(hfig,rtk_align);
            end
        else
            % INS re-alignment
            gi_time=rtk_gi.gi_time;
            if gi_time.time~=0&&abs(timediff(ins.time,gi_time))>MAX_GNSS_OUTAGE
                if rtk_align_falg==0
                    rtk_align=initrtk(rtk,opt);
                    rtk_align_falg=1;
                end
                [rtk_align,ins_realign_flag]=ins_align(rtk_align,obsr_,obsb_,nav);
                if ins_realign_flag==1
                    % bg and ba are not reset
                    bg=ins.bg; ba=ins.ba;
                    ins=rtk_align.ins;
                    ins.bg=bg; ins.ba=ba;
                    rtk_gi=gi_initrtk(rtk,opt,rtk_align);
                    if opt.ins.mode==glc.GIMODE_LC
                        rtk_gnss=rtk_align;
                    end
                    rtk_align_falg=0;
                    
                    % write solution to output file
                    ins.time=rtk_gi.sol.time;
                    rtk_gi=ins2sol(rtk_gi,ins);
                    outsol(rtk_gi);
                    
                    % kinematic plot
                    plot_trajectory_kine(hfig,rtk_gi);
                    fprintf('Info:INS re-alignment ok\n');
                    
                    % record previous information
                    ins.oldpos=ins.pos;
                    ins.oldobsr=obsr_;
                    ins.oldobsb=obsb_;
                    continue;
                end
                
                % use INS solutions before re-alignment
                fprintf('Warning:GPS week = %d sow = %.3f,GNSS outage!\n',week,sow);
                ins=ins_mech(ins,imud);
                ins=ins_time_updata(ins);
                rtk_gi.ngnsslock=0;
                
                % write solution to output file
                rtk_gi=ins2sol(rtk_gi,ins);
                outsol(rtk_gi);

                % kinematic plot
                plot_trajectory_kine(hfig,rtk_gi);
                
                % record previous information
                ins.oldpos=ins.pos;
                ins.oldobsr=obsr_;
                ins.oldobsb=obsb_;
                continue;
            end
            
            % INS mechanization and time update
            ins=ins_mech(ins,imud);
            ins=ins_time_updata(ins);
            
            rtk_gi=ins2sol(rtk_gi,ins);
            
            % GNSS measurement update
            rtk_gi.ins=ins;
            if opt.ins.mode==glc.GIMODE_LC
                % GNSS/INS loosely couple
                [rtk_gi,rtk_gnss,stat_tmp]=gi_Loose(rtk_gi,rtk_gnss,obsr_,obsb_,nav);
            elseif opt.ins.mode==glc.GIMODE_TC
                % GNSS/INS tightly couple
                [rtk_gi,stat_tmp]=gi_Tight(rtk_gi,obsr_,obsb_,nav);
            end
            ins=rtk_gi.ins;
            if stat_tmp==0
                [week,sow]=time2gpst(obsr_(1).time);
                fprintf('Warning:GPS week = %d sow = %.3f,GNSS unavailable!\n',week,sow);
            end
            
            % write solution to output file
            outsol(rtk_gi);

            % kinematic plot
            plot_trajectory_kine(hfig,rtk_gi);
            
            % record previous information
            ins.oldpos=ins.pos;
            ins.oldobsr=obsr_;
            ins.oldobsb=obsb_;     
        end
        
    else
        if ins_align_flag==0,continue;end
        if rtk_align_falg==1&&ins_realign_flag==0,continue;end
        
        % INS mechanization and time update
        ins=ins_mech(ins,imud);
        ins=ins_time_updata(ins);
        
        % If GNSS is not available, use the INS solutions
        time1=ins.time.time+ins.time.sec;
        time2=round(ins.time.time+ins.time.sec);
        if nobsr<=0&&abs(time1-time2)<(0.501/rtk_gi.opt.ins.sample_rate)
            ti=ti+1;
            str=sprintf('Processing... %.1f%%',100*ti/tspan);
            waitbar(ti/tspan,hbar,str);
            fprintf('Warning:GPS week = %d sow = %.3f,GNSS outage!\n',week,sow);
            
            rtk_gi.ngnsslock=0;
            rtk_gi=ins2sol(rtk_gi,ins);
            
            % write solution to output file
            outsol(rtk_gi);

            % kinematic plot
            plot_trajectory_kine(hfig,rtk_gi);
        end
    end  
end

close(hbar);

return

