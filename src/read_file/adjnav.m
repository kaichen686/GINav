function nav=adjnav(nav,opt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%adjust the wavelength of priority frequencies for BDS2 and BDS3
%eph and geph struct to eph and geph matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc

%adjust eph
if nav.n>0
    eph0=zeros(nav.n,40);
    for i=1:nav.n
        eph=nav.eph(i);
        eph0(i,:)=[eph.sat, eph.iode, eph.iodc, eph.sva, eph.svh, eph.week, eph.code, eph.flag, eph.toc.time, eph.toc.sec,...
            eph.toe.time, eph.toe.sec, eph.ttr.time, eph.ttr.sec, eph.A, eph.e, eph.i0, eph.OMG0, eph.omg, eph.M0,...
            eph.deln, eph.OMGd, eph.idot, eph.crc, eph.crs, eph.cuc, eph.cus, eph.cic, eph.cis, eph.toes,...
            eph.fit, eph.f0, eph.f1, eph.f2, eph.tgd, eph.Adot, eph.ndot];
    end
    nav=rmfield(nav,'eph');
    nav.eph=eph0;
end

%adjust geph
if nav.ng>0
    geph0=zeros(nav.ng,22);
    for i=1:nav.ng
        geph=nav.geph(i);
        geph0(i,:)=[geph.sat, geph.iode, geph.frq, geph.svh, geph.sva, geph.age, geph.toe.time, geph.toe.sec, geph.tof.time, geph.tof.sec,...
            geph.pos', geph.vel', geph.acc', geph.taun,...
            geph.gamn, geph.dtaun];
    end
    nav=rmfield(nav,'geph');
    nav.geph=geph0;
end

% adjust wavelength
bds_frq_flag=1;
lam=nav.lam; nav=rmfield(nav,'lam'); nav.lam=zeros(glc.MAXSAT,glc.NFREQ);
if glc.NFREQ>3&&(size(opt.bd2frq,2)<=3||size(opt.bd3frq,2)<=3)&&~isempty(strfind(opt.navsys,'C'))
    bds_frq_flag=0;
    fprintf('Warning:Specified frequency of BDS less than used number of frequency!\n');
end
for i=1:glc.MAXSAT
    [sys,prn]=satsys(i);
    if sys==glc.SYS_BDS
        if prn<19 %BD2
            if ~bds_frq_flag,continue;end
            frq=opt.bd2frq;
            for j=1:glc.NFREQ
               nav.lam(i,j)=lam(i,frq(j)); 
            end
        else %BD3
            if ~bds_frq_flag,continue;end
            frq=opt.bd3frq;
            for j=1:glc.NFREQ
                nav.lam(i,j)=lam(i,frq(j)); 
            end
        end
    else %GPS GLO GAL QZS
        nav.lam(i,:)=lam(i,1:3);
    end
end

return

