function xa=restamb(rtk,bias,nb,xa)  %#ok

global glc
nf=rtk.NF; nv=0; index=zeros(glc.MAXSAT,1);

xa(1:rtk.nx)=rtk.x;
xa(1:rtk.na)=rtk.xa;

for m=1:5
    for f=1:nf
        n=0;
        for i=1:glc.MAXSAT
            if ~test_sys(rtk.sat(i).sys,m)||rtk.sat(i).fix(f)~=2
                continue;
            end
            index(n+1)=rtk.ib+(f-1)*glc.MAXSAT+i;
            n=n+1;
        end
        
        if n<2,continue;end
        xa(index(1))=rtk.x(index(1));
        
        for i=2:n
            xa(index(i))=xa(index(1))-bias(nv+1);
            nv=nv+1;
        end
    end
end

return

