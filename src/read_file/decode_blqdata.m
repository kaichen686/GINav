function [otlp,fid,stat]=decode_blqdata(fid)

stat=0; n=0;
otlp=zeros(6,11);

while ~feof(fid)
    line=fgets(fid);
    if ~isempty(strfind(line,'$$'))||size(line,2)<=2,continue;end
    
    v=str2double(strsplit(line));
    idx=~isnan(v);
    value=v(idx);
    for i=1:11
        otlp(n+1,i)=value(i);
    end
    n=n+1;
    if n==6
        stat=1;
        return;
    end
end

return