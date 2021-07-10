function [fullname,ftime]=findobsrfile(filepath,sitename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global gls
fullname='';
ftime.ts=gls.gtime; ftime.te=gls.gtime; ftime.week=0; ftime.sow=0;
ftime.year=0; ftime.doy=0;

% search the obsr file
fileExt = '*.*O';
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = '*.*o';
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf==0,return,end
for i=1:nf
    if any(sitename)
        if ~isempty(strfind(files(i).name,sitename))&&...
                isempty(strfind(files(i).name,'base'))
            fullname=[filepath,files(i).name];
            break;
        end
    else
        if isempty(strfind(files(i).name,'base'))
            fullname=[filepath,files(i).name];
            break;
        end
    end
end

% get the observe time from obsr file
if ~isempty(fullname)
    ftime=getobstime(fullname,ftime);
end

return

