function rtk = detslip_gf_L1L2(rtk,obsr,obsb,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% detect cycle slip using the geometry-free liner combination
% the detection threshold can be configured in option
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

sat=obsr.sat;

g1=gfobs_L1L2(obsr,obsb,nav.lam(sat,:));
if rtk.opt.nf<=1||g1==0,return;end

g0=rtk.sat(sat).gf;
rtk.sat(sat).gf=g1;

if g0~=0&&abs(g1-g0)>rtk.opt.csthres(1)
    rtk.sat(sat).slip(1)=bitor(rtk.sat(sat).slip(1),1);
    rtk.sat(sat).slip(2)=bitor(rtk.sat(sat).slip(2),1);
end
    
return