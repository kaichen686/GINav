function ftime=getobstime(fullname,ftime)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nepoch=0;
fid=fopen(fullname);
[headinfo,fid]=decode_rnxh(fid);

while ~feof(fid)
    line=fgets(fid);
    if ~isempty(strfind(line,'END OF HEADER')),break,end
end

if headinfo.ver<=2.99
     while ~feof(fid)
        line=fgets(fid);
        if size(line,2)<=26,continue;end
        if line(4)~=' '||line(7)~=' '||line(10)~=' '||...
                line(13)~=' '||line(16)~=' '
            continue;
        end
        if line(2)==' '||line(3)==' '||(line(5)==' '&&line(6)==' ')
            continue;
        end
        
        if nepoch==0
            ftime.ts=str2time(line(2:29));
            nepoch=nepoch+1;
            continue;
        end
        
        ftime.te=str2time(line(2:29));
        nepoch=nepoch+1;
    end
else
    while ~feof(fid)
        line=fgets(fid);
        if ~strcmp(line(1),'>'),continue;end
        
        if nepoch==0
            ftime.ts=str2time(line(2:29));
            nepoch=nepoch+1;
            continue;
        end
        
        ftime.te=str2time(line(2:29));
        nepoch=nepoch+1;
    end
end
fclose(fid);

timespan=timediff(ftime.te,ftime.ts);
if timespan>0
    week=timespan/3600/24/7;
    if week>1
        error('Time span of the data is more than one week,not surpport!!!');
    end
else
    error('Time span of the data is zero!!!');
end

[ftime.week,ftime.sow]=time2gpst(ftime.te);
ep=time2epoch(ftime.ts); 
ftime.year=ep(1);
ftime.doy=fix(time2doy(ftime.te));

return

