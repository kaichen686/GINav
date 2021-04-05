function rtk=udclk_pppins(rtk)

global glc
opt=rtk.opt;  tt=abs(rtk.tt);
VAR_CLK=60^2; VAR_CLK_D=10^2;
CLK_UNC=0.01; CLK_D_UNC=0.04;
navsys=opt.navsys; mask=rtk.mask; isb_prn=0; %#ok

Phi=eye(6); Phi(1,6)=abs(rtk.tt);
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

if opt.gloicb==glc.GLOICB_LNF
    if rtk.x(rtk.iicb+1)==0
        rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+1);
    end
elseif opt.gloicb==glc.GLOICB_QUAD
    if rtk.x(rtk.iicb+1)==0
        rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+1);
    end
    if rtk.x(rtk.iicb+2)==0
        rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+2);
    end
end

% % for single-system except GPS
% if strcmp(navsys,'R')
%     if rtk.x(rtk.ic+2)==0
%         dtr=rtk.rclk(2)*glc.CLIGHT;
%         rtk=initx(rtk,dtr,VAR_CLK,rtk.ic+2);
%         rtk=initx(rtk,1e-6,VAR_CLK_D,rtk.ic+6);
%     else
%         rtk.x(rtk.ic+2)=rtk.x(rtk.ic+2)+rtk.x(rtk.ic+6)*tt;
%         rtk.P(rtk.ic+2,rtk.ic+2)=rtk.P(rtk.ic+2,rtk.ic+2)+CLK_UNC^2*tt;
%         rtk.P(rtk.ic+6,rtk.ic+6)=rtk.P(rtk.ic+6,rtk.ic+6)+CLK_D_UNC^2*tt;
%     end
%   
%     % for GLONASS icb
%     if opt.gloicb==glc.GLOICB_LNF
%         if rtk.x(rtk.iicb+1)==0
%             rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+1);
%         end
%     elseif opt.gloicb==glc.GLOICB_QUAD
%         if rtk.x(rtk.iicb+1)==0
%             rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+1);
%         end
%         if rtk.x(rtk.iicb+2)==0
%             rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+2);
%         end
%     end
%     return
% elseif strcmp(navsys,'E')
%     if rtk.x(rtk.ic+3)==0
%         dtr=rtk.rclk(3)*glc.CLIGHT;
%         rtk=initx(rtk,dtr,VAR_CLK,rtk.ic+3);
%         rtk=initx(rtk,1e-6,VAR_CLK_D,rtk.ic+6);
%     else
%         rtk.x(rtk.ic+3)=rtk.x(rtk.ic+3)+rtk.x(rtk.ic+6)*tt;
%         rtk.P(rtk.ic+3,rtk.ic+3)=rtk.P(rtk.ic+3,rtk.ic+3)+CLK_UNC^2*tt;
%         rtk.P(rtk.ic+6,rtk.ic+6)=rtk.P(rtk.ic+6,rtk.ic+6)+CLK_D_UNC^2*tt;
%     end
%     return
% elseif strcmp(navsys,'C')
%     if rtk.x(rtk.ic+4)==0
%         dtr=rtk.rclk(4)*glc.CLIGHT;
%         rtk=initx(rtk,dtr,VAR_CLK,rtk.ic+4);
%         rtk=initx(rtk,1e-6,VAR_CLK_D,rtk.ic+6);
%     else
%         rtk.x(rtk.ic+4)=rtk.x(rtk.ic+4)+rtk.x(rtk.ic+6)*tt;
%         rtk.P(rtk.ic+4,rtk.ic+4)=rtk.P(rtk.ic+4,rtk.ic+4)+CLK_UNC^2*tt;
%         rtk.P(rtk.ic+6,rtk.ic+6)=rtk.P(rtk.ic+6,rtk.ic+6)+CLK_D_UNC^2*tt;
%     end
%     return
% elseif strcmp(navsys,'J')
%     if rtk.x(rtk.ic+5)==0
%         dtr=rtk.rclk(5)*glc.CLIGHT;
%         rtk=initx(rtk,dtr,VAR_CLK,rtk.ic+5);
%         rtk=initx(rtk,1e-6,VAR_CLK_D,rtk.ic+6);
%     else
%         rtk.x(rtk.ic+5)=rtk.x(rtk.ic+5)+rtk.x(rtk.ic+6)*tt;
%         rtk.P(rtk.ic+5,rtk.ic+5)=rtk.P(rtk.ic+5,rtk.ic+5)+CLK_UNC^2*tt;
%         rtk.P(rtk.ic+6,rtk.ic+6)=rtk.P(rtk.ic+6,rtk.ic+6)+CLK_D_UNC^2*tt;
%     end
%     return
% end
% 
% % for GPS or multi-system
% if rtk.x(rtk.ic+1)==0
%     dtr=rtk.rclk(1)*glc.CLIGHT;
%     rtk=initx(rtk,dtr,VAR_CLK,rtk.ic+1);
%     rtk=initx(rtk,1e-6,VAR_CLK_D,rtk.ic+6);
% else
%     rtk.x(rtk.ic+1)=rtk.x(rtk.ic+1)+rtk.x(rtk.ic+6)*tt;
%     rtk.P(rtk.ic+1,rtk.ic+1)=rtk.P(rtk.ic+1,rtk.ic+1)+CLK_UNC^2*tt;
%     rtk.P(rtk.ic+6,rtk.ic+6)=rtk.P(rtk.ic+6,rtk.ic+6)+CLK_D_UNC^2*tt;
% end
% 
% for i=2:glc.NSYS
%     if mask(i)==0,continue;end
%     if i==glc.SYS_GLO
%         if rtk.x(rtk.ic+2)==0
%             dtr=rtk.rclk(2)*glc.CLIGHT;
%             rtk=initx(rtk,CLIGHT*dtr,VAR_CLK,rtk.ic+2);
%         else
%             rtk.P(rtk.ic+i,rtk.ic+i)=rtk.P(rtk.ic+i,rtk.ic+i)+isb_prn^2*tt;
%         end
%         % for GLONASS icb
%         if opt.gloicb==glc.GLOICB_LNF
%             if rtk.x(rtk.iicb+1)==0
%                 rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+1);
%             end
%         elseif opt.gloicb==glc.GLOICB_QUAD
%             if rtk.x(rtk.iicb+1)==0
%                 rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+1);
%             end
%             if rtk.x(rtk.iicb+2)==0
%                 rtk=initx(rtk,0.1,VAR_CLK,rtk.iicb+2);
%             end
%         end
%     else
%         if rtk.x(rtk.ic+i)==0
%             dtr=rtk.rclk(i)*glc.CLIGHT;
%             if abs(dtr)<=1e-16,dtr=1e-16;end
%             rtk=initx(rtk,CLIGHT*dtr,VAR_CLK,rtk.ic+i);
%         else
%             rtk.P(rtk.ic+i,rtk.ic+i)=rtk.P(rtk.ic+i,rtk.ic+i)+isb_prn^2*tt;
%         end
%     end 
% end

return

