%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Global constant/Global struct for GINav
%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear 
clear global glc gls
global  glc gls

%% windows or unix/linux
if ispc
    glc.system=0; glc.sep='\';
elseif isunix
    glc.system=1; glc.sep='/';
else
    error('GINav does not support this operating system!');
end

%%
% glc.Re = 6378137;            
% glc.f = 1/298.257;           
% glc.Rp = (1-glc.f)*glc.Re;      
% glc.e = sqrt(2*glc.f-glc.f^2); 
% glc.e2 = glc.e^2;              
% glc.ep = sqrt(glc.Re^2-glc.Rp^2)/glc.Rp; 
% glc.ep2 = glc.ep^2;           
% glc.wie = 7.2921151467e-5;    
% glc.meru = glc.wie/1000;      
% glc.g0 = 9.7803267714;     
% glc.mg = 1.0e-3*glc.g0;      
% glc.ug = 1.0e-6*glc.g0;        
% glc.mGal = 1.0e-3*0.01;      
% glc.ugpg2 = glc.ug/glc.g0^2;   
% glc.ws = 1/sqrt(glc.Re/glc.g0); 
% glc.ppm = 1.0e-6;             
% glc.deg = pi/180;             
% glc.min = glc.deg/60;        
% glc.sec = glc.min/60;         
% glc.hur = 3600;              
% glc.dps = pi/180/1;         
% glc.dph = glc.deg/glc.hur;    
% glc.dpss = glc.deg/sqrt(1);    
% glc.dpsh = glc.deg/sqrt(glc.hur);  
% glc.dphpsh = glc.dph/sqrt(glc.hur); 
% glc.Hz = 1/1;                 
% glc.dphpsHz = glc.dph/glc.Hz;  
% glc.ugpsHz = glc.ug/sqrt(glc.Hz);  
% glc.ugpsh = glc.ug/sqrt(glc.hur);
% glc.mpsh = 1/sqrt(glc.hur);    
% glc.mpspsh = 1/1/sqrt(glc.hur); 
% glc.ppmpsh = glc.ppm/sqrt(glc.hur);
% glc.mil = 2*pi/6000;           
% glc.nm = 1853;                  
% glc.kn = glc.nm/glc.hur;        


%%
glc.PI          =3.1415926535897932;  %pi 
glc.D2R         =(glc.PI/180.0);      %deg to rad 
glc.R2D         =(180.0/glc.PI);      %rad to deg
glc.CLIGHT      =299792458.0;         %speed of light (m/s)
glc.SC2RAD      =3.1415926535898;     %semi-circle to radian (IS-GPS) 
glc.AU          =149597870691.0;      %1 AU (m) 
glc.AS2R        =(glc.D2R/3600.0);    %arc sec to radian 
glc.OMGE        =7.2921151467E-5;     %earth angular velocity (IS-GPS) (rad/s)
glc.RE_WGS84    =6378137.0;           %earth semimajor axis (WGS84) (m) 
glc.FE_WGS84    =(1.0/298.257223563); %earth flattening (WGS84)
glc.ECC_WGS84   =sqrt(2*glc.FE_WGS84-glc.FE_WGS84^2); %earth eccentricity
glc.RP_WGS84    =(1-glc.FE_WGS84)*glc.RE_WGS84; 
glc.E1          =sqrt(glc.RE_WGS84^2-glc.RP_WGS84^2)/glc.RE_WGS84;
glc.E2          =sqrt(glc.RE_WGS84^2-glc.RP_WGS84^2)/glc.RP_WGS84;
glc.HION        =350000.0;            %ionosphere height (m)


%%
glc.MU_GPS   =3.9860050E14;     %earth gravitational constant
glc.MU_GLO   =3.9860044E14;     %earth gravitational constant
glc.MU_GAL   =3.986004418E14;   %earth gravitational constant
glc.MU_BDS   =3.986004418E14;   %earth gravitational constant

%%
glc.EFACT_GPS   =1.0;                 %error factor: GPS
glc.EFACT_GLO   =1.5;                 %error factor: GLONASS
glc.EFACT_GAL   =1.0;                 %error factor: Galileo
glc.EFACT_BDS   =1.0;                 %error factor: BeiDou 
glc.EFACT_QZS   =1.0;                 %error factor: QZSS

%%
glc.SYS_NONE=0;
glc.SYS_GPS=1;
glc.SYS_GLO=2;
glc.SYS_GAL=3;
glc.SYS_BDS=4;
glc.SYS_QZS=5;

%%
glc.TSYS_GPS=1;
glc.TSYS_GLO=2;
glc.TSYS_GAL=3;
glc.TSYS_BDS=4;
glc.TSYS_QZS=5;
glc.TSYS_UTC=6;

%%
glc.MINPRNGPS   =1;                   %min satellite PRN number of GPS
glc.MAXPRNGPS   =32;                  %max satellite PRN number of GPS
glc.NSATGPS     =(glc.MAXPRNGPS-glc.MINPRNGPS+1); %number of GPS satellites
glc.NSYSGPS     =1;


glc.MINPRNGLO   =1;                   %min satellite slot number of GLONASS
glc.MAXPRNGLO   =27;                  %max satellite slot number of GLONASS
glc.NSATGLO     =(glc.MAXPRNGLO-glc.MINPRNGLO+1); %number of GLONASS satellites
glc.NSYSGLO     =1;


glc.MINPRNGAL   =1;                   %min satellite PRN number of Galileo 
glc.MAXPRNGAL   =36;                  %max satellite PRN number of Galileo 
glc.NSATGAL     =(glc.MAXPRNGAL-glc.MINPRNGAL+1); %/* number of Galileo satellites 
glc.NSYSGAL     =1;

glc.MINPRNBDS   =1;                   %min satellite sat number of BeiDou
glc.MAXPRNBDS   =45;                  %max satellite sat number of BeiDou
glc.NSATBDS     =(glc.MAXPRNBDS-glc.MINPRNBDS+1); %number of BeiDou satellites
glc.NSYSBDS     =1;

glc.MINPRNQZS   =193;                 %min satellite PRN number of QZSS
glc.MAXPRNQZS   =202;                 %max satellite PRN number of QZSS
glc.MINPRNQZS_S =183;                 %min satellite PRN number of QZSS SAIF
glc.MAXPRNQZS_S =191;                 %max satellite PRN number of QZSS SAIF
glc.NSATQZS     =(glc.MAXPRNQZS-glc.MINPRNQZS+1); %number of QZSS satellites
glc.NSYSQZS     =1;

glc.NSYS   =glc.NSYSGPS+glc.NSYSGLO+glc.NSYSGAL+glc.NSYSBDS+glc.NSYSQZS; %number of systems
glc.MAXSAT =glc.NSATGPS+glc.NSATGLO+glc.NSATGAL+glc.NSATBDS+glc.NSATQZS;

glc.BD2_GEO=[1,2,3,4,5];
glc.BD2_IGSO=[6,7,8,9,10,13,16];
glc.BD2_MEO=[11,12,14];

%%
glc.MAXOBSTYPE  =64;                  %max number of obs type in RINEX
glc.NFREQ       =3;                   %max used freq
glc.MAXFREQ     =6;                   %max freq for record
glc.NFREQGLO    =2;
glc.MAXOBS      =128;
glc.MAXRNXLEN   =16*glc.MAXOBSTYPE+4;
glc.MAXAGE      =30;                  %max age of differential between rover obs and base obs
glc.DTTOL       =0.025;

%%
glc.MAXDTOE     =7200.0;              %max time difference to GPS Toe (s) 
glc.MAXDTOE_QZS =7200.0;              %max time difference to QZSS Toe (s)
glc.MAXDTOE_GAL =14400.0;             %max time difference to Galileo Toe (s)
glc.MAXDTOE_BDS =21600.0;             %max time difference to BeiDou Toe (s) 
glc.MAXDTOE_GLO =1800.0;              %max time difference to GLONASS Toe (s)
glc.MAXDTOE_SBS =360.0;               %max time difference to SBAS Toe (s)
glc.MAXDTOE_S   =86400.0;             %max time difference to ephem toe (s) for other
glc.MAXGDOP     =300.0;               %max GDOP

%%
glc.OPT_TS='0000 00 00 00 00 00';     % default start time to process data
glc.OPT_TE='0000 00 00 00 00 00';     % default end   time to process data

glc.PMODE_SPP        =1;              % positioning mode: SPP 
glc.PMODE_DGNSS      =2;              % positioning mode: DGNSS
glc.PMODE_KINEMA     =3;              % positioning mode: relative kinematic 
glc.PMODE_STATIC     =4;              % positioning mode: relative static 
glc.PMODE_PPP_KINEMA =5;              % positioning mode: PPP-kinematic
glc.PMODE_PPP_STATIC =6;              % positioning mode: PPP-static

glc.SOLT_GPST   =1;
glc.SOLT_UTC    =2;

glc.SOLF_XYZ    =1;                   % solution format: x/y/z-ecef
glc.SOLF_LLH    =2;                   % solution format: lat/lon/height

glc.SOLQ_NONE   =0;                   % solution status: no solution 
glc.SOLQ_FIX    =1;                   % solution status: fix 
glc.SOLQ_FLOAT  =2;                   % solution status: float
glc.SOLQ_INS    =3;                   % solution status: pure INS
glc.SOLQ_DGNSS  =4;                   % solution status: DGNSS 
glc.SOLQ_SPP    =5;                   % solution status: SPP
glc.SOLQ_PPP    =6;                   % solution status: PPP 
glc.SOLQ_LC     =7;                   % solution status: GNSS/INS loosely coupled
glc.SOLQ_TC     =8;                   % solution status: GNSS/INS tightly coupled

glc.TIMES_GPST  =0;                   % time system: gps time
glc.TIMES_UTC   =1;                   % time system: utc 
glc.TIMES_JST   =2;                   % time system: jst 

glc.IONOOPT_OFF =0;                   % ionosphere option: correction off 
glc.IONOOPT_BRDC =1;                  % ionosphere option: broadcast model 
glc.IONOOPT_IFLC =2;                  % ionosphere option: L1/L2 or L1/L5 iono-free LC 
glc.IONOOPT_EST =3;                   % ionosphere option: estimation 

glc.TROPOPT_OFF  =0;                   % troposphere option: correction off 
glc.TROPOPT_SAAS =1;                   % troposphere option: Saastamoinen model 
glc.TROPOPT_EST  =2;                   % troposphere option: ZTD estimation 
glc.TROPOPT_ESTG =3;                   % troposphere option: ZTD+grad estimation 

glc.EPHOPT_BRDC =1;                   % ephemeris option: broadcast ephemeris
glc.EPHOPT_PREC =2;                   % ephemeris option: precise ephemeris

glc.ARMODE_OFF  =0;                   % AR mode: off
glc.ARMODE_CONT =1;                   % AR mode: continuous 
glc.ARMODE_INST =2;                   % AR mode: instantaneous 
glc.ARMODE_FIXHOLD =3;                % AR mode: fix and hold 

glc.POSOPT_POS   =1;                  % ref pos option: WGS84-XYZ 
glc.POSOPT_SPP   =2;                  % ref pos option: average of spp 
glc.POSOPT_RINEX =3;                  % ref pos option: rinex header pos 

glc.LAMBDA_ALL  =1;                   % LAMBDA type: resolve all abmbiguity
glc.LAMBDA_PART =2;                   % LAMBDA type: resolve partial abmbiguity

glc.GLOICB_OFF =0;                   % GLONASS icb: off
glc.GLOICB_LNF =1;                   % GLONASS icb: linear function of frequency number
glc.GLOICB_QUAD=2;                   % GLONASS icb: quadratic polynomial function of frequency number

glc.AC_WUM = 1;
glc.AC_GBM = 2;
glc.AC_COM = 3;

glc.GIMODE_OFF = 0;                 % GNSS/INS mode: off
glc.GIMODE_LC   = 1;                % GNSS/INS mode: loosely couple
glc.GIMODE_TC   = 2;                % GNSS/INS mode: tightly couple

%%
glc.MHZ_TO_HZ     =1000000.0;
glc.FREQ_NONE     =0.0;
glc.FREQ_GPS_L1   =1575.42*glc.MHZ_TO_HZ;
glc.FREQ_GPS_L2   =1227.60*glc.MHZ_TO_HZ;
glc.FREQ_GPS_L5   =1176.45*glc.MHZ_TO_HZ;
glc.FREQ_GLO_G1   =1602.00*glc.MHZ_TO_HZ;
glc.FREQ_GLO_G2   =1246.00*glc.MHZ_TO_HZ;
glc.FREQ_GLO_G3   =1202.025*glc.MHZ_TO_HZ;
glc.FREQ_GLO_D1   =0.5625*glc.MHZ_TO_HZ;
glc.FREQ_GLO_D2   =0.4375*glc.MHZ_TO_HZ;
glc.FREQ_GAL_E1   =1575.42*glc.MHZ_TO_HZ;
glc.FREQ_GAL_E5A  =1176.45*glc.MHZ_TO_HZ;
glc.FREQ_GAL_E5B  =1207.140*glc.MHZ_TO_HZ;
glc.FREQ_GAL_E5AB =1191.795*glc.MHZ_TO_HZ;
glc.FREQ_GAL_E6   =1278.75*glc.MHZ_TO_HZ;
glc.FREQ_BDS_B1   =1561.098*glc.MHZ_TO_HZ;
glc.FREQ_BDS_B2   =1207.140*glc.MHZ_TO_HZ;
glc.FREQ_BDS_B3   =1268.52*glc.MHZ_TO_HZ;
glc.FREQ_BDS_B1C  =1575.42*glc.MHZ_TO_HZ;
glc.FREQ_BDS_B2A  =1176.45*glc.MHZ_TO_HZ;
glc.FREQ_BDS_B2B  =1207.140*glc.MHZ_TO_HZ;
glc.FREQ_QZS_L1   =1575.42*glc.MHZ_TO_HZ;
glc.FREQ_QZS_L2   =1227.60*glc.MHZ_TO_HZ;
glc.FREQ_QZS_L5   =1176.45*glc.MHZ_TO_HZ;
glc.FREQ_QZS_L6   =1278.75*glc.MHZ_TO_HZ;
    
%%
glc.CODE_NONE=0;
glc.CODE_L1C=1;
glc.CODE_L1S=2;
glc.CODE_L1L=3;
glc.CODE_L1X=4;
glc.CODE_L1P=5;
glc.CODE_L1W=6;
glc.CODE_L1Y=7;
glc.CODE_L1M=8;
glc.CODE_L1A=9;
glc.CODE_L1B=10;
glc.CODE_L1Z=11;
glc.CODE_L1D=12;
glc.CODE_L2C=13;
glc.CODE_L2D=14;
glc.CODE_L2S=15;
glc.CODE_L2L=16;
glc.CODE_L2X=17;
glc.CODE_L2P=18;
glc.CODE_L2W=19;
glc.CODE_L2Y=20;
glc.CODE_L2M=21;
glc.CODE_L2I=22;
glc.CODE_L2Q=23;
glc.CODE_L3I=24;
glc.CODE_L3Q=25;
glc.CODE_L3X=26;
glc.CODE_L4A=27;
glc.CODE_L4B=28;
glc.CODE_L4X=29;
glc.CODE_L5I=30;
glc.CODE_L5Q=31;
glc.CODE_L5X=32;
glc.CODE_L5D=33;
glc.CODE_L5P=34;
glc.CODE_L5Z=35;
glc.CODE_L6A=36;
glc.CODE_L6B=37;
glc.CODE_L6X=38;
glc.CODE_L6C=39;
glc.CODE_L6Z=40;
glc.CODE_L6S=41;
glc.CODE_L6L=42;
glc.CODE_L6E=43;
glc.CODE_L6I=44;
glc.CODE_L6Q=45;
glc.CODE_L7I=46;
glc.CODE_L7Q=47;
glc.CODE_L7X=48;
glc.CODE_L7D=49;
glc.CODE_L7P=50;
glc.CODE_L7Z=51;
glc.CODE_L8I=52;
glc.CODE_L8Q=53;
glc.CODE_L8X=54;
glc.CODE_L8D=55;
glc.CODE_L8P=56;
glc.CODE_L8Z=57;
glc.MAXCODE=57;

glc.obscodes={'', '1C','1S','1L','1X','1P','1W','1Y','1M','1A',...
             '1B','1Z','1D','2C','2D','2S','2L','2X','2P','2W',...
             '2Y','2M','2I','2Q','3I','3Q','3X','4A','4B','4X',...
             '5I','5Q','5X','5D','5P','5Z','6A','6B','6X','6C',...
             '6Z','6S','6L','6E','6I','6Q','7I','7Q','7X','7D',...
             '7P','7Z','8I','8Q','8X','8D','8P','8Z', '' , ''};       
         
% GPS L1(1),L2(2),L5(5)
glc.GPSfreqband=[0, 1, 1, 1, 1, 1, 1, 1, 1, 0,...
                 0, 0, 0, 2, 2, 2, 2, 2, 2, 2,...
                 2, 2, 0, 0, 0, 0, 0, 0, 0, 0,...
                 3, 3, 3, 0, 0, 0, 0, 0, 0, 0,...
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
% GLO G1(1) G2(2) G3(3) G1a(4) G2a(6)
glc.GLOfreqband=[0, 1, 0, 0, 0, 1, 0, 0, 0, 0,...
                 0, 0, 0, 2, 0, 0, 0, 0, 2, 0,...
                 0, 0, 0, 0, 3, 3, 3, 4, 4, 4,...
                 0, 0, 0, 0, 0, 0, 5, 5, 5, 0,...
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
%GAL E1(1) E5a(5) E5b(7) E5ab(8) E6(6)
glc.GALfreqband=[0, 1, 0, 0, 1, 0, 0, 0, 0, 1,...
                 1, 1, 0, 0, 0, 0, 0, 0, 0, 0,...
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
                 2, 2, 2, 0, 0, 0, 5, 5, 5, 5,...
                 5, 0, 0, 0, 0, 0, 3, 3, 3, 0,...
                 0, 0, 4, 4, 4, 0, 0, 0, 0, 0];
%BDS B1(2),B2(7),B3(6),B1C(1),B2a(5),B2b(7)
glc.BDSfreqband=[0, 0, 0, 0, 4, 4, 0, 0, 0, 4,...
                 0, 0, 4, 0, 0, 0, 0, 1, 0, 0,...
                 0, 0, 1, 1, 0, 0, 0, 0, 0, 0,...
                 0, 0, 5, 5, 5, 0, 3, 0, 3, 0,...
                 0, 0, 0, 0, 3, 3, 2, 2, 2, 6,...
                 6, 6, 0, 0, 0, 0, 0, 0, 0, 0];
%QZS L1(1) L2(2) L5(5) L6(6)
glc.QZSfreqband=[0, 1, 1, 1, 1, 0, 0, 0, 0, 0,...
                 0, 1, 0, 0, 0, 2, 2, 2, 0, 0,...
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,...
                 3, 3, 3, 3, 3, 0, 0, 0, 4, 0,...
                 4, 4, 4, 4, 0, 0, 0, 0, 0, 0,...
                 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

glc.codepris={'CWPYMNSL', 'CWPYMNDSLX',   'IQX'   ,    ''     ,    ''     , ''   ;
              'CP'      , 'CP'        ,   'IQX'   ,    'ABX'  ,    'ABXP' , ''   ;
              'CABXZ'   , 'IQX'       ,   'IQX'   ,    'IQX'  ,    'CABXZ', ''   ;
              'IQX'     , 'IQXA'      ,   'IQX'   ,    'DPXA' ,    'DPX'  , 'DPZ';
              'CSLXZ'   , 'SLX'       ,   'IQXDPZ',    'SLXEZ',    ''     , ''   };

%%
glc.GPS_C1CC2W=1;
glc.GPS_C1CC5Q=2;
glc.GPS_C1CC5X=3;
glc.GPS_C1WC2W=4;
glc.GPS_C1CC1W=5;
glc.GPS_C2CC2W=6;
glc.GPS_C2WC2S=7;
glc.GPS_C2WC2L=8;
glc.GPS_C2WC2X=9;

glc.GLO_C1CC2C=1;
glc.GLO_C1CC2P=2;
glc.GLO_C1PC2P=3;
glc.GLO_C1CC1P=4;
glc.GLO_C2CC2P=5;

glc.GAL_C1CC5Q=1;
glc.GAL_C1CC6C=2;
glc.GAL_C1CC7Q=3;
glc.GAL_C1CC8Q=4;
glc.GAL_C1XC5X=5;
glc.GAL_C1XC7X=6;
glc.GAL_C1XC8X=7;

glc.BD2_C2IC7I=1;
glc.BD2_C2IC6I=2;
glc.BD3_C1XC5X=3;
glc.BD3_C1PC5P=4;
glc.BD3_C1DC5D=5;
glc.BD3_C1XC6I=6;
glc.BD3_C1PC6I=7;
glc.BD3_C1DC6I=8;
glc.BD3_C2IC6I=9;
glc.BD3_C1XC7Z=10;
glc.BD3_C1XC8X=11;

glc.QZS_C1CC2L=1;
glc.QZS_C1CC5X=2;
glc.QZS_C1CC5Q=3;
glc.QZS_C1XC2X=4;
glc.QZS_C1XC5X=5;
glc.QZS_C1CC1X=6;

glc.MAXDCBPAIR=12;

glc.DCBPAIR={'C1C-C2W', 'C1C-C5Q', 'C1C-C5X', 'C1W-C2W', 'C1C-C1W', 'C2C-C2W', 'C2W-C2S', 'C2W-C2L', 'C2W-C2X', '', '', '';
             'C1C-C2C', 'C1C-C2P', 'C1P-C2P', 'C1C-C1P', 'C2C-C2P', '', '', '', '', '', '', '';
             'C1C-C5Q', 'C1C-C6C', 'C1C-C7Q', 'C1C-C8Q', 'C1X-C5X', 'C1X-C7X', 'C1X-C8X', '', '', '', '', '';
             'C2I-C7I', 'C2I-C6I', 'C1X-C5X', 'C1P-C5P', 'C1D-C5D', 'C1X-C6I', 'C1P-C6I', 'C1D-C6I', 'C2I-C6I', 'C1X-C7Z', 'C1X-C8X', '';
             'C1C-C2L', 'C1C-C5X', 'C1C-C5Q', 'C1X-C2X', 'C1X-C5X', 'C1C-C1X', '', '', '', '', '', ''};
      
%% struct time
gtime.time=0;
gtime.sec=0;
gls.gtime=gtime;
clearvars gtime

%% struct eph
eph.sat=0;
eph.iode=0;eph.iodc=0;
eph.sva=0;eph.svh=0;
eph.week=0;
eph.code=0;
eph.flag=0;
eph.toc=0;eph.toe=0;eph.ttr=0;
eph.A=0;eph.e=0;eph.i0=0;eph.OMG0=0;eph.omg=0;eph.M0=0;eph.deln=0;eph.OMGd=0;eph.idot=0;
eph.crc=0;eph.crs=0;eph.cuc=0;eph.cus=0;eph.cic=0;eph.cis=0;
eph.toes=0;
eph.fit=0;
eph.f0=0;eph.f1=0;eph.f2=0;
eph.tgd(1:4)=0; % GPS/QZS:tgd(1) P1/P2 GAL:tgd(1) E5a/E1 tgd(2) E5b/E1 
                % BDS:tgd(1) B1/B3 tgd(2) B2/B3 
eph.Adot=0;eph.ndot=0;
gls.eph=eph;
clearvars eph

%% struct geph
geph.sat=0;
geph.iode=0;
geph.frq=0;
geph.svh=0; geph.sva=0; geph.age=0;
geph.toe=0;
geph.tof=0;
geph.pos=zeros(3,1);
geph.vel=zeros(3,1);
geph.acc=zeros(3,1);
geph.taun=0; geph.gamn=0; 
geph.dtaun=0;
gls.geph=geph;
clearvars geph

%% struct precise eph
peph.time=gls.gtime;
peph.pos=zeros(glc.MAXSAT,4);
peph.std=zeros(glc.MAXSAT,4);
peph.vel=zeros(glc.MAXSAT,4);
peph.vst=zeros(glc.MAXSAT,4);
peph.cov=zeros(glc.MAXSAT,3);
peph.vco=zeros(glc.MAXSAT,3);
gls.peph=peph;
clearvars peph

%% struct precise clk
pclk.time=gls.gtime;
pclk.clk=zeros(glc.MAXSAT,1);
pclk.std=zeros(glc.MAXSAT,1);
gls.pclk=pclk;
clearvars pclk

%% struct erpd
erpd.mjd=0;
erpd.xp=0; erpd.yp=0;
erpd.xpr=0; erpd.ypr=0;
erpd.ut1_utc=0;
erpd.lod=0;
gls.erpd=erpd;
clearvars erpd

%% struct erp
erp.n=0;
erp.nmax=0;
erp.data=gls.erpd;
gls.erp=erp;
clearvars erp

%%  struct pcv
pcv.sat=0;
pcv.type='';
pcv.code='';
pcv.ts=gls.gtime;
pcv.te=gls.gtime;
pcv.off=zeros(5*glc.NFREQ,3);
pcv.var=zeros(5*glc.NFREQ,80*20);
pcv.dazi=0;
pcv.zen1=0; pcv.zen2=0; pcv.dzen=0;
gls.pcv=pcv;
clearvars pcv

%% struct pcvs
pcvs.n=0;
% pcvs.pcv=gls.pcv;
gls.pcvs=pcvs;
clearvars pcvs

%% struct sv
sv.svh=-1;
sv.pos=zeros(3,1);
sv.vel=zeros(3,1);
sv.dts=0; sv.dtsd=0;
sv.vars=0;
gls.sv=sv;
clearvars sv

%% struct nav 
nav.n=0; nav.nmax=0;
nav.ng=0; nav.ngmax=0;
nav.np=0;
nav.nc=0;
nav.no_CODE_DCB=1;
nav.utc_gps=zeros(1,4);
nav.utc_glo=zeros(1,4);
nav.utc_gal=zeros(1,4);
nav.utc_bds=zeros(1,4);
nav.utc_qzs=zeros(1,4);
nav.ion_gps=zeros(1,8);
nav.ion_gal=zeros(1,4);
nav.ion_bds=zeros(1,8);
nav.ion_qzs=zeros(1,8);
nav.leaps=0;
nav.lam=zeros(glc.MAXSAT,glc.MAXFREQ);
nav.cbias=zeros(glc.MAXSAT,glc.MAXDCBPAIR);
nav.rbias=zeros(2,3);
nav.wlbias=zeros(glc.MAXSAT,1);
nav.glo_cpbias=zeros(4,1);
nav.glo_fcn=zeros(glc.MAXPRNGLO+1,1);
nav.ant_para.n=0;
nav.otlp=zeros(11,6,2);
nav.erp=gls.erp;
nav.pcvs=repmat(gls.pcv,glc.MAXSAT,1);
gls.nav=nav;
clearvars nav

%% struct sta
sta.name='';  
sta.maker='';
sta.recsno='';
sta.rectype='';
sta.recver='';
sta.antno='';
sta.antdes='';
sta.deltype=0; 
sta.pos=zeros(3,1);
sta.del=zeros(3,1);
gls.sta=sta;
clearvars sta

%% struct obs_tmp data
obs_tmp.time=gls.gtime;
obs_tmp.sat=0;
obs_tmp.P=zeros(glc.NFREQ,1);
obs_tmp.L=zeros(glc.NFREQ,1);
obs_tmp.D=zeros(glc.NFREQ,1);
obs_tmp.S=zeros(glc.NFREQ,1);
obs_tmp.LLI=zeros(glc.NFREQ,1);
obs_tmp.code=zeros(glc.NFREQ,1);
gls.obs_tmp=obs_tmp;
clearvars obs_tmp

%% struct obs data
obsd.time=gls.gtime;
obsd.sat=0;
obsd.P=zeros(glc.MAXFREQ,1);
obsd.L=zeros(glc.MAXFREQ,1);
obsd.D=zeros(glc.MAXFREQ,1);
obsd.S=zeros(glc.MAXFREQ,1);
obsd.LLI=zeros(glc.MAXFREQ,1);
obsd.code=zeros(glc.MAXFREQ,1);
gls.obsd=obsd;
clearvars obsd

%% struct obs
obs.n=0;
obs.nepoch=0;
obs.dt=0;
obs.idx=0;
% obs.sta=repmat(gls.sta,1,2);
% obs.data=gls.obsd;
gls.obs=obs;
clearvars obs

%% struct imud
imud.time=gls.gtime;
imud.dw=zeros(1,3);
imud.dv=zeros(1,3);
gls.imud=imud;
clearvars imud

%% struct imu
imu.n=0;
imu.idx=0;
gls.imu=imu;
clearvars imu

%% struct solution
sol.time = gls.gtime;%solution time
sol.stat = 0; %solution state
sol.ns   = 0; %number of valid satellite
sol.pos  = zeros(1,3); %position
sol.posP = zeros(1,6); %position variance/convariance
sol.dtr  = zeros(1,glc.NSYS); % reciever clock bias
sol.dtrd = 0;
sol.vel  = zeros(1,3); %velocity
sol.velP = zeros(1,6); %velocity variance/convariance
sol.ratio = 0;
sol.age  = 0;
sol.att  = zeros(1,3);
sol.attP = zeros(1,6);
gls.sol=sol;
clearvars sol

%% struct reference
ref.week=0;
ref.sow=0;
ref.pos=zeros(1,3);
ref.vel=zeros(1,3);
ref.att=zeros(1,3);
gls.ref=ref;
clearvars ref

%% struct reciever states
rcv.time=gls.gtime;
rcv.oldpos=zeros(1,3);
rcv.oldvel=zeros(1,3);
rcv.clkbias=0;
rcv.clkdrift=0;
gls.rcv=rcv;
clearvars rcv

%% struct satellite states 
sat.sys=0;
sat.vs=0;
sat.azel =zeros(1,2);  %azimuth and elevation
sat.resp =zeros(1,glc.NFREQ);
sat.resc =zeros(1,glc.NFREQ);
sat.vsat =zeros(1,glc.NFREQ); %valid satellite flag
sat.snr  =zeros(1,glc.NFREQ); %signal strengh
sat.fix  =zeros(1,glc.NFREQ); %ambiguity fix flag (1:fix,2:float,3:hold)
sat.slip =zeros(1,glc.NFREQ); %slip flag
sat.slipb=zeros(1,glc.NFREQ); %base slip flag
sat.half =zeros(1,glc.NFREQ); %half-cycle valid flag
sat.lock =zeros(1,glc.NFREQ); %lock counter of phase
sat.outc =zeros(1,glc.NFREQ); %obs outage counter of phase
sat.slipc=zeros(1,glc.NFREQ); %cycle slip counter 
sat.rejc =zeros(1,glc.NFREQ); %reject counter
sat.gf =0;  %geometry-free phase combination L1-L2
sat.gf2=0;  %geometry-free phase combination L1-L5
sat.mw =0;  %MW combination
sat.phw=0;  %phase windup (cycle)
sat.pt =repmat(gls.gtime,2,glc.NFREQ);
sat.ph =zeros(2,3);
gls.sat=sat;
clearvars sat

%% struct rtk control 
rtk.nx=0;    %number of float states
rtk.na=0;    %number of fixed states 
rtk.tt=0;    %time difference between current and previous (s) 
rtk.x=0;     %float states
rtk.P=0;     %float states covariance 
rtk.xa=0;    %fixed states(only include the desired solution)
rtk.Pa=0;    %fixed states covariance 
rtk.nfix=0;  %number of continuous fixes of ambiguity 
rtk.ambc=0;    %ambibuity control 
rtk.sol=gls.sol;   %solution 
rtk.oldsol=gls.sol;
rtk.rcv=gls.rcv;
rtk.sat=repmat(gls.sat,1,glc.MAXSAT);   %satellite status 
rtk.obs_rcr=zeros(32,4); %observation for receiver clock jump repair(noly for GPS)
rtk.clkjump=0; %receiver clock jump
gls.rtk=rtk;
clearvars rtk

%% struct input file
default_file.path=''; %input file path
default_file.obsr=''; %rover observation file
default_file.obsb=''; %base station observation file
default_file.beph=''; %broadcast ephemeris file
default_file.sp3 =''; %precise ephemeris file
default_file.clk =''; %precise clock file
default_file.atx =''; %antenna file
default_file.dcb ={'','',''}; %DCB file
default_file.dcb_mgex =''; %DCB for MGEX
default_file.erp =''; %earth rotation parameters file
default_file.blq =''; %ocean tide loading parameters file
default_file.imu =''; %imu file
gls.default_file =default_file;
clearvars default_file


%% struct processing options
default_opt.ver='GINav v0.1.0';
default_opt.ts=glc.OPT_TS; % the start time(set default,using glc.OPT_TS)
default_opt.te=glc.OPT_TE; % the end time(set default,using glc.OPT_TE)
default_opt.ti=0;          % the time interval

default_opt.mode      = 1;         % positioning mode(1:SPP 2:PPD(post-processing differenced) 3:PPK 4:relative static 5:PPP_KINE 6:PPP_STATIC)
default_opt.navsys    = 'G';       % navigation system(G:GPS R:GLONASS E:GALILEO C:BDS J:QZSS)
default_opt.nf        = 1;         % number of frequencies (1:L1,2:L1+L2,3:L1+L2+L3)
default_opt.elmin     = 10*glc.D2R; % elevation mask angle(rad)
default_opt.snrmask   = 36;        % SNR mask
default_opt.sateph    = 1; % satellite ephemeris/clock (1:broadcast ephemeris,2:precise ephemeris)
default_opt.ionoopt   = 1; % ionosphere option  (0:off,1:broadcast model,2:L1/L2 iono-free LC,3:estimation)
default_opt.tropopt   = 1; % troposphere option (0:off 1:Saastamoinen model,2:ZTD estimation,3:ZTD+grid)
default_opt.dynamics  = 0; % dynamics model (0:off,1:on)
default_opt.tidecorr  = 0; % earth tide correction (0:off,1:on)

default_opt.modear    = 0; % AR mode (0:off,1:continuous,2:instantaneous,3:fix and hold 4:ppp_ar)
default_opt.glomodear = 0; % GLONASS AR mode (0:off 1:on 2:auto cal)
default_opt.bdsmodear = 0; % BDS AR mode (0:off 1:on)
default_opt.elmaskar   = 0;           % elevation mask of AR(rad)
default_opt.elmaskhold = 0;           % elevation mask to hold ambiguity(rad)
default_opt.LAMBDAtype = 1;           % LAMBDA algrithm (1:all AR 2:partial AR)
default_opt.thresar    = [3.0,0.995]; % AR threshold ([1]ratio test of all AR [2]success rate threshold of partial AR)

default_opt.bd2frq    = [1 3 2]; % specified the used frequency order for BDS-2 ([1]B1 [2]B2 [3]B3)
default_opt.bd3frq    = [1 3 4]; % specified the used frequency order for BDS-3 ([1]B1 [3]B3 [4]B1C [5]B2a [6]B2b)
default_opt.gloicb    = 0; % GLONASS inter-frequency code bias (0:off 1:linear 2:quadratic)
default_opt.gnsproac = 1; % GNSS precise product AC (1:wum 2:gbm 3:com 4:grm)
default_opt.posopt    = [0,0,0,0,0,0,0];   % positioning options (0:off 1:on)
                                   % ([1]satellite PCV [2]receiver PCV 
                                   % [3]phase wind up [4]reject GPS Block IIA 
                                   % [5]RAIM FDE [6]handle day-boundary clock jump
                                   % [7]gravitational delay correct)

default_opt.maxout  = 3; % obs outage count to reset ambiguity
default_opt.minlock = 5; % min lock count to fix ambiguity
default_opt.minfix  = 5; % min fix count to hold ambiguity
default_opt.niter   = 1; % number of filter iteration(only for relative positioning)

default_opt.maxinno = 30.0;        % reject threshold of innovation(m)
default_opt.maxgdop = 30.0;        % reject threshold of gdop
default_opt.csthres = [0.05,0.15,2]; % reject threshold of cycle slip detection([1]GF(m) [2]MW(m) [3]Doppler Integration(cycle))


default_opt.prn      = [1e-4,1E-3,1E-4,1E-1,1E-2,0]; % process-noise std([1]bias,[2]iono [3]trop [4]acch [5]accv [6] pos)
default_opt.std      = [30,0.03,0.3];             % initial-state std([1]bias,[2]iono [3]trop)
default_opt.sclkstab = 5e-12;                     % satellite clock stability (sec/sec)
default_opt.eratio   = [100,100,100];             % code/phase error ratio ([1]freq1 [2]freq2 [3]freq3)
default_opt.err      = [100,0.003,0.003,0,1];     % measurement error factor([1]:reserved [2-4]:error factor a/b/c of phase (m)
                                                 % [5]:doppler frequency(hz))
                                                 
default_opt.anttype = {'*','*'};       % anttenna type ([1]rover [2]base station //automatic matching using wildcard "*")
default_opt.antdelsrc = 0;  % the source of antenna delta (0:from obs 1:from opt)
default_opt.antdel  = [0 0 0;0 0 0];  % antenna delta (ENU in m)([1]rover [2]base station //not using wildcard "*")
default_opt.basepostype = 1;  % obtain the base station position(1:pos in options 2:average of SPP 3:rinex header)
default_opt.basepos     = [0;0;0]; % base station position

default_opt.ins.mode = 0;          % solution mode(0:off 1:LC 2:TC)
default_opt.ins.aid = [0 0];       % ins aid gnss(0:off 1:on)([1]ins-aid cycle slip detection [2]ins-aid robust estimation)
default_opt.ins.data_format = 0;   % imu data format (0:rate 1:increment)
default_opt.ins.sample_rate = 100; % imu sample rate(Hz)
default_opt.ins.lever       = [0 0 0];   % lever
default_opt.ins.init_att_unc = [1 1 3]*glc.D2R; %[pitch roll yaw](in rad);
default_opt.ins.init_vel_unc = [10 10 10]; %[e n u](in m/s)
default_opt.ins.init_pos_unc = [30 30 30]; %[B L H](in m)
default_opt.ins.init_bg_unc = 0;   %(deg/h--->rad/s)     
default_opt.ins.init_ba_unc = 0; %(ug   --->m/s^2)
default_opt.ins.psd_gyro = 0;  % gyro noise PSD (deg/sqrt(h)--->rad^2/s) 
default_opt.ins.psd_acce = 0;    % acce noise PSD (ug/sqrt(Hz)--->m^2/s^3)  
default_opt.ins.psd_bg   = 0;     % gyro bias random walk PSD (deg/h--->rad^2/s^3)
default_opt.ins.psd_ba   = 0;      % acce bias random walk PSD (ug   --->m^2/s^5)

default_opt.sol.timef = 1;
default_opt.sol.posf  = 1;
default_opt.sol.outvel  = 0;
default_opt.sol.outatt  = 0;

gls.default_opt=default_opt;
clearvars default_opt

