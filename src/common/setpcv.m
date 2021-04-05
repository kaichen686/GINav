function [nav,opt]=setpcv(time,opt,nav,pcvs,pcvr,sta)

global glc gls

if opt.mode>=glc.PMODE_DGNSS&&opt.mode<=glc.PMODE_STATIC
    mode=2;
else
    mode=1;
end
opt.pcvr=repmat(gls.pcv,mode,1);

mask=set_sysmask(opt.navsys);

if pcvs.n>0
    for i=1:glc.MAXSAT
        [sys,~]=satsys(i);
        if mask(sys)==0,continue;end
        [pcv,stat]=searchpcv(i,'',time,pcvs);
        if stat==0
            id=satno2id(i);
            nav.pcvs(i)=gls.pcv;
            fprintf('Warning:%s,have no antenna parameters!\n',id);
            continue;
        end
        nav.pcvs(i)=pcv;
        
        if pcv.dzen==0
            j=10;
        else
            j=myRound((pcv.zen2-pcv.zen1)/pcv.dzen);
        end
        if     sys==glc.SYS_GPS,k=1;
        elseif sys==glc.SYS_GLO,k=1+1*glc.NFREQ;
        elseif sys==glc.SYS_GAL,k=1+2*glc.NFREQ;
        elseif sys==glc.SYS_BDS,k=1+3*glc.NFREQ;
        elseif sys==glc.SYS_QZS,k=1+4*glc.NFREQ;
        end
        dt=norm(pcv.var(k,1:j));
        if dt<=0.0001
            id=satno2id(i);
            fprintf('Info:%s,preliminary phase center correction\n',id);
        end
        
    end
end

anttype_=opt.anttype; opt=rmfield(opt,'anttype');
for i=1:mode
    
    % set antenna delta from obs
    if opt.antdelsrc==0
        sta(i).deltype=0;
        if sta(i).deltype==1 %xyz
            % not use
        elseif sta(i).deltype==0 %enu
            if norm(opt.antdel(i,:))==0
                for j=1:3
                    opt.antdel(i,j)=sta(i).del(j);
                end
            end
        end
    end
    
    % set antenna type
    if strcmp(anttype_(i),'*')
        opt.anttype{i}=sta(i).antdes;
    else
        opt.anttype{i}=anttype_(i);
    end
    
    if pcvr.n>0
        [pcv,stat]=searchpcv(0,char(opt.anttype{i}),time,pcvr);
        if stat==0
            opt.pcvr(i)=gls.pcv;
            if i==1
                fprintf('Warning:have no antenna parameters for rover!\n');
            elseif i==2
                fprintf('Warning:have no antenna parameters for base station!\n');
            end
            continue;
        end
        %opt.anttype(i,:)=pcv.type;
        opt.pcvr(i)=pcv;
    end
    
end

return



