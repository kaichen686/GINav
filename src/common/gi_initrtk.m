function rtk=gi_initrtk(rtk,opt,rtk_align)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc gls

if opt.ins.mode==glc.GIMODE_LC
    rtk=rtk_align;
    rtk.gi_time=gls.gtime;
    rtk.ngnsslock=0;
elseif opt.ins.mode==glc.GIMODE_TC
    rtk.opt=opt;
    rtk.opt.ts=str2time(rtk.opt.ts);
    rtk.opt.te=str2time(rtk.opt.te);
    rtk.mask=set_sysmask(opt.navsys);
    rtk.gi_time=gls.gtime;
    
    if opt.mode==glc.PMODE_SPP
        NP=15; NC=glc.NSYS+1;
        NX=NP+NC; NR=NP+NC;
        rtk.NP=NP; rtk.NC=NC;
        rtk.ic=NP;
        
        % for receiver clk
        rtk.sol=rtk_align.sol;
        
    elseif opt.mode==glc.PMODE_DGNSS||opt.mode==glc.PMODE_KINEMA
        if opt.ionoopt==glc.IONOOPT_IFLC,NF=1;else,NF=opt.nf;end
        NP=15;
        if opt.ionoopt==glc.IONOOPT_EST,NI=glc.MAXSAT;else,NI=0;end
        if opt.tropopt<glc.TROPOPT_EST,NT=0;elseif opt.tropopt==glc.TROPOPT_EST,NT=2;else,NT=6;end
        if opt.glomodear~=2,NL=0;else,NL=2;end
        if opt.mode<=glc.PMODE_DGNSS,NB=0;else,NB=NF*glc.MAXSAT;end
        
        % number of parameter
        NR=NP+NI+NT+NL; NX=NR+NB;
        rtk.NF=NF;rtk.NP=NP;rtk.NI=NI;rtk.NT=NT;rtk.NL=NL;rtk.NB=NB;
        
        % index of parameter
        II=NP;ITR=NP+NI;ITB=NP+NI+NT/2;IL=NP+NI+NT;IB=NR;
        rtk.ii=II; rtk.itr=ITR; rtk.itb=ITB; rtk.il=IL; rtk.ib=IB;
        
        rtk.sol=rtk_align.sol;
    elseif opt.mode==glc.PMODE_PPP_KINEMA
        if opt.ionoopt==glc.IONOOPT_IFLC,NF=1;else,NF=opt.nf;end
        NP=15;
        NC=glc.NSYS+1;
        
        % for glonass inter-frequency code bias
        if opt.gloicb==0,                 NICB=0;
        elseif opt.gloicb==glc.GLOICB_LNF,NICB=1;
        else,                             NICB=2;
        end
        
        if opt.tropopt<glc.TROPOPT_EST,NT=0;elseif opt.tropopt==glc.TROPOPT_EST,NT=1;else,NT=3;end
        if opt.ionoopt==glc.IONOOPT_EST,NI=glc.MAXSAT;else,NI=0;end
        if opt.nf>=3,ND=1;else,ND=0;end
        
        % number of parameter
        NR=NP+NC+NICB+NT+NI+ND; NB=NF*glc.MAXSAT; NX=NR+NB;
        rtk.NF=NF;rtk.NP=NP;rtk.NC=NC;rtk.NICB=NICB;rtk.NT=NT;rtk.NI=NI;rtk.ND=ND;rtk.NB=NB;
        
        % index of parameter
        IC=NP; IICB=NP+NC; IT=NP+NC+NICB; II=NP+NC+NICB+NT; ID=NP+NC+NICB+NT+NI; IB=NR;
        rtk.ic=IC; rtk.iicb=IICB; rtk.it=IT; rtk.ii=II; rtk.id=ID; rtk.ib=IB;
        
        % for receiver clk
        rtk.sol=rtk_align.sol;
        
    else
        error('Under GNSS/INS integrated mode,the mode is not surpported!!!');
    end
    
    rtk.ngnsslock=0; %number of GNSS lock
    rtk.nx=NX; rtk.na=NR;
    rtk.x=zeros(rtk.nx,1);
    rtk.P=zeros(rtk.nx,rtk.nx);
    rtk.xa=zeros(rtk.na,1);
    rtk.Pa=zeros(rtk.na,rtk.na);
end
   
return

