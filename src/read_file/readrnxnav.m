function nav=readrnxnav(nav,opt,fname)

global glc
idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading nav file %s...',fname0);
fid=fopen(fname);

% read header
[headinfo,fid]=decode_rnxh(fid);
[nav,fid]=decode_navh(nav,fid);

% read body
[nav,stat]=decode_navb(nav,fid,opt.navsys,headinfo);

if stat==0
    error('\n Unsupported rinex nav message ver=%.2f type=%c!!!\n',headinfo.ver,headinfo.type);
end

% sort and unique nav
nav=uniqnav(nav);

fprintf('over\n');
return

