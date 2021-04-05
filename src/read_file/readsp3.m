function nav=readsp3(nav,fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% only surpport to read ".sp3" or ".eph" file
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc

if ~isempty(strfind(fname,'.'))
    if isempty(strfind(fname,'sp3'))&&isempty(strfind(fname,'SP3'))&&...
        isempty(strfind(fname,'eph'))&&isempty(strfind(fname,'EPH'))
        error('The file %s is not surpported!!!',fname);
    end
end

idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading sp3 file %s...',fname0);

fid=fopen(fname);

% read sp3 header
[headinfo,fid]=decode_sp3h(fid);

% read sp3 body
nav=decode_sp3b(nav,headinfo,fid);


fprintf('over\n');

return

