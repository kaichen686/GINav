function [L,P,Lc,Pc]=corr_meas(rtk,obs,nav,dantr,dants,phw)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SNR test not surpport
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc
lam=nav.lam(obs.sat,:);
L=zeros(glc.NFREQ,1);P=zeros(glc.NFREQ,1);Lc=0;Pc=0;

for i=1:glc.NFREQ
    L(i)=0; P(i)=0;
    if lam(i)==0||obs.L(i)==0||obs.P(i)==0,continue;end
    
    %antenna phase center and phase windup correction
    L(i)=obs.L(i)*lam(i)-dants(i)-dantr(i)-phw*lam(i);
    P(i)=obs.P(i)       -dants(i)-dantr(i);
    
end

% DCB correction 
[cbias,~]=getdcb(nav,obs,rtk.opt);
for i=1:glc.NFREQ
    if P(i)~=0,P(i)=P(i)-cbias(i);end
end
C1= lam(2)^2/(lam(2)^2-lam(1)^2);
C2=-lam(1)^2/(lam(2)^2-lam(1)^2);

%IFLC measurements
if L(1)~=0&&L(2)~=0,Lc=C1*L(1)+C2*L(2);end
if P(1)~=0&&P(2)~=0,Pc=C1*P(1)+C2*P(2);end

return


