function [eph,geph,type,fid,stat]=decode_navb_data(opt,ver,sys,fid)

global glc gls
eph=gls.eph; geph=gls.geph; type=0; stat=1;
data=zeros(1,64); buff(1:glc.MAXRNXLEN)=' ';
sp=3;  i=1; 

mask=set_sysmask(opt);

while ~feof(fid)
    line=fgets(fid);
    nl=size(line,2);
    for kk=1:nl
        buff(kk)=line(kk);
    end
    if i==1
        if ver>=3.0||sys==glc.SYS_GAL||sys==glc.SYS_QZS
            satid=buff(1:3);
            sat=satid2no(satid);
            sp=4;
            if ver>=3.0
                [sys,~]=satsys(sat);
            end
            if sys==glc.SYS_NONE,stat=0;return;end
        else
            prn=str2num(buff(1:2)); %#ok
            if sys==glc.SYS_GLO
                sat=satno(glc.SYS_GLO,prn);
            elseif prn>=93&&prn<=97
                sat=satno(glc.SYS_QZS,prn+100);
            else
                sat=satno(glc.SYS_GPS,prn);
            end
            if sys==glc.SYS_NONE,stat=0;return;end
        end
        
        toc=str2time(buff(sp:sp+19));
        
        p=sp+19;
        for j=1:3
            data(i)=str2num(buff(p+1:p+19)); %#ok
            i=i+1; p=p+19;
        end
    else
        p=sp;
        for j=1:4
            if strcmp(buff(p+1:p+19),'                   ')
                data(i)=0;
                i=i+1; p=p+19;
                continue;
            end
            data(i)=str2num(buff(p+1:p+19)); %#ok
            i=i+1; p=p+19;
        end
        
        if sys==glc.SYS_GLO&&i>=16
            if mask(sys)==0
                stat=0; return;
            end
            type=2;
            [geph,stat]=decode_geph(ver,sat,toc,data);
            return;
        elseif i>=32
            if mask(sys)==0
                stat=0; return;
            end
            type=1;
            [eph,stat]=decode_eph(ver,sat,toc,data);
            return;
        end
    end
end

return

