function [dcb,use_dcb_flag]=getdcb(nav,obs,opt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
use_dcb_flag=1;
dcb=zeros(glc.NFREQ,1); cbias=nav.cbias;
sat=obs.sat;
[sys,prn]=satsys(sat);
if sys==glc.SYS_NONE,return;end

if sys==glc.SYS_GPS
    DCB_p1p2=cbias(sat,glc.GPS_C1WC2W);
    a=glc.FREQ_GPS_L1^2-glc.FREQ_GPS_L2^2;
    alpha=glc.FREQ_GPS_L1^2/a;
    beta=-glc.FREQ_GPS_L2^2/a;
    if DCB_p1p2==0,use_dcb_flag=0;end 
    for i=1:glc.NFREQ
        if obs.code(i)==glc.CODE_NONE
            dcb(i)=0;continue;
        end
        if i==1 %L1
            dcb(i)=beta*DCB_p1p2;
            if obs.code(i)==glc.CODE_L1C
                dcb(i)=dcb(i)+cbias(sat,glc.GPS_C1CC1W);
            end
        elseif i==2 %L2
            dcb(i)=-alpha*DCB_p1p2;
            if obs.code(i)==glc.CODE_L2C
                dcb(i)=dcb(i)+cbias(sat,glc.GPS_C2CC2W);
            elseif obs.code(i)==glc.CODE_L2S
                dcb(i)=dcb(i)-cbias(sat,glc.GPS_C2WC2S);
            elseif obs.code(i)==glc.CODE_L2L
                dcb(i)=dcb(i)-cbias(sat,glc.GPS_C2WC2L);
            elseif obs.code(i)==glc.CODE_L2X
                dcb(i)=dcb(i)-cbias(sat,glc.GPS_C2WC2X);
            end
        elseif i==3 %L3
            DCB_p1p3=0;
            beta_13=-glc.FREQ_GPS_L5^2/(glc.FREQ_GPS_L1^2-glc.FREQ_GPS_L5^2);
            if obs.code(i)==glc.CODE_L5Q
                DCB_p1p3=cbias(sat,glc.GPS_C1CC5Q)-cbias(sat,glc.GPS_C1CC1W);
            elseif obs.code(i)==glc.CODE_L5X
                DCB_p1p3=cbias(sat,glc.GPS_C1CC5X)-cbias(sat,glc.GPS_C1CC1W);
            end
            dcb(i)=beta_13*DCB_p1p2-DCB_p1p3;
        end
    end
elseif sys==glc.SYS_GLO
    DCB_p1p2=cbias(sat,glc.GLO_C1PC2P);
    a=glc.FREQ_GLO_G1^2-glc.FREQ_GLO_G2^2;
    alpha=glc.FREQ_GLO_G1^2/a;
    beta=-glc.FREQ_GLO_G2^2/a;
    if DCB_p1p2==0,use_dcb_flag=0;end 
    for i=1:glc.NFREQ
        if obs.code(i)==glc.CODE_NONE
            dcb(i)=0;continue;
        end
        if i==1 %G1
            dcb(i)=beta*DCB_p1p2;
            if obs.code(i)==glc.CODE_L1C
                dcb(i)=dcb(i)+cbias(sat,glc.GLO_C1CC1P);
            end
        elseif i==2 %G2
            dcb(i)=-alpha*DCB_p1p2;
            if obs.code(i)==glc.CODE_L2C
                dcb(i)=dcb(i)+cbias(sat,glc.GLO_C2CC2P);
            end
        end
    end
elseif sys==glc.SYS_GAL
    DCB_p1p2=cbias(sat,glc.GAL_C1CC5Q);
    a=glc.FREQ_GAL_E1^2-glc.FREQ_GAL_E5A^2;
    alpha=glc.FREQ_GAL_E1^2/a;
    beta=-glc.FREQ_GAL_E5A^2/a;
    if DCB_p1p2==0,use_dcb_flag=0;end 
    for i=1:glc.NFREQ
        if obs.code(i)==glc.CODE_NONE
            dcb(i)=0;continue;
        end
        if i==1 %E1
            if obs.code(i)==glc.CODE_L1X
                DCB_p1p2=cbias(sat,glc.GAL_C1XC5X);
            end
            dcb(i)=beta*DCB_p1p2;
        elseif i==2 %E5A
            if obs.code(i)==glc.CODE_L5X
                DCB_p1p2=cbias(sat,glc.GAL_C1XC5X);
            end
            dcb(i)=-alpha*DCB_p1p2;
        elseif i==3 %E5B
            DCB_p1p3=0;
            beta_13=-glc.FREQ_GAL_E5B^2/(glc.FREQ_GAL_E1^2-glc.FREQ_GAL_E5B^2);
            if obs.code(i)==glc.CODE_L7X
                DCB_p1p2=cbias(sat,glc.GAL_C1XC5X);
                DCB_p1p3=cbias(sat,glc.GAL_C1XC7X);
            elseif obs.code(i)==glc.CODE_L7Q
                DCB_p1p3=cbias(sat,glc.GAL_C1CC7Q);
            end
            dcb(i)=beta_13*DCB_p1p2-DCB_p1p3;
        end
    end
elseif sys==glc.SYS_BDS
    if opt.sateph==glc.EPHOPT_BRDC %base on b3
        if prn>18 %BD3
            DCB_b1b3=cbias(sat,glc.BD3_C2IC6I);
            if DCB_b1b3==0,use_dcb_flag=0;end 
            for i=1:glc.NFREQ
                if obs.code(i)==glc.CODE_NONE
                    dcb(i)=0;continue;
                elseif obs.code(i)==glc.CODE_L2I %B1
                    dcb(i)=DCB_b1b3;
                elseif obs.code(i)==glc.CODE_L7I %B2
                    dcb(i)=0;
                elseif obs.code(i)==glc.CODE_L6I %B3
                    dcb(i)=0;
                elseif obs.code(i)==glc.CODE_L1X %B1C
                    dcb(i)=cbias(sat,glc.BD3_C1XC6I);
                elseif obs.code(i)==glc.CODE_L1P %B1C
                    dcb(i)=cbias(sat,glc.BD3_C1PC6I);
                elseif obs.code(i)==glc.CODE_L1D %B1C
                    dcb(i)=cbias(sat,glc.BD3_C1DC6I);
                elseif obs.code(i)==glc.CODE_L5X %B2a
                    dcb(i)=cbias(sat,glc.BD3_C1XC6I)-cbias(sat,glc.BD3_C1XC5X);
                elseif obs.code(i)==glc.CODE_L5P %B2a
                    dcb(i)=cbias(sat,glc.BD3_C1PC6I)-cbias(sat,glc.BD3_C1PC5P);
                elseif obs.code(i)==glc.CODE_L5D %B2a
                    dcb(i)=cbias(sat,glc.BD3_C1DC6I)-cbias(sat,glc.BD3_C1DC5D);
                end 
            end
        else %BD2
            bd2frq=opt.bd2frq;
            DCB_b1b2=cbias(sat,glc.BD2_C2IC7I);
            DCB_b1b3=cbias(sat,glc.BD2_C2IC6I);
            if DCB_b1b2==0||DCB_b1b3==0,use_dcb_flag=0;end 
            for i=1:glc.NFREQ
                if obs.code(i)==glc.CODE_NONE
                    dcb(i)=0;continue;
                end
                if bd2frq(i)==1
                    dcb(i)=DCB_b1b3;
                elseif bd2frq(i)==2
                    dcb(i)=DCB_b1b3-DCB_b1b2; %有点问题
                    %dcb(i)=0;
                elseif bd2frq(i)==3
                    dcb(i)=0;
                end
            end
        end
    elseif opt.sateph==glc.EPHOPT_PREC
       if opt.gnsproac==glc.AC_COM %base on b1b2, only for BD2
           bd2frq=opt.bd2frq;
           for i=1:glc.NFREQ
               if obs.code(i)==glc.CODE_NONE
                   dcb(i)=0;continue;
               end
               if prn>18 %BD3
                   dcb(i)=0;continue;
               end
               DCB_b1b2=cbias(sat,glc.BD2_C2IC7I);
               DCB_b1b3=cbias(sat,glc.BD2_C2IC6I);
               a=glc.FREQ_BDS_B1^2-glc.FREQ_BDS_B2^2;
               alpha=glc.FREQ_BDS_B1^2/a;
               beta=-glc.FREQ_BDS_B2^2/a;
               if bd2frq(i)==1
                   dcb(i)=beta*DCB_b1b2;
               elseif bd2frq(i)==2
                   dcb(i)=-alpha*DCB_b1b2;
               elseif bd2frq(i)==3
                   beta_13=-glc.FREQ_BDS_B3^2/(glc.FREQ_BDS_B1^2-glc.FREQ_BDS_B3^2);
                   dcb(i)=beta_13*DCB_b1b2-DCB_b1b3;
               end
           end
       elseif opt.gnsproac==glc.AC_WUM||opt.gnsproac==glc.AC_GBM %base on b1b3
           bd2frq=opt.bd2frq; bd3frq=opt.bd3frq;
           a=glc.FREQ_BDS_B1^2-glc.FREQ_BDS_B3^2;
           alpha=glc.FREQ_BDS_B1^2/a;
           beta=-glc.FREQ_BDS_B3^2/a;
           for i=1:glc.NFREQ
               if obs.code(i)==glc.CODE_NONE
                   dcb(i)=0;continue;
               end
               if prn>18 %BD3
                   DCB_b1b3=cbias(sat,glc.BD3_C2IC6I);
                   if bd3frq(i)==1
                       dcb(i)=beta*DCB_b1b3;
                   elseif bd3frq(i)==2
                       dcb(i)=0;
                   elseif bd3frq(i)==3
                       dcb(i)=-alpha*DCB_b1b3;
                   elseif bd3frq(i)==4 %B1C
                       beta_13=-glc.FREQ_BDS_B1C/(glc.FREQ_BDS_B1^2-glc.FREQ_BDS_B3^2); %有问�?
                       DCB_b1b2=0;
                       if obs.code(i)==glc.CODE_L1X
                           DCB_b1b2=cbias(sat,glc.BD3_C1XC6I);
                       elseif obs.code(i)==glc.CODE_L1P
                           DCB_b1b2=cbias(sat,glc.BD3_C1PC6I);
                       elseif obs.code(i)==glc.CODE_L1D
                           DCB_b1b2=cbias(sat,glc.BD3_C1DC6I);
                       end
                       DCB_tmp=DCB_b1b3-DCB_b1b2;
                       dcb(i)=beta_13*DCB_b1b3-DCB_tmp;
                   elseif bd3frq(i)==5 %B2a
                       beta_13=-glc.FREQ_BDS_B2A/(glc.FREQ_BDS_B1^2-glc.FREQ_BDS_B2A^2);
                       DCB_b1b2=0;
                       if obs.code(i)==glc.CODE_L5X
                           DCB_b1b2=cbias(sat,glc.BD3_C1XC6I)-cbias(sat,glc.BD3_C1XC5X);
                       elseif obs.code(i)==glc.CODE_L5P
                           DCB_b1b2=cbias(sat,glc.BD3_C1PC6I)-cbias(sat,glc.BD3_C1PC5P);
                       elseif obs.code(i)==glc.CODE_L5D
                           DCB_b1b2=cbias(sat,glc.BD3_C1DC6I)-cbias(sat,glc.BD3_C1DC5D);
                       end
                       DCB_tmp=DCB_b1b3-DCB_b1b2;
                       dcb(i)=beta_13*DCB_b1b3-DCB_tmp;
                   elseif bd3frq(i)==6 %B2b
                       dcb(i)=0;
                   end
               else %BD2
                   DCB_b1b2=cbias(sat,glc.BD2_C2IC7I);
                   DCB_b1b3=cbias(sat,glc.BD2_C2IC6I);
                   if bd2frq(i)==1
                       dcb(i)=beta*DCB_b1b3;
                   elseif bd2frq(i)==2
                       beta_13=-glc.FREQ_BDS_B2/(glc.FREQ_BDS_B1^2-glc.FREQ_BDS_B2^2);
                       dcb(i)=beta_13*DCB_b1b3-DCB_b1b2;
                   elseif bd2frq(i)==3
                       dcb(i)=-alpha*DCB_b1b3;
                   end
               end
           end
       end
    end
elseif sys==glc.SYS_QZS
    DCB_p1p2=cbias(sat,glc.QZS_C1CC2L);
    a=glc.FREQ_QZS_L1^2-glc.FREQ_QZS_L2^2;
    alpha=glc.FREQ_QZS_L1^2/a;
    beta=-glc.FREQ_QZS_L2^2/a;
    if DCB_p1p2==0,use_dcb_flag=0;end 
    for i=1:glc.NFREQ
        if obs.code(i)==glc.CODE_NONE
            dcb(i)=0;continue;
        end
        if i==1 %L1
            if obs.code(i)==glc.CODE_L1X
                DCB_p1p2=cbias(sat,glc.QZS_C1XC2X);
            end
            dcb(i)=beta*DCB_p1p2;
        elseif i==2 %L3
            if obs.code(i)==glc.CODE_L2X
                DCB_p1p2=cbias(sat,glc.QZS_C1XC2X);
            end
            dcb(i)=-alpha*DCB_p1p2;
        elseif i==3 %L5
            if obs.code(1)==glc.CODE_L1X
                DCB_p1p2=cbias(sat,glc.QZS_C1XC2X);
            end
            beta_13=-glc.FREQ_QZS_L5^2/(glc.FREQ_QZS_L1^2-glc.FREQ_QZS_L5^2); %有问题？？？
            DCB_p1p3=0;
            if obs.code(i)==glc.CODE_L5Q
                DCB_p1p3=cbias(sat,glc.QZS_C1CC5Q);
            elseif obs.code(i)==glc.CODE_L5X
                DCB_p1p3=cbias(sat,glc.QZS_C1CC5X);
            end
            dcb(i)=beta_13*DCB_p1p2-DCB_p1p3;
        end
    end
end

return

