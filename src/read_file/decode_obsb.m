function obs=decode_obsb(headinfo,obs,tobs,opt,fid)
global glc gls
slips=zeros(glc.MAXSAT,glc.NFREQ); obs.data=repmat(gls.obsd,100000,1);

% set system mask
mask=set_sysmask(opt.navsys);

% set signal index
index(1)=set_index(headinfo.ver,glc.SYS_GPS,opt,tobs(:,:,1));
index(2)=set_index(headinfo.ver,glc.SYS_GLO,opt,tobs(:,:,2));
index(3)=set_index(headinfo.ver,glc.SYS_GAL,opt,tobs(:,:,3));
index(4)=set_index(headinfo.ver,glc.SYS_BDS,opt,tobs(:,:,4));
index(5)=set_index(headinfo.ver,glc.SYS_QZS,opt,tobs(:,:,5));

% read body
while ~feof(fid)
    
    data=repmat(gls.obsd,glc.MAXOBS,1);
    
    % read record of every epoch
    i=0; ndata=0;
    while ~feof(fid)
        if i==0
           [time,nsat,sats,flag,fid] = decode_epoch(headinfo.ver,fid);
           if nsat<=0,continue;end
        elseif flag<=2||flag==6
            data0.time=time;
            data0.sat =sats(i);
            [data0,fid,stat]=decode_data(fid,headinfo.ver,data0,mask,index);
            if stat==1
                data(ndata+1)=data0;
                ndata=ndata+1;
            end
        elseif flag==3||flag==4
            continue;
        end
        i=i+1;
        if i>nsat,break,end
    end
    
    % save data to obs struct
    if ndata==0,continue;end
    for i=1:ndata
        if headinfo.tsys==glc.TSYS_UTC
            data(i).time=utc2gpst(data(i).time);
        end
        [data(i),slips]=saveslips(data(i),slips);
    end
    if ~screent(data(1).time,opt.ts,opt.te,opt.ti),continue;end

    for i=1:ndata
        if obs.n+1>size(obs.data,1)
            obs.data(obs.n+1:obs.n+100000,1)=repmat(gls.obsd,100000,1);
        end
        [data(i),slips]=restslips(data(i),slips);
        obs.data(obs.n+1)=data(i);
        obs.n=obs.n+1;
    end
    
    clearvars data
    
end
fclose(fid);

if obs.n<size(obs.data,1)
    obs.data(obs.n+1:end,:)=[];
end

return

