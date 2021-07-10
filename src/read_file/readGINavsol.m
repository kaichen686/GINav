function solution=readGINavsol(fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc gls
solution=repmat(gls.sol,5000,1); n=0;
fid=fopen(fname); 

while ~feof(fid)
    line=fgets(fid);
    if line(1)=='%'&&(~isempty(strfind(line,'GPST'))||~isempty(strfind(line,'UTC')))...
        &&(~isempty(strfind(line,'x-ecef(m)'))||~isempty(strfind(line,'latitude(deg)')))
        if ~isempty(strfind(line,'GPST'))
            timef=glc.SOLT_GPST;
        elseif ~isempty(strfind(line,'UTC'))
            timef=glc.SOLT_UTC;
        end
        
        if ~isempty(strfind(line,'x-ecef(m)'))
            posf=glc.SOLF_XYZ;
        elseif ~isempty(strfind(line,'latitude(deg)'))
            posf=glc.SOLF_LLH;
        end
        
        if ~isempty(strfind(line,'vx(m/s)'))||~isempty(strfind(line,'vn(m/s)'))
            outvel=1;
        else
            outvel=0;
        end
        
        if ~isempty(strfind(line,'pitch(deg)'))
            outatt=1;
        else
            outatt=0;
        end
        
        break;
    end
end

while ~feof(fid)
    line=fgets(fid);
    val=strsplit(line);
    
    if timef==glc.SOLT_GPST
        week=str2double(val(1));
        sow=str2double(val(2));
        time=gpst2time(week,sow);
    elseif timef==glc.SOLT_UTC
        str_time1=char(val(1));
        str_time2=char(val(2));
        idx1=(str_time1=='/'); str_time1(idx1)=' ';
        idx2=(str_time2==':'); str_time2(idx2)=' ';
        str=[str_time1,' ',str_time2];
        time=str2time(str);
    end
    
    val=str2double(strsplit(line));
    if posf==glc.SOLF_XYZ
        pos=val(3:5); 
        if outvel==1
            vel=val(16:18);
        else
            vel=zeros(1,3);
        end
    elseif posf==glc.SOLF_LLH
        pos=[val(3)*glc.D2R,val(4)*glc.D2R,val(5)];
        [pos,Cen]=blh2xyz(pos); pos=pos';
        if outvel==1
            vn=val(16); ve=val(17); vu=val(18);
            vel=[ve;vn;vu];
            vel=(Cen*vel)';
        else
            vel=zeros(1,3);
        end
    end
    
    if outatt==1
        att=val(25:27);
    else
        att=zeros(1,3);
    end
    
    stat=val(6);
    ns=val(7);
    age=val(14);
    ratio=val(15);
    
    solution(n+1,1).time=time;
    solution(n+1,1).pos=pos;
    solution(n+1,1).stat=stat;
    solution(n+1,1).ns=ns;
    solution(n+1,1).age=age;
    solution(n+1,1).ratio=ratio;
    solution(n+1,1).vel=vel;
    solution(n+1,1).att=att;
    n=n+1;
end

solution(n+1:end,:)=[];

return

