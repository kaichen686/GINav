function var_r=varerr_ppp(sys,el,freq,type,opt)

global glc
fact=1; sinel=sin(el); EFACT_GPS_L5=10.0;

if freq==0,kk=1;else,kk=2;end
if type==1,fact=fact*opt.eratio(kk);end

if sys==glc.SYS_GLO,fact=fact*glc.EFACT_GLO;
else               ,fact=fact*glc.EFACT_GPS;
end

if sys==glc.SYS_GPS||sys==glc.SYS_QZS
    if freq==2,fact=fact*EFACT_GPS_L5;end
end

if opt.ionoopt==glc.IONOOPT_IFLC
    fact=3*fact;
end

var_r=(fact*opt.err(2))^2+(fact*opt.err(2)/sinel)^2;

return

