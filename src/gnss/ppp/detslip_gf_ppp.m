function rtk=detslip_gf_ppp(rtk,obs,nav)

nobs=size(obs,1);

for i=1:nobs
    g1=gfmeas(obs(i),nav);
    if g1==0,continue;end
    g0=rtk.sat(obs(i).sat).gf;
    rtk.sat(obs(i).sat).gf=g1;
    if g0~=0&&abs(g1-g0)>rtk.opt.csthres(1)
        for j=1:rtk.opt.nf
            tmp=rtk.sat(obs(i).sat).slip(j);
            rtk.sat(obs(i).sat).slip(j)=bitor(tmp,1);
        end
    end
end

return



function gf=gfmeas(obs,nav)
global glc %#ok
lam=nav.lam(obs.sat,:);

[sys,~]=satsys(obs.sat); %#ok
% if sys==glc.SYS_GAL,k=3;else,k=2;end
k=2;

if lam(1)==0||lam(k)==0||obs.L(1)==0||obs.L(k)==0
    gf=0; return;
end
gf=lam(1)*obs.L(1)-lam(k)*obs.L(k);

return;




