function [vel,var]=estvel_rtkins(rtk,obs,nav,sv) 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%estimate reciever velocity and clock drift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stat=0; MAXITER=10; iter=1; 
vel0=rtk.ins.vel; pos=rtk.ins.x(7:9);  [~,Cen]=blh2xyz(pos);
ve=Cen*vel0; x=[ve;0]; 

while iter<=MAXITER
    % residual,measurement model,weight matrix
    [v,H,P,nv]=resdop_rtkins(rtk,obs,nav,sv,x);
    if nv<4,break;end
    
    % least square
    [dx,Q]=least_square(v,H,P);
    x=x+dx;
    
    if dot(dx,dx)<10^-4
        vel=Cen'*x(1:3);
        var=Cen'*Q(1:3,1:3)*Cen;
        stat=1; break;
    end
    iter=iter+1;
end

if stat==0
    vel=zeros(3,1); var=zeros(3,3);
end

return


function [v,H,P,nv]=resdop_rtkins(rtk,obs,nav,sv,x)

global glc
DOP_STD=0.03; nobs=size(obs,1);
v=zeros(nobs,1);H=zeros(nobs,4); var=zeros(nobs,1);
nv=0; azel=zeros(nobs,2); P=zeros(nobs,nobs);
pos=rtk.ins.x(7:9);  [rr,~]=blh2xyz(pos); vr=x(1:3);


for i=1:nobs
    
    sat=obs(i).sat; lam=nav.lam(sat,:); dop=obs(i).D(1);
    if lam(1)==0||dop==0,continue;end
    
    rs=sv(i).pos;  vs=sv(i).vel;
    dts_drift=sv(i).dtsd; 
    
    [r,LOS]=geodist(rs,rr); azel(i,:)=satazel(pos,LOS);
    if r<=0||azel(i,2)<rtk.opt.elmin,continue;end
    
    [sys,~]=satsys(sat);
    if sys==0||lam(1)==0||dop==0||norm(vs)<=0
        continue;
    end
    
    % doppler residuals
    dv=vs-vr; dtr_drift=x(4);
    rate=dot(dv,LOS)+glc.OMGE/glc.CLIGHT*(vs(2)*rr(1)+rs(2)*vr(1)-vs(1)*rr(2)-rs(1)*vr(2));
    v(nv+1,1) = -lam(1)*dop-(rate+dtr_drift-glc.CLIGHT*dts_drift);
 
    % measurement matrix
    H(nv+1,:)=[-LOS,1];
    
    % variance
    var(nv+1,1)=(DOP_STD/sin(azel(i,2)))^2;
    
    nv=nv+1;

end

if nv==0
    v=NaN;H=NaN;P=NaN;return;
end

if nv<nobs
    v(nv+1:end,:)=[]; H(nv+1:end,:)=[]; P(nv+1:end,:)=[]; P(:,nv+1:end)=[];
end

% compute weight matrix
for i=1:nv
    P(i,i)=var(i)^-1;
end

% exclude gross errors
[v,H,P]=robust_dop(v,H,P);
nv=size(v,1);

return

