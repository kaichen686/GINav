function [trop,dtdx]=prectrop(time,pos,r,azel,rtk,x)

global glc;
dtdx=zeros(3,1);
if r==1,i=rtk.itr;elseif r==2,i=rtk.itb;end

[~,m_w]=tropmapf(time,pos,azel);

if rtk.opt.tropopt==glc.TROPOPT_ESTG&&azel(2)>0
    cotz=1/tan(azel(2));
    grad_n=m_w*cotz*cos(azel(1));
    grad_e=m_w*cotz*sin(azel(1));
    m_w=m_w+grad_n*x(i+2)+grad_e*x(i+3);
    dtdx(2)=grad_n*x(i+1);
    dtdx(3)=grad_e*x(i+1);
else
    dtdx(2)=0;
    dtdx(3)=0;
end

dtdx(1)=m_w;
trop=m_w*x(i+1);

return