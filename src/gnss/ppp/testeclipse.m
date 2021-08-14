function sv=testeclipse(obs,nav,sv)

global glc
erpv=zeros(5,1); nobs=size(obs,1);

[rsun,~,~]=sunmoonpos(gpst2utc(obs(1).time),erpv);
esun=rsun/norm(rsun);

for i=1:nobs
    type=nav.pcvs(obs(i).sat).type;
    
    r=norm(sv(i).pos);
    if r<=0,continue;end
    
    % only for block IIA
    if ~isempty(type)&&isempty(strfind(type,'BLOCK IIA')),continue;end
    
    % sun-earth-satellite angle
    cosa=dot(sv(i).pos,esun)/r;
    if cosa<-1,cosa=-1;elseif cosa>1,cosa=1;end
    ang=acos(cosa);
    
    if ang<pi/2||r*sin(ang)>glc.RE_WGS84,continue;end
    
    for j=1:3
        sv(i).pos(j)=0;
    end
    
end

return

