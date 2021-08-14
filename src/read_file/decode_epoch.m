function [time,ns,sats,flag,fid] = decode_epoch(ver,fid)

global glc gls
time=gls.gtime;
sats(1:glc.MAXOBS)=0;
flag=0;

line=fgets(fid);
if ver<=2.99 %ver 2.0
    ns=str2double(line(30:32)); %number of obs 
    if ns<=0,return;end
    
    flag=str2double(line(29)); % Epoch flag
    if flag>=3&&flag<=5,return;end
    
    time=str2time(line(1:26));

    j=32;
    for i=1:ns % record the satellite number 
        if j>=68
            line=fgetl(fid);j=32;
        end
        satid=line(j+1:j+3);
        sats(i)=satid2no(satid);
        j=j+3;    
    end
    
else %ver 3.0
    ns=str2double(line(33:35));
    if ns<=0,return;end
    
    flag=str2double(line(32));
    if flag>=3&&flag<=5,return;end
    
    if line(1)~='>',return;end
    
    time=str2time(line(2:29));
end

return

