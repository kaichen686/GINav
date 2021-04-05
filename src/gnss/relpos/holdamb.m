function rtk=holdamb(rtk,xa)

global glc
nf=rtk.NF; nb=rtk.NB; nv=0; VAR_HOLDAMB=0.001;
v=zeros(nb,1); H=zeros(nb,rtk.nx);

for m=1:5
    for f=1:nf
        n=0;
        for i=1:glc.MAXSAT
            if ~test_sys(rtk.sat(i).sys,m)||rtk.sat(i).fix(f)~=2||...
                    rtk.sat(i).azel(2)<rtk.opt.elmaskhold
                continue;
            end
            idx(n+1)=rtk.ib+(f-1)*glc.MAXSAT+i;
            rtk.sat(i).fix(f)=3;
            n=n+1;
        end
        
        %constraint to fixed ambiguity
        for i=2:n
            v(nv+1)=(xa(idx(1))-xa(idx(i)))-(rtk.x(idx(1))-rtk.x(idx(i)));
            H(nv+1,idx(1))= 1;
            H(nv+1,idx(i))=-1;
            nv=nv+1;
        end
        
    end
end
v(nv+1:end)=[]; H(nv+1:end,:)=[];
% printx(xa,rtk);
if nv>0
    R=zeros(nv,nv);
    for i=1:nv
        R(i,i)=VAR_HOLDAMB;
    end
    % update states with constraints
    [x,P,stat_tmp]=Kfilter_h(v,H,R,rtk.x,rtk.P);
    if stat_tmp==0
        [week,sow]=time2gpst(rtk.sol.time);
        fprintf('Warning:GPS week = %d sow = %.3f,filter error!\n',week,sow);
    else
        rtk.x=x; rtk.P=P;
    end
end

return

