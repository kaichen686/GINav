function rtk=udbias_rtkins(rtk,obsr,obsb,nav,ind)

global glc;
tt=rtk.tt;  nf=rtk.NF; MAXSAT=glc.MAXSAT; NFREQ=glc.NFREQ;
sat=ind.sat; ns=ind.ns; ir=ind.ir; ib=ind.ib;

% detect cycle slip
for i=1:ns
    
    for f=1:rtk.opt.nf
        tmp=rtk.sat(sat(i)).slip(f);
        rtk.sat(sat(i)).slip(f)=bitand(tmp,252);%0xFC=252
    end
    
    % detect cycle slip using loss of lock indicator (LLI)
    rtk = detslip_LLI(rtk,obsr,ir(i),1);
    rtk = detslip_LLI(rtk,obsb,ib(i),2);
    
    % detect cycle slip using geometry-free method
    rtk = detslip_gf_L1L2(rtk,obsr(ir(i)),obsb(ib(i)),nav);
    rtk = detslip_gf_L1L5(rtk,obsr(ir(i)),obsb(ib(i)),nav);
    
    % detect cycle slip using doppler integration method
    %rtk = detslip_dop(rtk,obsr(i),1);
    %rtk = detslip_dop(rtk,obsb(i),2);
     
end

% update ambiguity
for f=1:nf
    
    % reset ambiguity if instantaneous AR mode or expire obs outage counter
    for i=1:MAXSAT
        rtk.sat(i).outc(f)=rtk.sat(i).outc(f)+1;
        if rtk.sat(i).outc(f)>rtk.opt.maxout,reset=1;else,reset=0;end
        
        if rtk.opt.modear==glc.ARMODE_INST && rtk.x(rtk.ib+i)~=0
            rtk=initx(rtk,0,0,rtk.ib+(f-1)*MAXSAT+i);
        elseif reset==1 && rtk.x(rtk.ib+i)~=0
            rtk=initx(rtk,0,0,rtk.ib+(f-1)*MAXSAT+i);
            rtk.sat(i).outc(f)=0;
        end
        
        if rtk.opt.modear~=glc.ARMODE_INST && reset==1
            rtk.sat(i).lock(f)=-rtk.opt.minlock;
        end
    end
    
    % reset ambiguity if detecting cycle slip
    for i=1:ns
        j=rtk.ib+(f-1)*MAXSAT+sat(i);
        rtk.P(j,j)=rtk.P(j,j)+rtk.opt.prn(1)^2*abs(tt);
        slip=rtk.sat(sat(i)).slip(f);
        if rtk.opt.ionoopt==glc.IONOOPT_IFLC
            slip=bitor(slip,rtk.sat(sat(i)).slip(f));
        end
        if rtk.opt.modear==glc.ARMODE_INST||~bitand(slip,1),continue;end
        rtk.x(j)=0;
        rtk.sat(sat(i)).lock(f)=-rtk.opt.minlock;
    end
    
    bias=zeros(ns,1);
    
    % estimate approximate ambiguity by code adn phase comparison method
    j=0; offset=0;
    for i=1:ns
        if rtk.opt.ionoopt~=glc.IONOOPT_IFLC
            cp=sdobs(obsr(ir(i)),obsb(ib(i)),f);
            pr=sdobs(obsr(ir(i)),obsb(ib(i)),NFREQ+f);
            lami=nav.lam(sat(i),f);
            if cp==0||pr==0||lami<=0,continue;end
            bias(i)=cp-pr/lami;
        else
            cp1=sdobs(obsr(ir(i)),obsb(ib(i)),1);
            cp2=sdobs(obsr(ir(i)),obsb(ib(i)),2);
            pr1=sdobs(obsr(ir(i)),obsb(ib(i)),NFREQ+1);
            pr2=sdobs(obsr(ir(i)),obsb(ib(i)),NFREQ+2);
            lam1=nav.lam(sat(i),1);
            lam2=nav.lam(sat(i),2);
            if cp1==0||cp2==0||pr1==0||pr2==0||lam1<=0||lam2<=0,continue;end
            
            C1= lam2^2/(lam2^2-lam1^2);
            C2=-lam1^2/(lam2^2-lam1^2);
            bias(i)=(C1*lam1*cp1+C2*lam2*cp2)-(C1*pr1+C2*pr2);
        end
        
        if rtk.x(rtk.ib+(f-1)*MAXSAT+sat(i))~=0
            offset=offset+(bias(i)-rtk.x(rtk.ib+(f-1)*MAXSAT+sat(i)));
            j=j+1;
        end
    end

    % correct phase-bias offset to enssure phase-code coherency
    if j>0
        for i=1:MAXSAT
            idx=rtk.ib+(f-1)*MAXSAT+i;
            if rtk.x(idx)~=0
                rtk.x(idx)=rtk.x(idx)+offset/j;
            end
        end
    end
    
    % set initial ambiguity
    for i=1:ns
        idx=rtk.ib+(f-1)*MAXSAT+sat(i);
        if bias(i)==0 || rtk.x(idx)~=0,continue;end
        rtk=initx(rtk,bias(i),rtk.opt.std(1)^2,idx);
    end
          
end

return

