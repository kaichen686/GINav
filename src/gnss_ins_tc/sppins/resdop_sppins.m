function [v,H,R,nv]=resdop_sppins(obs,nav,sv,sat_,x,P,rtk)

global glc
nobs=size(obs,1);v=zeros(nobs,1); H=zeros(nobs,rtk.nx); R=zeros(nobs,nobs); 
var=zeros(nobs,nobs); nv=0; azel=zeros(nobs,2);
pos=x(7:9);  [rr,Cen]=blh2xyz(pos); vr=Cen*x(4:6);
% ins=rtk.ins;
% lever=Cen*ins.Cnb*ins.lever;
% wnin=ins.eth.wnin; wbib=ins.wbib;
% K_phi=Cen*(ins.Cnb*askew(askew(ins.lever)*wbib)+askew(wnin)*ins.Cnb*ins.lever);
% vr=Cen*rtk.x(4:6)-Cen*ins.Cnb*askew(ins.lever)*wbib-Cen*askew(wnin)*ins.Cnb*ins.lever;
% dtr_drift=rtk.x(rtk.ic+2);

for i=1:nobs
    
    sat=obs(i).sat; lam=nav.lam(sat,:); dop=obs(i).D(1);
    if lam(1)==0||dop==0,continue;end
    
    rs=sv(i).pos;  vs=sv(i).vel;
    dts_drift=sv(i).dtsd;  vsat=sat_.vsat(i);
    
    [r,LOS]=geodist(rs,rr); azel(i,:)=satazel(pos,LOS);
    if r<=0||azel(i,2)<rtk.opt.elmin,continue;end
    
    [sys,~]=satsys(sat);
    if sys==0||lam(1)==0||dop==0||norm(vs)<=0||vsat==0
        continue;
    end
    
    % doppler residuals
    del_r=rs-rr; del_v=vs-vr; dtr_drift=x(rtk.ic+6);
    rate=dot(del_v,LOS)+glc.OMGE/glc.CLIGHT*(vs(2)*rr(1)+rs(2)*vr(1)-vs(1)*rr(2)-rs(1)*vr(2));
    v(nv+1,1) = -lam(1)*dop-(rate+dtr_drift-glc.CLIGHT*dts_drift);
 
    % measurement matrix
    T=Dblh2Dxyz(pos);
    m=(del_v/r-del_r*(del_r'*del_v)/r^3)';
    n=LOS*Cen;
    H(nv+1,:)=0;
    %H(nv+1,1:3)=m*askew(lever)-n*K_phi;
    H(nv+1,4:6)=n;
    H(nv+1,7:9)=m*T;
    H(nv+1,rtk.ic+6)=1;
    
    % variance
    var(nv+1,1)=(0.03/sin(azel(i,2)))^2;
    
    nv=nv+1;

end

if nv==0
    v=NaN;H=NaN;R=NaN;return;
end

% measurement noise matrix
for i=1:nv
    for j=1:nv
        if i==j
            R(i,j)=var(i);
        else
            R(i,j)=0;
        end
    end
end

if nv<nobs
    v(nv+1:end,:)=[]; H(nv+1:end,:)=[]; R(nv+1:end,:)=[]; R(:,nv+1:end)=[];
end

% IGG-3 model proposed by YuanXi Yang
if rtk.opt.ins.aid(2)==1&&rtk.ngnsslock>10
    
    Q=H*P*H'+R;
    c0 = 1.5; c1 = 3;
    nv = size(v,1); std_res=zeros(nv,1); rfact=zeros(nv,1);
    
    for i=1:nv
        std_res(i)=abs(v(i))/sqrt(Q(i,i));
    end
    
    % robust factor
    for i=1:nv
        if std_res(i) <= c0
            rfact(i) = 1;
        elseif (std_res(i) >= c0) && (std_res(i) <= c1)
            rfact(i)= abs(std_res(i))/c0 * ((c1-c0)/(c1-abs(std_res(i))))^2;
        else
            rfact(i) = 10^6;
        end
    end
    
    idx=find(rfact==10^6);
    ratio=size(idx,1)/nv;
    if ratio<0.6
        for i=1:nv
            for j=1:nv
                if j~=i,continue;end
                R(i,j)=R(i,j)*sqrt(rfact(i)*rfact(j));
            end
        end
    end
    
end

return

