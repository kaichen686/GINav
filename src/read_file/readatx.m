function nav=readatx(nav,fname)

global glc gls
freq=0; pcv0=gls.pcv; pcvs=gls.pcvs;
NMAX=10000; pcvs.pcv=repmat(gls.pcv,NMAX,1);

idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading atx file %s...',fname0);
fid=fopen(fname);

while ~feof(fid)
    
    line=fgets(fid);
    if size(line,2)<=60 || ~isempty(strfind(line(61:end),'COMMENT')),continue;end
    
    if ~isempty(strfind(line(61:end),'START OF ANTENNA'))
        pcv=pcv0;
    end
    
    if ~isempty(strfind(line(61:end),'END OF ANTENNA'))
        if pcvs.n+1>size(pcvs.pcv,1)
            pcvs.pcv(pcvs.n+1:pcvs.n+NMAX)=repmat(gls.pcv,NMAX,1);
        end
        pcvs.pcv(pcvs.n+1)=pcv;
        pcvs.n=pcvs.n+1;
        continue;
    end
    
    if ~isempty(strfind(line(61:end),'TYPE / SERIAL NO'))
        pcv.type=line(1:20);
        pcv.code=line(21:40);
        prn=fix(str2num(pcv.code(2:3)));%#ok
        if ~prn,continue;end 
        if strcmp(pcv.code(4:11),'        ')
            pcv.sat=satid2no(pcv.code);
        end
    elseif ~isempty(strfind(line(61:end),'VALID FROM'))
        time=str2time(line(1:43));
        pcv.ts=time; 
        continue;
    elseif ~isempty(strfind(line(61:end),'VALID UNTIL'))
        time=str2time(line(1:43));
        pcv.te=time;
        continue;
    elseif ~isempty(strfind(line(61:end),'DAZI'))
        pcv.dazi=str2num(line(3:8)); %#ok
        continue;
    elseif ~isempty(strfind(line(61:end),'ZEN1 / ZEN2 / DZEN'))
        pcv.zen1=str2num(line(3:8)); %#ok
        pcv.zen2=str2num(line(9:14)); %#ok
        pcv.dzen=str2num(line(15:20)); %#ok
        continue;
    elseif ~isempty(strfind(line(61:end),'START OF FREQUENCY'))
        [f,count]=sscanf(line(5:6),'%d');
        if count<1,continue;end
        [csys,count]=sscanf(line(4),'%c');
        if count<1,continue;end
        if     csys=='G'
            freq=f;
        elseif csys=='R'
            freq=f+glc.NFREQ;
        elseif csys=='E'
            if     f==1,freq=f+2*glc.NFREQ;
            elseif f==5,freq=2+2*glc.NFREQ;
            elseif f==6,freq=3+2*glc.NFREQ;
            else       ,freq=0;
            end
        elseif csys=='C'
            freq=f+3*glc.NFREQ; 
        elseif csys=='J'
            if      f<5,freq=f+4*glc.NFREQ;
            elseif f==5,freq=3+4*glc.NFREQ;
            else       ,freq=0;
            end
        else
            freq=0;
        end
    elseif ~isempty(strfind(line(61:end),'END OF FREQUENCY'))
        freq=0;  
    elseif ~isempty(strfind(line(61:end),'NORTH / EAST / UP'))
        %if freq<1||freq>glc.NFREQ,continue;end
        [neu,count]=decodef(line,3);
        if count<3,continue;end
        if freq<1,continue;end
        if pcv.sat~=0
            pcv.off(freq,:)=neu;
        else
            pcv.off(freq,:)=[neu(2),neu(1),neu(3)];
        end
    elseif ~isempty(strfind(line,'NOAZI'))
        if freq<1,continue;end
        dd=(pcv.zen2-pcv.zen1)/pcv.dzen+1;
        if dd~=myRound(dd)||dd<=1
            %fprintf('error');
            continue;
        end
        
        if pcv.dazi==0
            [val,count]=decodef(line(9:end),fix(dd));
            if count<=0
                %fprintf('error');
                continue
            elseif count~=fix(dd)
                %fprintf('error');
                continue
            end
            pcv.var(freq,1:count)=val;
        else
            id=fix(360/pcv.dazi)+1;
            
            for i=1:id
                line=fgets(fid);
                [val,j]=decodef(line(9:end),fix(dd));
                if j<=0,continue
                elseif j~=fix(dd),continue
                end
                pcv.var(freq,(i-1)*fix(dd)+1:(i-1)*fix(dd)+j)=val;
            end
        end
    end
    
end
fclose(fid);
fprintf('over\n');

if pcvs.n<size(pcvs.pcv,1)
    pcvs.pcv(pcvs.n+1:end,:)=[];
end
nav.ant_para=pcvs;

return

