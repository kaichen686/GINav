function [val,i]=decodef(str,n)

val=zeros(1,n); i=0;

for k=1:n
    [tmp,str]=strtok(str); %#ok
    if ~isempty(tmp)
        val(i+1)=str2double(tmp)*1e-3;
        i=i+1;
    end
end

return