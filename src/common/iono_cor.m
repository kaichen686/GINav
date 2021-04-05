function [iono_err,iono_var]=iono_cor(opt,time,nav,sat,pos,azel)  %#ok

global glc
ERR_ION=5.0;

if opt==glc.IONOOPT_OFF
    iono_err=0;
    iono_var=ERR_ION^2;
elseif opt==glc.IONOOPT_BRDC  %broadcast ionosphere parameter+klobuchar model
    iono_err=iono_klbc(time,pos,azel,nav.ion_gps);
    iono_var=(0.5*iono_err).^2;
else
    error('SPP not surpport this ionospheric correction option!!!');
end

return