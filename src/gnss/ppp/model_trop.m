function [dtdx,dtrp,vart,stat]=model_trop(time,pos,azel,rtk,x,nav) %#ok

global glc;
stat=0;
trp=zeros(3,1); dtdx=zeros(3,1); ERR_SAAS=0.3;

if rtk.opt.tropopt==glc.TROPOPT_SAAS
    dtrp=trop_saa(pos,azel,0.7); %humi=0.7
    vart=ERR_SAAS^2;
    stat=1; return;
end

if rtk.opt.tropopt==glc.TROPOPT_EST||rtk.opt.tropopt==glc.TROPOPT_ESTG
    if rtk.opt.tropopt==glc.TROPOPT_EST,trp(1)=x(rtk.it+1);
    else,trp(1:3)=x(rtk.it+1:rtk.it+3);
    end
    [dtdx,dtrp,vart]=trop_model_prec(time,pos,azel,trp);
    stat=1;return; 
end

return

