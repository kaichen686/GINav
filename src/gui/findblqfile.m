function fullname=findblqfile(filepath)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fullname='';

fileExt = '*.blq';
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = '*.BLQ';
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf>0
    fullname=[filepath,files(1).name];
end

return