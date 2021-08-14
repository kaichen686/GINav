function ins=ins_time_updata(ins)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INS time update
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ins.Phi=update_trans_mat(ins);

G=zeros(15,15);
G(1:3,1:3)=-ins.Cnb;
G(4:6,4:6)=ins.Cnb;
G(10:12,10:12)=eye(3);
G(13:15,13:15)=eye(3);

Q0=G*ins.Q*G';
P0=ins.P+0.5*Q0;
ins.P=ins.Phi*P0*ins.Phi'+0.5*Q0;

% ins.P=ins.Phi*ins.P*ins.Phi'+ins.Q;

return