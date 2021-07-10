function [eph,stat]=decode_eph(ver,sat,toc,data) %#ok
global glc gls
eph=gls.eph; stat=1;
sys=satsys(sat);

if sys~=glc.SYS_GPS&&sys~=glc.SYS_GAL&&sys~=glc.SYS_BDS&&sys~=glc.SYS_QZS
    stat=0; return;
end

eph.sat=sat;
eph.toc=toc;

% 3 satellite clock  parameter
eph.f0=data(1);
eph.f1=data(2);
eph.f2=data(3);

% 15 satellite orbit parameter
eph.A=data(11)^2;  eph.e=data(9); eph.i0=data(16);  eph.OMG0=data(14);
eph.omg=data(18); eph.M0=data(7); eph.deln=data(6); eph.OMGd=data(19);
eph.idot=data(20);  
eph.crc=data(17); eph.crs=data(5); 
eph.cuc=data(8);  eph.cus=data(10);   
eph.cic=data(13); eph.cis=data(15);

if sys==glc.SYS_GPS||sys==glc.SYS_QZS 
    eph.iode=fix(data(4));
    eph.iodc=fix(data(27));
    eph.toes=data(12);
    eph.week=fix(data(22));
    eph.toe =adjweek(gpst2time(eph.week,data(12)),toc);
    eph.ttr =adjweek(gpst2time(eph.week,data(28)),toc);

    eph.code=fix(data(21));
    eph.svh =fix(data(25));
    eph.sva =uraindex(data(24));
    eph.flag=fix(data(23));
    
    eph.tgd(1)=data(26);
    if sys==glc.SYS_GPS
        eph.fit=data(29);
    else
        if data(29)==0,eph.fit=1;
        else,eph.fit=2;
        end
    end
    
elseif sys==glc.SYS_GAL %GAL ver.3
    eph.iode=fix(data(4));
    eph.toes=data(12);
    eph.week=fix(data(22));
    eph.toe =adjweek(gpst2time(eph.week,data(12)),toc);
    eph.ttr =adjweek(gpst2time(eph.week,data(28)),toc);
    
    eph.code=fix(data(21));
    eph.svh =fix(data(25));
    eph.sva =sisa_index(data(24));
    
    eph.tgd(1)=data(26);
    eph.tgd(2)=data(27);
    
elseif sys==glc.SYS_BDS %BDS ver.3.02
    eph.toc=bdt2gpst(eph.toc);
    eph.iode=fix(data(4));
    eph.iodc=fix(data(29));
    eph.toes=data(12);
    eph.week=fix(data(22));
    eph.toe =bdt2gpst(bdt2time(eph.week,data(12)));
    eph.ttr =bdt2gpst(bdt2time(eph.week,data(28)));
    eph.toe =adjweek(eph.toe,toc);
    eph.ttr =adjweek(eph.ttr,toc);
    
    eph.svh=fix(data(25));
    eph.sva=uraindex(data(24));
    
    eph.tgd(1)=data(26);
    eph.tgd(2)=data(27);
    
end

return

