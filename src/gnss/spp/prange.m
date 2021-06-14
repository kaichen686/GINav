function [PC,Vmea]=prange(obs,nav,opt,azel,iter) %#ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
lam=nav.lam(obs.sat,:);
PC=0;Vmea=0;
i=1; j=2;

[sys,~]=satsys(obs.sat);
if sys==0,return;end

% if glc.NFREQ>=3&&(sys==glc.SYS_GAL),j=3;end

if glc.NFREQ<2||lam(i)==0||lam(j)==0,return;end

% test snr mask
if iter>1
end

% pseudorange with code bias correction
[cbias,use_dcb_flag]=getdcb(nav,obs,opt);
if use_dcb_flag==0&&sys~=glc.SYS_GLO
    cbias=gettgd(nav,obs,opt);
end
P1=obs.P(i)-cbias(1);
P2=obs.P(j)-cbias(2);

gamma=lam(j)^2/lam(i)^2;
if opt.ionoopt==glc.IONOOPT_IFLC
    if P1==0||P2==0,return;end
    PC=(gamma*P1-P2)/(gamma-1);
else
    if P1==0,return;end
    PC=P1;
end

Vmea=0.3^2;

return

