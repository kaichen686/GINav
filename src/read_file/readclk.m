function nav=readclk(nav,opt,fname)

global glc gls
NMAX=10000; nav.pclk=repmat(gls.pclk,NMAX,1);

idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading clk file %s...',fname0);
fid=fopen(fname);

% read renix header
while ~feof(fid)
    line=fgetl(fid);
    label=line(61:end);
    if size(line,2)<=60
        continue;
    elseif ~isempty(strfind(label,'RINEX VERSION / TYPE'))
        ver=str2double(line(1:9)); %#ok
        type=line(21);
    elseif ~isempty(strfind(label,'END OF HEADER'))
        break;
    end  
end

if type~='C'
    error('The file %s is not clock file!!!',fname0);
end

mask=set_sysmask(opt.navsys);

% read clk body
while ~feof(fid)
    
    buff(1:glc.MAXRNXLEN)=' ';
    line=fgets(fid);
    buff(1:size(line,2))=line;
    if size(buff,2)<8,continue; end
    if ~strcmp(buff(1:2),'AS'),continue;end
    
    satid=buff(4:8);
    sat=satid2no(satid);
    [sys,~]=satsys(sat);
    if sys==0,continue;end
    if mask(sys)==0,continue;end
    
    time=str2time(buff(8:34));
    clk=str2double(buff(41:59));
    std=str2double(buff(61:79));
    
    if isnan(clk),clk=0;end
    if isnan(std),std=0;end
    
    if nav.nc<=0
        nav.nc=nav.nc+1;
        nav.pclk(nav.nc).time=time;
    elseif abs(timediff(time,nav.pclk(nav.nc).time))>1e-9
        if nav.nc+1>size(nav.pclk,1)
            nav.pclk(nav.nc+1:nav.nc+NMAX)=repmat(gls.pclk,NMAX,1);
        end
        nav.nc=nav.nc+1;
        nav.pclk(nav.nc).time=time;
    end
    
    nav.pclk(nav.nc).clk(sat,1)=clk;
    nav.pclk(nav.nc).std(sat,1)=std;
end

if nav.nc<size(nav.pclk,1)
    nav.pclk(nav.nc+1:end,:)=[];
end

fclose(fid);
fprintf('over\n');

return


