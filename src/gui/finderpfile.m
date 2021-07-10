function fullname=finderpfile(filepath,ftime)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fullname='';

week=num2str(ftime.week);
fileExt = '*.erp';
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = '*.ERP';
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf>0
    for i=1:nf
        if ~isempty(strfind(files(i).name,week))
            fullname=[filepath,files(i).name];
            break;
        end
    end
end

return