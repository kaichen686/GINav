function ins=ins_mech(ins,imu)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INS mechanization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
persistent old_dw old_dv

ins.time=imu.time;
if isempty(old_dw)
    old_dw=zeros(3,1); 
end
if isempty(old_dv)
    old_dv=zeros(3,1); 
end

% correct bias and scaling factor errors
dw0 = imu.dw';
dv0 = imu.dv';
dw = ins.Kg*dw0-ins.bg*ins.nt;
dv = ins.Ka*dv0-ins.ba*ins.nt;

% extrapolate velocity and position
vel_mid = ins.vel+ins.acc*(ins.nt/2);                    
pos_mid = ins.pos+ins.Mpv*(ins.vel+vel_mid)/2*ins.nt;  

% update the related parameters
ins.eth = earth_update(pos_mid,vel_mid);  
ins.wib = dw/ins.nt;
ins.fb  = dv/ins.nt;
ins.fn  = ins.Cnb*ins.fb;
ins.web = ins.wib-ins.Cnb'*ins.eth.wnie;

% update velocity 
dv_rot  = 0.5*cross(dw0,dv0);
dv_scul = 1/12*(cross(old_dw,dv0)+cross(old_dv,dw0));
dv_sf   = (eye(3)-0.5*ins.nt*askew(ins.eth.wnin))*ins.Cnb*dv + ins.Cnb*(dv_rot+dv_scul);
dv_cor  = ins.eth.gcc*ins.nt;
vel_new = ins.vel+dv_sf+dv_cor;

% update position 
ins.Mpv(2) = ins.eth.Mpv2;
ins.Mpv(4) = ins.eth.Mpv4;
pos_new    = ins.pos + ins.Mpv*(ins.vel+vel_new)/2*ins.nt; 

% update attitude 
dw_cone  = 1/12*cross(old_dw,dw0);
phi_b_ib = dw+dw_cone;
phi_n_in = ins.eth.wnin*ins.nt;
Cbb = rvec2mat(phi_b_ib);
Cnn = rvec2mat(phi_n_in)';
Cnb_new = Cnn*ins.Cnb*Cbb;
att_new = Cnb2att(Cnb_new);

% update INS result
ins.Cnb = Cnb_new;
ins.att = att_new;
ins.vel = vel_new;
ins.pos = pos_new;
ins.x = [ins.att;ins.vel;ins.pos;ins.bg;ins.ba];

old_dw=dw0;
old_dv=dv0;

return

