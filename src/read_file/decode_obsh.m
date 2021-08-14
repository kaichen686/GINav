function [headinfo,nav,obs,tobs,fid]=decode_obsh(headinfo,nav,obs,fid)

global glc gls
tobs(1:glc.MAXOBSTYPE,1:3,glc.NSYS)=' '; del=zeros(3,1);
sta=gls.sta;

while ~feof(fid)
    line=fgets(fid);label=line(61:end);
    if size(line,2)<=60
        continue;
    elseif ~isempty(strfind(label,'MARKER NAME'))
        str=line(1:60);idx=find(str~=' ');
        if any(idx)
            str(idx(end)+1:end)=[];
            sta.name=str;
        end
    elseif ~isempty(strfind(label,'MARKER NUMBER'))
        str=line(1:20);idx=find(str~=' ');
        if any(idx)
            str(idx(end)+1:end)=[];
            sta.maker=str;
        end
    elseif ~isempty(strfind(label,'MAKER TYPE'))
    elseif ~isempty(strfind(label,'OBSERVER / AGENCY'))
    elseif ~isempty(strfind(label,'REC # / TYPE / VERS'))
        str=line(1:20);idx=find(str~=' ');
        if any(idx)
            str(idx(end)+1:end)=[];
            sta.recsno=str;
        end
        str=line(21:40);idx=find(str~=' ');
        if any(idx)
            str(idx(end)+1:end)=[];
            sta.rectype=str;
        end
        str=line(41:60);idx=find(str~=' ');
        if any(idx)
            str(idx(end)+1:end)=[];
            sta.recver=str;
        end
    elseif ~isempty(strfind(label,'ANT # / TYPE'))
        str=line(1:20);idx=find(str~=' ');
        if any(idx)
            str(idx(end)+1:end)=[];
            sta.antno=str;
        end
        str=line(21:40);idx=find(str~=' ');
        if any(idx)
            str(idx(end)+1:end)=[];
            sta.antdes=str;
        end
    elseif ~isempty(strfind(label,'APPROX POSITION XYZ'))
        j=1;
        for i=1:3
            sta.pos(i)=str2double(line(j:j+14));
            j=j+14;
        end
    elseif ~isempty(strfind(label,'ANTENNA: DELTA H/E/N'))
        j=1;
        for i=1:3
            del(i)=str2double(line(j:j+14));
            j=j+14;
        end
        sta.del(1)=del(2);sta.del(2)=del(3);sta.del(3)=del(1);
    elseif ~isempty(strfind(label,'ANTENNA: DELTA X/Y/Z'))
    elseif ~isempty(strfind(label,'ANTENNA: PHASECENTER'))
    elseif ~isempty(strfind(label,'ANTENNA: B.SIGHT XYZ'))
    elseif ~isempty(strfind(label,'ANTENNA: ZERODIR AZI'))
    elseif ~isempty(strfind(label,'ANTENNA: ZERODIR XYZ'))
    elseif ~isempty(strfind(label,'CENTER OF MASS: XYZ'))
    elseif ~isempty(strfind(label,'SYS / # / OBS TYPES' ))%ver 3.0
        syscode=line(1);
        switch syscode
            case 'G',i=glc.SYS_GPS;
            case 'R',i=glc.SYS_GLO;
            case 'E',i=glc.SYS_GAL;
            case 'C',i=glc.SYS_BDS;
            case 'J',i=glc.SYS_QZS;
            otherwise,continue; 
        end
        n=str2double(line(4:7));
        k=7;nt=1;
        for j=1:n
            if k>58
                line=fgetl(fid);
                k=7;
            end
            str=line(k+1:k+3);%idx=find(tmp~=' ');tmp(idx(end)+1:end)=[];
            tobs(nt,:,i)=str;
            nt=nt+1;
            k=k+4;
        end
        if i==4&&(headinfo.ver-3.02)<1e-3
            for j=1:nt
                if tobs(j,2,i)=='1'
                    tobs(j,2,i)='2';
                end
            end
        end
    elseif ~isempty(strfind(label,'WAVELENGTH FACT L1/2'))
    elseif ~isempty(strfind(label,'# / TYPES OF OBSERV'))%ver 2.0
        n=str2double(line(1:7));% number of obs type
        j=10;nt=1;
        for i=1:n
            if j>58
                line=fgetl(fid);
                j=10;
            end
            if headinfo.ver<=2.99
                str=line(j+1:j+2);idx=find(str~=' ');str(idx(end)+1:end)=[];
                tobs(nt,:,1)=convcode(headinfo.ver,str,glc.SYS_GPS);
                tobs(nt,:,2)=convcode(headinfo.ver,str,glc.SYS_GLO);
                tobs(nt,:,3)=convcode(headinfo.ver,str,glc.SYS_GAL);
                tobs(nt,:,4)=convcode(headinfo.ver,str,glc.SYS_BDS);
                tobs(nt,:,5)=convcode(headinfo.ver,str,glc.SYS_QZS);
            end
            nt=nt+1;
            j=j+6;
        end
    elseif ~isempty(strfind(label,'SIGNAL STRENGTH UNIT'))
    elseif ~isempty(strfind(label,'INTERVAL'))
    elseif ~isempty(strfind(label,'TIME OF FIRST OBS'))
        if     strcmp(line(49:51),'GPS'), headinfo.tsys=glc.TSYS_GPS;
        elseif strcmp(line(49:51),'GLO'), headinfo.tsys=glc.TSYS_GLO;
        elseif strcmp(line(49:51),'GAL'), headinfo.tsys=glc.TSYS_GAL;
        elseif strcmp(line(49:51),'BDT'), headinfo.tsys=glc.TSYS_BDS;
        elseif strcmp(line(49:51),'QZS'), headinfo.tsys=glc.TSYS_QZS;
        end
    elseif ~isempty(strfind(label,'TIME OF LAST OBS'))
    elseif ~isempty(strfind(label,'RCV CLOCK OFFS APPL'))
    elseif ~isempty(strfind(label,'SYS / DCBS APPLIED'))
    elseif ~isempty(strfind(label,'SYS / PCVS APPLIED'))
    elseif ~isempty(strfind(label,'SYS / SCALE FACTOR'))
    elseif ~isempty(strfind(label,'SYS / PHASE SHIFTS'))
    elseif ~isempty(strfind(label,'GLONASS SLOT / FRQ #'))
        p=5;
        for i=1:8
            prn=str2double(line(p+1:p+2));
            fcn=str2double(line(p+4:p+5));
            if prn>=1&&prn<=glc.MAXPRNGLO
                nav.glo_fcn(prn)=fcn+8;
                p=p+7;
            end
        end
    elseif ~isempty(strfind(label,'GLONASS COD/PHS/BIS'))
        p=1;
        for i=1:4
            if     strcmp(line(p+1:p+3),'C1C'),nav.glo_cpbias(1)=str2double(line(p+4:p+4+8));
            elseif strcmp(line(p+1:p+3),'C1P'),nav.glo_cpbias(2)=str2double(line(p+4:p+4+8));
            elseif strcmp(line(p+1:p+3),'C2C'),nav.glo_cpbias(3)=str2double(line(p+4:p+4+8));
            elseif strcmp(line(p+1:p+3),'C2P'),nav.glo_cpbias(4)=str2double(line(p+4:p+4+8));
            end
            p=p+13;
        end
    elseif ~isempty(strfind(label,'LEAP SECONDS'))
        nav.leaps=str2double(line(1:6));
    elseif ~isempty(strfind(label,'# OF SALTELLITES'))
    elseif ~isempty(strfind(label,'PRN / # OF OBS'))
    elseif ~isempty(strfind(label,'END OF HEADER'))
        break;
    end
end
obs.sta=sta;

return

