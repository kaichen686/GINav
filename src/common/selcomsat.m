function ind=selcomsat(obsr,obsb,opt,zdb)

k=0;
nr=size(obsr,1);
nb=size(obsb,1);

for i=1:nr
    satr=obsr(i).sat;
    for j=1:nb
        if obsb(j).sat==satr
            if zdb(j).azel(2)>=opt.elmin
                ind.sat(k+1)=satr;
                ind.ir(k+1)=i;
                ind.ib(k+1)=j;
                k=k+1;
            end
        end
    end
end

ind.ns=k;

return