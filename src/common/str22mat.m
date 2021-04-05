function mat=str22mat(str,n)

mat=zeros(n,1);
for i=1:n
    [tmp,str]=strtok(str); %#ok
    if isempty(tmp)
        break;
    end
    mat(i,1)=str2double(tmp);
end

return

