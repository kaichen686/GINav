function var=varerr_rel(sat,sys,el,bl,dt,f,rtk) %#ok

global glc
opt=rtk.opt;
c=opt.err(4)*bl/1e4; d=glc.CLIGHT*opt.sclkstab*dt;fact=1;
nf=rtk.NF; sinel=sin(el);

if f>nf,fact=opt.eratio(f-nf);end
if fact<=0,fact=opt.eratio(1);end
if sys==glc.SYS_GLO
    fact=fact*glc.EFACT_GLO;
else
    fact=fact*glc.EFACT_GPS;
end

a=fact*opt.err(2);
b=fact*opt.err(3);
if opt.ionoopt==glc.IONOOPT_IFLC,k=3;else,k=1;end
var=2*k*(a^2+b^2/sinel^2+c^2)+d^2;

return 