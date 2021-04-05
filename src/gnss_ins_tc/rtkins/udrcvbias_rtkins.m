function rtk=udrcvbias_rtkins(rtk,tt)

global glc;
VAR_HWBIAS=1^2; PRN_HWBIAS=1e-6;   

for i=1:glc.NFREQGLO
    j=rtk.il+i;
    
    if rtk.x(j)==0
        rtk=initx(rtk,1e-6,VAR_HWBIAS,j);
    elseif rtk.nfix>=rtk.opt.minfix&&rtk.sol.ratio>rtk.opt.thresar(1)
        rtk=initx(rtk,rtk.xa(j),rtk.Pa(j,j),j);
    else
        rtk.P(j,j)=rtk.P(j,j)+PRN_HWBIAS^2*abs(tt);
    end
    
end

return