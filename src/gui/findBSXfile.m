function fullname=findBSXfile(filepath,ftime)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fullname='';

yyyy=num2str(ftime.year);

if ftime.doy<100
    ddd=['0',num2str(ftime.doy)];
else
    ddd=num2str(ftime.doy);
end

yyyyddd=[yyyy,ddd];

fileExt = '*.BSX';
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = '*.bsx';
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf>0
    for i=1:nf
        if ~isempty(strfind(files(i).name,'CAS'))&&...
                ~isempty(strfind(files(i).name,yyyyddd))
            fullname=[filepath,files(i).name];
            break
        end
    end
end

return
