function rtk=holdamb_rtkins(rtk,xa)

global glc
nf=rtk.NF; nb=rtk.NB; nv=0; VAR_HOLDAMB=0.001;
v=zeros(nb,1); H=zeros(nb,rtk.nx); idx=zeros(glc.MAXSAT,1);

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

if nv>0
    R=zeros(nv,nv);
    for i=1:nv
        R(i,i)=VAR_HOLDAMB;
    end
    % update states with constraints
    [x,P,x_fb,stat_tmp]=rtkins_filter(v,H,R,rtk.x,rtk.P);
    if stat_tmp==0,return;end
    rtk.x=x; rtk.P=P;
    rtk=rtkins_feedback(rtk,x_fb,1); %note!!!
end

return

