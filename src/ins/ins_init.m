function ins=ins_init(opt,avp0)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INS initilization
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% sample date
ins.nt = 1/opt.sample_rate;
ins.old_imud = zeros(1,6);

% initialize position,attitude and velocity
ins.att = avp0(1:3);
ins.vel = avp0(4:6);
ins.pos = avp0(7:9);
ins.acc = zeros(3,1);
ins.Cnb = att2Cnb(ins.att);

% initialize imu error
ins.bg = zeros(3,1);
ins.ba = zeros(3,1);
ins.Kg = eye(3);
ins.Ka = eye(3);
ins.tauG = [inf;inf;inf];
ins.tauA = [inf;inf;inf];

% initialize earth related parameters
ins.eth = earth_update(ins.pos,ins.vel);
ins.Mpv = [0, ins.eth.Mpv4, 0; ins.eth.Mpv2, 0, 0; 0, 0, 1];
ins.wib = zeros(3,1);
ins.fb  = zeros(3,1);
ins.fn  = -ins.eth.gn;
ins.web = zeros(3,1);

% initialize state, state covariance matrix, system noise matrix
% state transition matrix, lever arm
init_att_unc = opt.init_att_unc;
init_vel_unc = opt.init_vel_unc;
init_pos_unc = opt.init_pos_unc;
init_bg_unc  = repmat(opt.init_bg_unc,1,3);
init_ba_unc  = repmat(opt.init_ba_unc,1,3);
psd_gyro = repmat(opt.psd_gyro,1,3);
psd_acce = repmat(opt.psd_acce,1,3);
psd_bg   = repmat(opt.psd_bg,1,3);
psd_ba   = repmat(opt.psd_ba,1,3);

ins.x  = [ins.att;ins.vel;ins.pos;ins.bg;ins.ba];
ins.P  = diag([init_att_unc,init_vel_unc,init_pos_unc,init_bg_unc,init_ba_unc].^2);
ins.Q  = diag([psd_gyro, psd_acce, zeros(1,3), psd_bg, psd_ba])*ins.nt;
ins.Phi= update_trans_mat(ins);
ins.lever = opt.lever';

ins.xa = zeros(15,1);
ins.Pa = zeros(15,15);

return

