function [diono,vari,stat]=model_iono(time,pos,azel,rtk,x,nav,sat)

global glc
stat=0; ERR_BRDCI=0.5; 

if rtk.opt.ionoopt==glc.IONOOPT_BRDC
    diono=iono_klbc(time,pos,azel,nav.ion_gps);
    vari=(diono*ERR_BRDCI)^2;
    stat=1; return;
end

if rtk.opt.ionoopt==glc.IONOOPT_IFLC
    diono=0;
    vari=0;
    stat=1;return;
end

if rtk.opt.ionoopt==glc.IONOOPT_EST
    diono=x(rtk.ii+sat);
    vari=0;
    stat=1;return;
end

return