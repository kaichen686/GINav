function fullname=findbephfile(filepath,ftime,opt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fullname='';

doy=ftime.doy; 
if ftime.year>=2000
    yy=ftime.year-2000;
else
    yy=ftime.year-1900;
end

navsys=opt.navsys;

if strcmp(navsys,'G')
    fileExt = ['*.',num2str(yy),'n'];
    files = dir(fullfile(filepath,fileExt));
    if isempty(files)
        fileExt = ['*.',num2str(yy),'N'];
        files = dir(fullfile(filepath,fileExt));
    end
    nf=size(files,1);
    if nf>0
        for i=1:nf
            if ~isempty(strfind(files(i).name,num2str(doy)))
                fullname=[filepath,files(i).name];
                return
            end
        end
    end
elseif strcmp(navsys,'R')
    fileExt = ['*.',num2str(yy),'g'];
    files = dir(fullfile(filepath,fileExt));
    if isempty(files)
        fileExt = ['*.',num2str(yy),'G'];
        files = dir(fullfile(filepath,fileExt));
    end
    nf=size(files,1);
    if nf>0
        for i=1:nf
            if ~isempty(strfind(files(i).name,num2str(doy)))
                fullname=[filepath,files(i).name];
                return
            end
        end
    end
elseif strcmp(navsys,'E')
    fileExt = ['*.',num2str(yy),'e'];
    files = dir(fullfile(filepath,fileExt));
    if isempty(files)
        fileExt = ['*.',num2str(yy),'E'];
        files = dir(fullfile(filepath,fileExt));
    end
    nf=size(files,1);
    if nf>0
        for i=1:nf
            if ~isempty(strfind(files(i).name,num2str(doy)))
                fullname=[filepath,files(i).name];
                return
            end
        end
    end
elseif strcmp(navsys,'C')
    fileExt = ['*.',num2str(yy),'c'];
    files = dir(fullfile(filepath,fileExt));
    if isempty(files)
        fileExt = ['*.',num2str(yy),'C'];
        files = dir(fullfile(filepath,fileExt));
    end
    nf=size(files,1);
    if nf>0
        for i=1:nf
            if ~isempty(strfind(files(i).name,num2str(doy)))
                fullname=[filepath,files(i).name];
                return
            end
        end
    end
end

fileExt = ['*.',num2str(yy),'p'];
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = ['*.',num2str(yy),'P'];
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf>0
    for i=1:nf
        if ~isempty(strfind(files(i).name,num2str(doy)))
            fullname=[filepath,files(i).name];
        end
    end
end

return

