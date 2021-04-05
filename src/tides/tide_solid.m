function dr=tide_solid(pos,Cne,rsun,rmoon,gmst,opt)

GMS=1.327124E+20; %sun gravitational constant
GMM=4.902801E+12; %moon gravitational constant
eu(1)=Cne(3);eu(2)=Cne(6);eu(3)=Cne(9);

% step1:time domain
dr1=tide_pl(eu,rsun,GMS,pos);
dr2=tide_pl(eu,rmoon,GMM,pos);

% step2:frequency domain, only K1 radial
sin21=sin(2*pos(1));
du=-0.012*sin21*sin(gmst+pos(2));

dr(1)=dr1(1)+dr2(1)+du*Cne(3);
dr(2)=dr1(2)+dr2(2)+du*Cne(6);
dr(3)=dr1(3)+dr2(3)+du*Cne(9);

% eliminate permanent deformation
if bitand(opt,8)
    sin1=sin(pos(1));
    du=0.1196*(1.5*sin1*sin1-0.5);
    dn=0.0247*sin21;
    dr(1)=dr(1)+du*Cne(3)+dn*Cne(2);
    dr(2)=dr(2)+du*Cne(6)+dn*Cne(5);
    dr(3)=dr(3)+du*Cne(9)+dn*Cne(8);
end

return

