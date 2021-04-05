function pos=readsnx(sta_name,fname)

k=0; pos=zeros(1,3);
fid=fopen(fname);
while ~feof(fid)
    line = fgetl(fid);
    [tmp,line]=strtok(line);%#ok
    if strcmp(tmp,'+SOLUTION/APRIORI')
        while 1
            line = fgetl(fid);
            [tmp1,line]=strtok(line);%#ok
            [tmp2,line]=strtok(line);%#ok
            [tmp3,line]=strtok(line);%#ok
            if strcmp(tmp3,sta_name)
                [tmp,line]=strtok(line);%#ok
                [tmp,line]=strtok(line);%#ok
                [tmp,line]=strtok(line);%#ok
                [tmp,line]=strtok(line);%#ok
                [tmp,line]=strtok(line);%#ok
                [tmp,line]=strtok(line);%#ok
                pos(k+1)=str2num(tmp);%#ok
                k=k+1;
            end
            if (strcmp(tmp2,'STAZ') && strcmp(tmp3,sta_name)) || strcmp(tmp1,'-SOLUTION/APRIORI')
                break;
            end
        end
        break;
    end 
end
fclose(fid);

return

