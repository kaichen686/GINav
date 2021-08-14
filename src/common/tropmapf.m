function [mh,mw]=tropmapf(time,pos,azel)

if pos(3)<-1000||pos(3)>20000
    mh=0; mw=0; return;
end

% hydro-ave-a,b,c, hydro-amp-a,b,c, wet-a,b,c at latitude 15,30,45,60,75
coef=[ 1.2769934E-3, 1.2683230E-3, 1.2465397E-3, 1.2196049E-3, 1.2045996E-3;...
       2.9153695E-3, 2.9152299E-3, 2.9288445E-3, 2.9022565E-3, 2.9024912E-3;...
       62.610505E-3, 62.837393E-3, 63.721774E-3, 63.824265E-3, 64.258455E-3;...
    
       0.0000000E-0, 1.2709626E-5, 2.6523662E-5, 3.4000452E-5, 4.1202191E-5;...
       0.0000000E-0, 2.1414979E-5, 3.0160779E-5, 7.2562722E-5, 11.723375E-5;...
       0.0000000E-0, 9.0128400E-5, 4.3497037E-5, 84.795348E-5, 170.37206E-5;...
    
       5.8021897E-4, 5.6794847E-4, 5.8118019E-4, 5.9727542E-4, 6.1641693E-4;...
       1.4275268E-3, 1.5138625E-3, 1.4572752E-3, 1.5007428E-3, 1.7599082E-3;...
       4.3472961E-2, 4.6729510E-2, 4.3908931E-2, 4.4626982E-2, 5.4736038E-2];

% height correction
aht=[2.53E-5, 5.49E-3, 1.14E-3];
ah=zeros(3,1); aw=zeros(3,1);

if azel(2)<=0,mh=0; mw=0; return;end
    
lat=pos(1)*180/pi;
if lat<0,yy=0.5;else,yy=0;end
y=(time2doy(time)-28.0)/365.25+yy;
cosy=cos(2.0*pi*y);
lat=abs(lat);

for i=1:3
    ah(i)=interpc(coef(i,:),lat)-interpc(coef(i+3,:),lat)*cosy;
    aw(i)=interpc(coef(i+6,:),lat);
%     j=fix(lat/15);
%     ah(i)=(coef(i,j)+(coef(i,j+1)-coef(i,j))*(lat/15-j))-...
%           (coef(i+3,j)+(coef(i+3,j+1)-coef(i+3,j))*(lat/15-j))*cosy;
%     aw(i)=(coef(i+6,j)+(coef(i+6,j+1)-coef(i+6,j))*(lat/15-j));
end

el=azel(2);
sinel=sin(el);

mh1=(1+ah(1)/(1+ah(2)/(1+ah(3))))/(sinel+(ah(1)/(sinel+ah(2)/(sinel+ah(3)))));
mh2=(1+aht(1)/(1+aht(2)/(1+aht(3))))/(sinel+(aht(1)/(sinel+aht(2)/(sinel+aht(3)))));
mh=mh1+(1/sinel-mh2)*pos(3)/1000;

mw=(1+aw(1)/(1+aw(2)/(1+aw(3))))/(sinel+(aw(1)/(sinel+ah(2)/(sinel+aw(3)))));

return


