function rtk=udpos(rtk,tt)

global glc
VAR_POS=30^2; VAR_VEL=10^2; VAR_ACC=10^2; var=0;

% initialize position for first epoch
if norm(rtk.x(1:3))<=0
    for i=1:3,rtk=initx(rtk,rtk.sol.pos(i),VAR_POS,i);end
    if rtk.opt.dynamics==1
        for i=1:3,rtk=initx(rtk,rtk.sol.vel(i),VAR_VEL,i+3);end
        for i=1:3,rtk=initx(rtk,1e-6,VAR_ACC,i+6);end
    end
    return;
end

% static mode
if rtk.opt.mode==glc.PMODE_STATIC,return;end

% kinmatic mode without dynamics
if ~rtk.opt.dynamics
    for i=1:3,rtk=initx(rtk,rtk.sol.pos(i),VAR_POS,i);end
    return;
end

for i=1:3
    var=var+rtk.P(i,i);
end
var=var/3;

if var>VAR_POS
    for i=1:3,rtk=initx(rtk,rtk.sol.pos(i),VAR_POS,i);end
    for i=4:6,rtk=initx(rtk,rtk.sol.vel(i-3),VAR_VEL,i);end
    for i=7:9,rtk=initx(rtk,1e-6,VAR_ACC,i);end
    return;
end

nx=0;ix=zeros(rtk.nx,1);
for i=1:rtk.nx
    if rtk.x(i)~=0&&rtk.P(i,i)>0
        ix(nx+1)=i;
        nx=nx+1;
    end
end
ix(nx+1:end)=[];

if nx<9,return;end

% state transition of position/velocity/acceleration
F=eye(nx); x=zeros(nx,1); P=zeros(nx,nx);
for i=1:6,F(i,i+3)=tt;end
for i=1:3,F(i,i+6)=tt^2*0.5;end

for i=1:nx
    x(i)=rtk.x(ix(i));
    for j=1:nx
        P(i,j)=rtk.P(ix(i),ix(j));
    end
end

xp=F*x; P=F*P*F';

for i=1:nx
    rtk.x(ix(i))=xp(i);
    for j=1:nx
        rtk.P(ix(i),ix(j))=P(i,j);
    end
end

% process noise added to only acceleration
Q(1,1)=rtk.opt.prn(4)^2*abs(tt);
Q(2,2)=rtk.opt.prn(4)^2*abs(tt);
Q(3,3)=rtk.opt.prn(5)^2*abs(tt);
[~,Cne]=xyz2blh(x(1:3));
Qv=Cne'*Q*Cne;

for i=1:3
    for j=1:3
        rtk.P(i+6,j+6)=rtk.P(i+6,j+6)+Qv(i,j);
    end
end

return

