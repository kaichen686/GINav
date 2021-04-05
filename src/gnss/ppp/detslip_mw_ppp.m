function rtk=detslip_mw_ppp(rtk,obs,nav)

THRES_MW_JUMP=10;
nobs=size(obs,1);

for i=1:nobs
    w1=mwmeas(obs(i),nav);
    if w1==0,continue;end
    w0=rtk.sat(obs(i).sat).mw;
    rtk.sat(obs(i).sat).mw=w1;
    if w0~=0&&abs(w1-w0)>THRES_MW_JUMP
        for j=1:rtk.opt.nf
            tmp=rtk.sat(obs(i).sat).slip(j);
            rtk.sat(obs(i).sat).slip(j)=bitor(tmp,1);
        end
    end
end

return

function mw=mwmeas(obs,nav)
global glc %#ok
lam=nav.lam(obs.sat,:);
[sys,~]=satsys(obs.sat); %#ok
% if sys==glc.SYS_GAL,k=3;else,k=2;end
k=2;

if lam(1)==0||lam(k)==0||obs.L(1)==0||obs.L(k)==0||obs.P(1)==0||obs.P(k)==0
    mw=0;return;
end

mw=lam(1)*lam(k)*(obs.L(1)-obs.L(k))/(lam(k)-lam(1))-...
    (lam(k)*obs.P(1)+lam(1)*obs.P(k))/(lam(k)+lam(1));
return;
