function [data,fid,stat]=decode_data(fid,ver,data,mask,index)

global glc
stat=1;
val(1:glc.MAXOBSTYPE)=0; lli(1:glc.MAXOBSTYPE)=0;
p(1:glc.MAXOBSTYPE)=NaN; k(1:16)=NaN;l(1:16)=NaN;


line=fgets(fid,glc.MAXRNXLEN);
if ver>2.99
    satid=line(1:3);
    data.sat=satid2no(satid);
end

if data.sat==0, stat=0; end

[sys,~]=satsys(data.sat);
if sys==0,stat=0;return;end
if mask(sys)==0, stat=0; end

switch sys
    case glc.SYS_GPS, ind=index(sys);
    case glc.SYS_GLO, ind=index(sys);
    case glc.SYS_GAL, ind=index(sys);
    case glc.SYS_BDS, ind=index(sys);
    case glc.SYS_QZS, ind=index(sys);
end

if ver<=2.99,j=0;else,j=3;end
for i=1:ind.n
    if ver<=2.99&&j>=80
        line=fgets(fid,glc.MAXRNXLEN);
        j=0;
    end
    
    if j+15>size(line,2),j=j+16;continue;end
    
    if stat==1
        VAL=str2double(line(j+1:j+14));
        if ~isnan(VAL)
            val(i)=str2double(line(j+1:j+14))+ind.shift(i);
        end
        LLI=str2double(line(j+15));
        if ~isnan(LLI)
            lli(i)=bitand(LLI,3);
        end
    end
    j=j+16;
end

if stat==0,return;end

for i=1:glc.MAXFREQ
    data.P(i)=0; data.L(i)=0;
    data.D(i)=0; data.S(i)=0;
    data.LLI(i)=0; data.code(i)=0;
end

n=1;m=1;
for i=1:ind.n
    if ver<=2.11,p(i)=ind.frq(i);
    else,p(i)=ind.pos(i);end
    
    if ind.type(i)==1&&p(i)==1,k(n)=i;n=n+1;end
    if ind.type(i)==1&&p(i)==2,l(m)=i;m=m+1;end
end

if ver<=2.11
    if n>=3
        if val(k(1))==0&&val(k(2))==0
            p(k(1))=-1; p(k(2))=-1;
        elseif val(k(1))~=0&&val(k(2))==0
            p(k(1))=1;  p(k(2))=-1;
        elseif val(k(1))==0&&val(k(2))~=0
            p(k(1))=-1; p(k(2))=1;
        elseif ind.pri(k(2))>ind.pri(k(1))
            p(k(1))=-1; p(k(2))=1; 
        else
            p(k(1))=1;  p(k(2))=-1; 
        end
    end
    
    if m>=3
        if val(l(1))==0&&val(l(2))==0
            p(k(1))=-1; p(k(2))=-1;
        elseif val(l(1))~=0&&val(l(2))==0
            p(k(1))=2;  p(k(2))=-1;
        elseif val(l(1))==0&&val(l(2))~=0
            p(k(1))=-1; p(k(2))=2;
        elseif ind.pri(l(2))>ind.pri(l(1))
            p(k(1))=-1; p(k(2))=2; 
        else
            p(k(1))=2;  p(k(2))=-1; 
        end
    end
end

for i=1:ind.n
    if p(i)<1||val(i)==0,continue;end
    switch ind.type(i)
        case 1,data.P(p(i))=val(i);data.code(p(i))=ind.code(i);
        case 2,data.L(p(i))=val(i);data.LLI(p(i))=lli(i);
        case 3,data.D(p(i))=val(i);
        case 4,data.S(p(i))=char(val(i)*4.0+0.5);
    end
end

return

