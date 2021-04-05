function rtk=udion_rtkins(rtk,tt,bl,ind)

global glc;
GAP_RESION=120;

for i=1:glc.MAXSAT
    j=rtk.ii+i;
    if rtk.x(j)~=0&&rtk.sat(i).outc(1)>GAP_RESION&&rtk.sat(i).outc(2)>GAP_RESION
        rtk.x(j)=0;
    end
end

for i=1:ind.ns
    j=rtk.ii+ind.sat(i);
    
    if rtk.x(j)==0
        rtk=initx(rtk,1e-6,(rtk.opt.std(2)*bl/1e4)^2,j);
    else
        el=rtk.sat(ind.sat(i)).azel(2);
        fact=cos(el);
        rtk.P(j,j)=rtk.P(j,j)+(rtk.opt.prn(2)*bl/1e4*fact)^2*abs(tt);
    end
end

return