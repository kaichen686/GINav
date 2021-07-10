function [nav,stat]=decode_navb(nav,fid,opt,headinfo)
global glc gls
stat=1; NMAX=10000;
nav.eph=repmat(gls.eph,NMAX,1); nav.geph=repmat(gls.geph,NMAX,1);

switch headinfo.type
    case 'N',sys=headinfo.sys;
    case 'G',sys=glc.SYS_GLO;
    case 'L',sys=glc.SYS_GAL;
    case 'J',sys=glc.SYS_QZS;
    otherwise,stat=0;return;
end

while ~feof(fid)

    [eph,geph,type,fid,stat0]=decode_navb_data(opt,headinfo.ver,sys,fid);
    
    if stat0==1
        switch type
            case 1
                if nav.n+1>size(nav.eph,1)
                    nav.eph(nav.n+1:nav.n+NMAX,1)=repmat(gls.eph,NMAX,1);
                end
                nav.eph(nav.n+1)=eph; 
                nav.n=nav.n+1; 
            case 2
                if nav.ng+1>size(nav.geph,1)
                    nav.geph(nav.ng+1:nav.ng+NMAX,1)=repmat(gls.geph,NMAX,1);
                end
                nav.geph(nav.ng+1)=geph; 
                nav.ng=nav.ng+1;
        end
    end 
end
fclose(fid);

if nav.n<size(nav.eph,1)
    nav.eph(nav.n+1:end,:)=[];
end
if nav.ng<size(nav.geph,1)
    nav.geph(nav.ng+1:end,:)=[];
end

return

