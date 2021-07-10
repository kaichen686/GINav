function fullname=findatxfile(filepath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fullname='';

fileExt = '*.atx';
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = '*.ATX';
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf>0
    for i=1:nf
        if ~isempty(strfind(files(i).name,'igs'))||...
                ~isempty(strfind(files(i).name,'IGS'))
            fullname=[filepath,files(i).name];
            break;
        end
    end
end

return