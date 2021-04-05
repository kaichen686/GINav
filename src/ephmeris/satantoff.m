function dant=satantoff(time,rs,sat,nav)

global glc
j=1;k=2;
lam=nav.lam(sat,:);
pcv=nav.pcvs(sat);
erpv=zeros(5,1);

% sun and moon position in ECEF
[rsun,~,~]=sunmoonpos(gpst2utc(time),erpv);

% calculate the transition matrix from ECI to ECEF
ez=-rs/norm(rs);
r=rsun-rs;
es=r/norm(r);
r=cross(ez,es);
ey=r/norm(r);
ex=cross(ey,ez);
M=[ex,ey,ez];

% calculate antenna offset
[sys,~]=satsys(sat);
%if glc.NFREQ>=3&&sys==glc.SYS_GAL,k=3;end
if glc.NFREQ<2||lam(j)==0||lam(k)==0,return;end

gamma=lam(k)^2/lam(j)^2;
C1=gamma/(gamma-1);
C2=-1/(gamma-1);

if sys==glc.SYS_GPS
    j=1;k=2;
elseif sys==glc.SYS_GLO
    j=1+glc.NFREQ; k=2+glc.NFREQ;
elseif sys==glc.SYS_GAL
    j=1+2*glc.NFREQ; k=2+2*glc.NFREQ;
elseif sys==glc.SYS_BDS
    j=1+3*glc.NFREQ; k=2+3*glc.NFREQ;
elseif sys==glc.SYS_QZS
    j=1+4*glc.NFREQ; k=2+4*glc.NFREQ;
end

% iono-free LC
dant1=M*pcv.off(j,:)';
dant2=M*pcv.off(k,:)';
dant=C1*dant1+C2*dant2;

return

