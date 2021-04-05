function rtk=udtrop_ppp(rtk)

global glc
VAR_GRA=0.01^2; azel=[0,pi/2];

if rtk.x(rtk.it+1)==0
    pos=ecef2pos(rtk.sol.pos);
    [ztd,var]=trop_mops(rtk.sol.time,pos,azel); %ztd:zenith tropsphere delay
    rtk=initx(rtk,ztd,var,rtk.it+1);
    if rtk.opt.tropopt==glc.TROPOPT_ESTG
        rtk=initx(rtk,1e-6,VAR_GRA,rtk.it+2);
        rtk=initx(rtk,1e-6,VAR_GRA,rtk.it+3);
    end
else
    rtk.P(rtk.it+1,rtk.it+1)=rtk.P(rtk.it+1,rtk.it+1)+rtk.opt.prn(3)^2*abs(rtk.tt);
    if rtk.opt.tropopt==glc.TROPOPT_ESTG
        rtk.P(rtk.it+2,rtk.it+2)=rtk.P(rtk.it+2,rtk.it+2)+(rtk.opt.prn(3)*0.1)^2*abs(rtk.tt);
        rtk.P(rtk.it+3,rtk.it+3)=rtk.P(rtk.it+3,rtk.it+3)+(rtk.opt.prn(3)*0.1)^2*abs(rtk.tt);
    end
end

return