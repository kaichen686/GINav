function dr=tidedisp(tutc,rr,opt,erp,odisp)

dr=zeros(3,1);

% get earth rotation parameter values
if ~isempty(erp)
    erpv=geterp(utc2gpst(tutc),erp); 
end

tut=timeadd(tutc,erpv(3));

if norm(rr)<=0,return;end

pos(1)=asin(rr(3)/norm(rr));
pos(2)=atan2(rr(2),rr(1));
Cne=xyz2enu(pos);

% solid earth tides
if bitand(opt,1)
    [rsun,rmoon,gmst]=sunmoonpos(tutc,erpv);
    drt=tide_solid(pos(1:2),Cne,rsun,rmoon,gmst,opt);
    dr=dr+drt';
end

% ocean tide loading
if bitand(opt,2)
    denu=tide_oload(tut,odisp);
    drt=Cne'*denu';
    dr=dr+drt;
end   

% pole tide
if bitand(opt,4)
    denu=tide_pole(tut,pos(1:2),erpv);
    drt=Cne'*denu';
    dr=dr+drt;
end

return

