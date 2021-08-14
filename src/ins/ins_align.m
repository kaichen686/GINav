function [rtk,ins_align_flag]=ins_align(rtk,obsr_,obsb_,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
ins_align_flag=0;

if norm(rtk.sol.pos)~=0
    [vel,ins_align_flag]=tdcp2vel(rtk,nav,obsr_,rtk.oldobsr);
end

[rtk,~]=gnss_solver(rtk,obsr_,obsb_,nav);

rtk.oldobsr=obsr_;

if rtk.sol.stat~=glc.SOLQ_NONE&&ins_align_flag==1
    % initialize ins
    pos=xyz2blh(rtk.sol.pos);
    yaw=vel2yaw(vel);
    att=[0 0 yaw];
    avp0=[att,vel,pos]';
    ins=ins_init(rtk.opt.ins,avp0);
    
    % correct lever arm for position and velocity
    ins.pos=ins.pos-ins.Mpv*ins.Cnb*ins.lever;
    ins.vel=ins.vel-ins.Cnb*askew(ins.web)*ins.lever;
    rtk.ins=ins;
else
    ins_align_flag=0;
end

return

