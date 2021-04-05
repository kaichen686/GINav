function [trop_err,trop_var]=trop_cor(opt,time,nav,pos,azel) %#ok

global glc
ERR_TROP=3.0;

if opt==glc.TROPOPT_OFF
    trop_err=0;
    trop_var=ERR_TROP^2;
elseif opt==glc.TROPOPT_SAAS %Saastamoinen model
    trop_err=trop_saa(pos,azel,0.7); %humi=0.7
    trop_var=(0.3./(sin(azel(2))+0.1)).^2;
else
    error('SPP not surpport this tropspheric correction option!!!');
end

return

