function rtk=udclk_sppins(rtk)

global glc
opt=rtk.opt;  tt=abs(rtk.tt);
VAR_CLK=60^2; VAR_CLK_D=10^2;
CLK_UNC=0.01; CLK_D_UNC=0.04;
navsys=opt.navsys; mask=rtk.mask; isb_prn=0; %#ok

Phi=eye(6); Phi(1,6)=tt;
Q=zeros(6,6); Q(1,1)=CLK_UNC; Q(6,6)=CLK_D_UNC;

if rtk.x(rtk.ic+1)==0
    for i=1:glc.NSYS
        dtr=rtk.sol.dtr(i)*glc.CLIGHT;
        rtk=initx(rtk,dtr,VAR_CLK,rtk.ic+i);
    end
    rtk=initx(rtk,1e-6,VAR_CLK_D,rtk.ic+6);
else
    x=rtk.x(rtk.ic+1:rtk.ic+6);
    rtk.x(rtk.ic+1:rtk.ic+6)=Phi*x;
    P=rtk.P(rtk.ic+1:rtk.ic+6,rtk.ic+1:rtk.ic+6);
    rtk.P(rtk.ic+1:rtk.ic+6,rtk.ic+1:rtk.ic+6)=Phi*P*Phi'+Q*tt;
end

return