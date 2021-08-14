function rtk = detslip_gf_L1L5(rtk,obsr,obsb,nav)

sat=obsr.sat;

g1=gfobs_L1L5(obsr,obsb,nav.lam(sat,:));
if rtk.opt.nf<=2||g1==0,return;end

g0=rtk.sat(sat).gf2;
rtk.sat(sat).gf2=g1;

if g0~=0&&abs(g1-g0)>rtk.opt.csthres(1)
    rtk.sat(sat).slip(1)=bitor(rtk.sat(sat).slip(1),1);
    rtk.sat(sat).slip(3)=bitor(rtk.sat(sat).slip(3),1);
end
    
return