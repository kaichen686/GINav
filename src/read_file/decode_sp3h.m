function [headinfo,fid]=decode_sp3h(fid)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%read file header information
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc gls
type=' '; time=gls.gtime; ns=0;
sats=zeros(1,glc.MAXSAT); tsys=''; bfact=zeros(1,2);
n=0; idxns=0; idxc=0; idxf=0; idx_break=0;

while ~feof(fid)
    line=fgetl(fid);n=n+1;
    if n==1
        type=line(3);
        time=str2time(line(4:31));
    elseif strcmp(line(1),'+')
        if n==3,ns=str2double(line(3:6));end
        if idxns<ns
            j=0;
            while j<17
                sys=code2sys(line(10+3*j));
                prn=str2double(line(11+3*j:12+3*j));
                if sys==glc.SYS_QZS,prn=prn+192;end
                if idxns<=glc.MAXSAT
                    sats(idxns+1)=satno(sys,prn);
                    idxns=idxns+1;
                end
                j=j+1;
            end
        end
    elseif strcmp(line(1:2),'%c')&&idxc==0
        tsys=line(10:12);
        idxc=idxc+1;
    elseif strcmp(line(1:2),'%f')&&idxf==0 
        bfact(1)=str2double(line(4:13));
        bfact(2)=str2double(line(15:26)); 
        idxf=idxf+1;
    elseif strcmp(line(1:2),'/*')
        idx_break=idx_break+1;
        if idx_break==4
            break;
        end
    end
    
end

headinfo.type=type;
headinfo.time=time;
headinfo.ns=ns;
headinfo.sats=sats;
headinfo.tsys=tsys;
headinfo.bfact=bfact;

return

