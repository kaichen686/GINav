function nav=readblq(nav,obsr,obsb,fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read ocean tide loading parameter(otlp) for rover and base
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading blq file %s...',fname0);
ns=0;

if obsr.n>0,sta(1)=obsr.sta;ns=1;end
if obsb.n>0,sta(2)=obsb.sta;ns=2;end
if ns==0,return;end

for i=1:ns
    fid=fopen(fname);
    sta_name=upper(sta(i).name);
    while ~feof(fid)
        line=fgets(fid);
        if ~isempty(strfind(line,'-cmc')),break;end
    end
    
    while ~feof(fid)
        line=fgets(fid);
        if ~isempty(strfind(line,'$$'))||size(line,2)<=2,continue;end 
        name=upper(line(3:6));
        if isempty(strfind(sta_name,name)),continue;end
        
        [otlp,fid,stat]=decode_blqdata(fid);
        
        if stat==1
            nav.otlp(:,:,i)=otlp';
        end
    end
    fclose(fid);
end

fprintf('over\n');

return

