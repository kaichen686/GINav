function fullname=findblqfile(filepath)

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