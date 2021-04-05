function [obs,nav]=readrnxobs(obs,nav,opt,fname)

global glc
idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading obs file %s...',fname0);

fid=fopen(fname);
% read renix header
[headinfo,fid]=decode_rnxh(fid);

if headinfo.type~='O'
    error('\n The file %s is not renix observation file!!!\n',fname);
end

% decode file header
[headinfo,nav,obs,tobs,fid]=decode_obsh(headinfo,nav,obs,fid);

% decode body
obs=decode_obsb(headinfo,obs,tobs,opt,fid);
if obs.n==0,return;end

% sort obs
obs=sortobs(obs);

fprintf('over\n');

return

