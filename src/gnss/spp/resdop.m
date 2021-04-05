function [v,H,P,nv]=resdop(rtk,obs,nav,sv,sat_,x)

global glc
v=zeros(glc.MAXOBS,1);H=zeros(glc.MAXOBS,4); var=zeros(glc.MAXOBS,glc.MAXOBS);
nobs=size(obs,1); nv=0; DOP_VAR=0.05^2; P=zeros(glc.MAXOBS,glc.MAXOBS);
rr = rtk.sol.pos; [~,Cne]=xyz2blh(rr);


for i=1:nobs
    
    lam=nav.lam(obs(i).sat,1); dop = obs(i).D(1); 
    azel=sat_.azel(i,:); vsat=sat_.vsat(i);
    rs=sv(i).pos; vs=sv(i).vel; dts_drift=sv(i).dtsd;

    if dop==0||lam==0||vsat==0||norm(vs)<=0
        continue;
    end
    
    % compute elevation,LOS
    cosel=cos(azel(2));
    a(1,1)=sin(azel(1))*cosel;
    a(2,1)=cos(azel(1))*cosel;
    a(3,1)=sin(azel(2));
    e=Cne'*a;
    
    % satellite velocity relative to receiver in ecef
    delta_v=vs-x(1:3);
    
    % range rate with earth rotation correction
    rate=dot(delta_v,e)+glc.OMGE/glc.CLIGHT*(vs(2)*rr(1)+rs(2)*x(1)-vs(1)*rr(2)-rs(1)*x(2));
    
    % compute dop rasiduals
    v(nv+1,1)=-lam*dop-(rate+x(4)-glc.CLIGHT*dts_drift);
    
    % design mesurement model
    H(nv+1,:)=[-e',1];
    
    % variance
    var(nv+1,nv+1)=DOP_VAR;
    
    nv=nv+1;

end

if nv==0
    v=NaN;H=NaN;P=NaN;return;
end

% compute weight matrix
for i=1:nv
    P(i,i)=var(i,i)^-1;
end

if nv<glc.MAXOBS
    v(nv+1:end,:)=[]; H(nv+1:end,:)=[];
    P(nv+1:end,:)=[]; P(:,nv+1:end)=[];
end

% exclude gross errors
[v,H,P]=robust_dop(v,H,P);
nv=size(v,1);

return

