function nav=readerp(nav,fname)

global glc gls
flag=0; n=0; erp=gls.erp;

idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading erp file %s...',fname0);
fid=fopen(fname);

% read data
while ~feof(fid)
    line=fgets(fid,266);
    
    if ~isempty(strfind(line,'MJD')),flag=1;end
    if flag==0,continue;end
    if flag==1
        line=fgets(fid); %#ok<NASGU>
        flag=2; continue;
    end
    if flag==2
        value=str2double(strsplit(line));
        erp.data(n+1).mjd    =value(1);
        erp.data(n+1).xp     =value(2)*1e-6*glc.AS2R;
        erp.data(n+1).yp     =value(3)*1e-6*glc.AS2R;
        erp.data(n+1).ut1_utc=value(4)*1e-7;
        erp.data(n+1).lod    =value(5)*1e-7;
        erp.data(n+1).xpr    =value(13)*1e-6*glc.AS2R;
        erp.data(n+1).ypr    =value(14)*1e-6*glc.AS2R;
        n=n+1;
    end
end

fclose(fid);
fprintf('over\n');

erp.n=n;
erp.nmax=n;
nav.erp=erp;

return

