function time=str2time(str)

global gls
time=gls.gtime;

ep(1:6)=0;
for i=1:6
    [tmp,str]=strtok(str); %#ok
    if isempty(tmp)
        break;
    end
    ep(i)=str2double(tmp);
end

idx=(ep==NaN); %#ok
if any(idx),return;end

if ep(1)<100
    if ep(1)<80
        ep(1)=ep(1)+2000;
    else
        ep(1)=ep(1)+1900;
    end
end

time=epoch2time(ep);

return
