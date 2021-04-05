function sd=sdobs(obsr,obsb,f)

global glc

if f<=glc.NFREQ
    pi=obsr.L(f);
else
    pi=obsr.P(f-glc.NFREQ);
end

if f<=glc.NFREQ
    pj=obsb.L(f);
else
    pj=obsb.P(f-glc.NFREQ);
end

if pi==0||pj==0
    sd=0;
else
    sd=pi-pj;
end

return