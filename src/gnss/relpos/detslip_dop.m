function rtk = detslip_dop(rtk,obs,rcv)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%detect cycle slip using doppler observation of current and previous epochs 
%the detetion threshold can be configured in option
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% dop_old=rtk.sat.pD(obs.prn,rcv);
% dop_cur=obs.D1;
% phase_old=rtk.sat.pL(obs.prn,rcv);
% phase_cur=obs.L1;
% 
% 
% if dop_old~=0 && dop_cur~=0 && phase_old~=0 && phase_cur~=0
%     slip = abs((phase_cur-phase_old)+(dop_old+dop_cur)/2);
%     if slip>=rtk.opt.csthres(3)
%         rtk.sat.slip(obs.prn)=1;
%     end
% end
% 
% rtk.sat.pD(obs.prn,rcv)=dop_cur;
% rtk.sat.pL(obs.prn,rcv)=phase_cur;

return