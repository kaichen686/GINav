function nav=decode_sp3b(nav,headinfo,fid)
global glc gls
peph=gls.peph; 
NMAX=10000; nav.peph=repmat(gls.peph,NMAX,1);

if headinfo.type=='P'
    ns=headinfo.ns;
else
    ns=2*headinfo.ns;
end

%traversal by epoch
while ~feof(fid) 
    
    line=fgetl(fid);
    if strcmp(line,'EOF'),continue;end
    
    if line(1)~='*'
        fprintf('sp3 invalid epoch\n');
        continue;
    end
    
    time=str2time(line(4:31));
    if strcmp(headinfo.tsys,'UTC'),time=utc2gpst(time);end
    peph.time=time;
    
    %initialize peph struct
    for i=1:glc.MAXSAT
        for j=1:4
            peph.pos(i,j)=0;
            peph.std(i,j)=0;
            peph.vel(i,j)=0;
            peph.vst(i,j)=0;
        end
        for j=1:3
            peph.cov(i,j)=0;
            peph.vco(i,j)=0;
        end
    end
    
    for i=1:ns
        line=fgetl(fid);
        if size(line,2)<4||(line(1)~='P'&&line(1)~='V'),continue;end
        
        if line(2)==' '
            sys=glc.SYS_GPS;
        else
            sys=code2sys(line(2));
        end
        prn=str2double(line(3:4));
        if sys==glc.SYS_QZS,prn=prn+192;end
        sat=satno(sys,prn); 
        if ~sat,continue;end
        
        for j=1:4
            if j<=3
                m=2;k1=1000;base=headinfo.bfact(1);k2=10^-3;k3=0.1;k4=10^-7;
            else
                m=3;k1=10^-6;base=headinfo.bfact(2);k2=10^-12;k3=10^-10;k4=10^-16;
            end
            
            val=str2double(line(4+14*(j-1)+1:4+14*(j-1)+14));
            if size(line,2)>61
                std=str2double(line(61+3*(j-1)+1:61+3*(j-1)+m));
            else
                std=0;
            end
            
            if line(1)=='P'
                if val~=0&&abs(val-999999.999999)>=10^-6
                    peph.pos(sat,j)=val*k1; v=1;
                end
                if base>0&&std>0
                    peph.std(sat,j)=base^std*k2;
                end
            elseif v
                if val~=0&&abs(val-999999.999999)>=10^-6
                    peph.vel(sat,j)=val*k3;
                end
                if base>0&&std>0
                    peph.vst(sat,j)=base^std*k4;
                end
            end 
        end 
    end
    
    if v
        if nav.np>size(nav.peph,1)
            nav.peph(nav.np+1:nav.np+NMAX,1)=repmat(gls.peph,NMAX,1);
        end
        nav.peph(nav.np+1)=peph;
        nav.np=nav.np+1;
    end
    
end
fclose(fid);

if nav.np<size(nav.peph,1)
    nav.peph(nav.np+1:end,:)=[];
end

return

