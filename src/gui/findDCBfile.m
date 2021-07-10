function dcbfiles=findDCBfile(filepath,ftime)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dcbfiles={'','',''};

if ftime.year>=2000
    yy=ftime.year-2000;
else
    yy=ftime.year-1900;
end
yy=num2str(yy);

ep=time2epoch(ftime.ts);
month=ep(2);

if month<10
    mm=['0',num2str(month)];
else
    mm=num2str(month);
end

yymm=[yy,mm];

fileExt = '*.DCB';
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = '*.dcb';
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf>0
    for i=1:nf
        if ~isempty(strfind(files(i).name,yymm))
            dcbfiles{1,i}=[filepath,files(i).name];
        end
    end
end

return


