function [dtdx,dtrp,vart]=trop_model_prec(time,pos,azel,x)

zhd=tropmodel(pi/2,pos,0); %zenith hydrostatic delay

[mh,mw]=tropmapf(time,pos,azel); %hydrostatic and wet projection coefficient

if azel(2)>0
    %equation: m_w=m_0+m_0*cot(el)*(Gn*cos(az)+Ge*sin(az))
    cotz=1.0/tan(azel(2));
    grad_n=mw*cotz*cos(azel(1)); %north wet projection coefficient
    grad_e=mw*cotz*sin(azel(1)); %east wet projection coefficient
    mw=mw+grad_n*x(2)+grad_e*x(3); %total wet projection coefficient
    dtdx(2)=grad_n*(x(1)-zhd); %north wet delay
    dtdx(3)=grad_e*(x(1)-zhd); %east wet delay
end

dtdx(1)=mw; 
dtrp=mh*zhd+mw*(x(1)-zhd);
vart=0.01^2;

return;