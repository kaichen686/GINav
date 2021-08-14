function nav=readdcb(nav,obs,fname)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%only read dcb for GPS or GLONASS(CODE procuct)
%convert CODE product to consistent with CAS product
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
type=0; DCBPAIR=glc.DCBPAIR;

idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading DCB file %s...',fname0);
fid=fopen(fname);

while ~feof(fid)

    line=fgets(fid);
    
    if     ~isempty(strfind(line,'DIFFERENTIAL (P1-P2) CODE BIASES')),type=1;
    elseif ~isempty(strfind(line,'DIFFERENTIAL (P1-C1) CODE BIASES')),type=2;
    elseif ~isempty(strfind(line,'DIFFERENTIAL (P2-C2) CODE BIASES')),type=3;
    end
    
    if type==0,continue;end
    if isempty(line),continue;end
    
    if line(1)~='G'&&line(1)~='R',continue;end
    buff=strsplit(line);
    cbias=str2double(line(27:35));
    
    if strcmp(buff(1),'G')||strcmp(buff(1),'R') %for receiver
        if ~isfield(obs,'sta'),continue;end
        if strcmp(buff(1),'G'),j=1;else,j=2;end
        if strcmpi(obs.sta.name,char(buff(2)))
            nav.rbias(j,type)=cbias*1E-9*glc.CLIGHT;
        end
    else %for satellite
        sat=satid2no(char(buff(1)));
        if sat~=0
            [sys,~]=satsys(sat);
            if type==1
                dcb_pair='C1W-C2W'; %P1-P2
                if sys==glc.SYS_GPS
                    for i=1:glc.MAXDCBPAIR
                        if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end
                    end
                    nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
                elseif sys==glc.SYS_GLO
                    dcb_pair='C1P-C2P'; %P1-P2
                    for i=1:glc.MAXDCBPAIR
                        if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end
                    end
                    nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
                end
            elseif type==2
                dcb_pair='C1C-C1W'; %C1-P1
                if sys==glc.SYS_GPS
                    for i=1:glc.MAXDCBPAIR
                        if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end
                    end
                    nav.cbias(sat,i)=-cbias*1E-9*glc.CLIGHT; %note the minus sign !
                elseif sys==glc.SYS_GLO
                    dcb_pair='C1C-C1P'; %C1-P1
                    for i=1:glc.MAXDCBPAIR
                        if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end
                    end
                    nav.cbias(sat,i)=-cbias*1E-9*glc.CLIGHT; %note the minus sign !
                end
            elseif type==3
                dcb_pair='C2W-C2L'; %P2-C2
                if sys==glc.SYS_GPS
                    for i=1:glc.MAXDCBPAIR
                        if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end
                    end
                    nav.cbias(sat,i)=cbias*1E-9*glc.CLIGHT;
                elseif sys==glc.SYS_GLO
                    dcb_pair='C2C-C2P'; %C2-P2
                    for i=1:glc.MAXDCBPAIR
                        if strcmp(dcb_pair,DCBPAIR(sys,i)),break;end
                    end
                    nav.cbias(sat,i)=-cbias*1E-9*glc.CLIGHT; %note the minus sign !
                end
            end
        end
    end
end

fclose(fid);
fprintf('over\n');

return

