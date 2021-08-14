function var=varerr_spp(opt,el,sys)

global glc

if sys==glc.SYS_GLO
    fact=glc.EFACT_GLO;
else
    fact=glc.EFACT_GPS;
end
varr=opt.err(1)^2*(opt.err(2)^2+opt.err(3)^2/sin(el));
if opt.ionoopt==glc.IONOOPT_IFLC,varr=3^2*varr;end
var=fact^2*varr;

return