function rtk_gi=udsol_lc(rtk_gi,rtk_gnss)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc

rtk_gi.sol.time=rtk_gnss.sol.time;
rtk_gi.sol.stat=rtk_gnss.sol.stat;
rtk_gi.sol.ns=rtk_gnss.sol.ns;

x=rtk_gi.ins.x; P=rtk_gi.ins.P;

[rr,Cen]=blh2xyz(x(7:9)); T=Dblh2Dxyz(x(7:9));
rtk_gi.sol.pos=rr';
rtk_gi.sol.vel=(Cen*x(4:6))';
rtk_gi.sol.att=x(1:3)'/glc.D2R;

if rtk_gi.sol.att(3)>=0
    rtk_gi.sol.att(3)=360-rtk_gi.sol.att(3);
else
    rtk_gi.sol.att(3)=-rtk_gi.sol.att(3);
end

posvar=P(7:9,7:9); posvar=T*posvar*T';        %blh_var to xyz_var
velvar=P(4:6,4:6); velvar=Cen*velvar*Cen';    %enu_var to xyz_var
attvar=P(1:3,1:3); attvar=attvar./glc.D2R^2;  %rad_var to deg_var

rtk_gi.sol.posP(1)=posvar(1,1);
rtk_gi.sol.posP(2)=posvar(2,2);
rtk_gi.sol.posP(3)=posvar(3,3);
rtk_gi.sol.posP(4)=posvar(1,2);
rtk_gi.sol.posP(5)=posvar(2,3);
rtk_gi.sol.posP(6)=posvar(1,3);

rtk_gi.sol.velP(1)=velvar(1,1);
rtk_gi.sol.velP(2)=velvar(2,2);
rtk_gi.sol.velP(3)=velvar(3,3);
rtk_gi.sol.velP(4)=velvar(1,2);
rtk_gi.sol.velP(5)=velvar(2,3);
rtk_gi.sol.velP(6)=velvar(1,3);

rtk_gi.sol.attP(1)=attvar(1,1);
rtk_gi.sol.attP(2)=attvar(2,2);
rtk_gi.sol.attP(3)=attvar(3,3);
rtk_gi.sol.attP(4)=attvar(1,2);
rtk_gi.sol.attP(5)=attvar(2,3);
rtk_gi.sol.attP(6)=attvar(1,3);

return

