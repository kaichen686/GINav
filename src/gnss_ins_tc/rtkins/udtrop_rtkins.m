function rtk=udtrop_rtkins(rtk,tt,bl) %#ok

global glc
INIT_ZWD=0.15; VAR_GRA=0.001^2;

for i=1:2
    if i==1,j=rtk.itr+1;else,j=rtk.itb+1;end
    
    if rtk.x(j)==0
        rtk=initx(rtk,INIT_ZWD,rtk.opt.std(3)^2,j);
        if rtk.opt.tropopt==glc.TROPOPT_ESTG
            for k=1:2
                rtk=initx(rtk,1e-6,VAR_GRA,j+k);
            end
        end
    else
        rtk.P(j,j)=rtk.P(j,j)+rtk.opt.prn(3)^2*abs(tt);
        if rtk.opt.tropopt==glc.TROPOPT_ESTG
            for k=1:2
                rtk.P(j+k,j+k)=rtk.P(j+k,j+k)+(rtk.opt.prn(3)*0.3)^2*abs(tt);
            end
        end
    end
    
end

return

