function [trop_delay,var]=trop_mops(time,pos,azel)

k1=77.604;k2=382000;rd=287.054;gm=9.784;g=9.80665;
persistent pos_ zh zw
sinel=sin(azel(2)); h=pos(3);

if isempty(pos_),pos_=zeros(3,1);end
if isempty(zh),zh=0;end
if isempty(zh),zh=0;end

if pos(3)<-100||pos(3)>10000||azel(2)==0
    trop_delay=0;
    var=0;
    return;
end

if zh==0||abs(pos(1)-pos_(1))>1e-7||abs(pos(2)-pos_(2))>1e-7||abs(pos(3)-pos_(3))>1
    met=getmet(pos(1)*180/pi);
    if pos(1)>=0
        tmp=28;
    else
        tmp=211;
    end
    doy=time2doy(time);
    c=cos(2*pi*(doy-tmp)/365.25);
    for i=1:5
        met(i)=met(i)-met(i+5)*c;
    end
    zh=1E-6*k1*rd*met(1)/gm;
    zw=1E-6*k2*rd/(gm*(met(5)+1.0)-met(4)*rd)*met(3)/met(2);
    zh=zh*(1.0-met(4)*h/met(2))^(g/(rd*met(4)));
    zw=zw*(1.0-met(4)*h/met(2))^((met(5)+1.0)*g/(rd*met(4))-1.0);
    for i=1:3
        pos_(i)=pos(1);
    end
end

m=1.001/sqrt(0.002001+sinel*sinel); %mapping function of GCAT model
trop_delay=(zh+zw)*m;
var=0.12*0.12*m*m;

return
    
    