function gf=gfobs_L1L5(obsr,obsb,lam)

pi=sdobs(obsr,obsb,1)*lam(1);
pj=sdobs(obsr,obsb,3)*lam(3);

if pi==0||pj==0
    gf=0;
else
    gf=pi-pj;
end

return