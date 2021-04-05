function rtk=udamb_pppins(rtk,obs,nav)

global glc 
clk_jump=0; dantr=zeros(3,1);dants=zeros(3,1);phw=0; 
nobs=size(obs,1); MAXSAT=glc.MAXSAT; VAR_BIAS=60^2;

% handle day-boundary clock jump 
if rtk.opt.posopt(6)==1
    [~,sow]=time2gpst(obs(1).time);
    tmp=fix(floor(sow*10+0.5));
    if rem(tmp,864000)==0,clk_jump=1;end
end

for i=1:glc.MAXSAT
    for j=1:rtk.opt.nf
        rtk.sat(i).slip(j)=0;
    end
end
	
% detect cycle slip by LLI
rtk=detslip_LLI_ppp(rtk,obs);

% detect cycle slip by geometry-free phase jump
rtk=detslip_gf_ppp(rtk,obs,nav);

% detect slip by Melbourne-Wubbena linear combination jump
rtk=detslip_mw_ppp(rtk,obs,nav);

% INS-aid cycle slip detection (TDCP/INS method)
if rtk.opt.ins.aid(1)==1
    if rtk.opt.ionoopt==glc.IONOOPT_IFLC,nff=2;else,nff=rtk.opt.nf;end
    for ff=1:nff
        rtk=detslip_tdcp(rtk,obs,rtk.ins.oldobsr,nav,ff);
    end
end

% update the state and its covariance matrix
if rtk.opt.ionoopt==glc.IONOOPT_IFLC,nf=1;else,nf=rtk.opt.nf;end
for f=1:nf
    
    % reset ambiguity if instantaneous AR mode or expire obs outage counter
    for i=1:glc.MAXSAT
        rtk.sat(i).outc(f)=rtk.sat(i).outc(f)+1;
        if rtk.sat(i).outc(f)>rtk.opt.maxout||rtk.opt.modear==glc.ARMODE_INST||clk_jump==1
            rtk.x(rtk.ib+(f-1)*MAXSAT+i)=0;
            rtk.P(rtk.ib+(f-1)*MAXSAT+i,:)=0;
            rtk.P(:,rtk.ib+(f-1)*MAXSAT+i)=0;
            %rtk=initx(rtk,0,0,rtk.ib+(f-1)*MAXSAT+i);
        end
    end
    
    % estimate approximate ambiguity by code and phase comparison method
    k=0;offset=0;bias=zeros(nobs,1);slip=zeros(nobs,1);
    for i=1:nobs
        sat=obs(i).sat;
        j=rtk.ib+(f-1)*MAXSAT+sat;
        [L,P,Lc,Pc]=corr_meas(rtk,obs(i),nav,dantr,dants,phw);
        bias(i)=0;
        if rtk.opt.ionoopt==glc.IONOOPT_IFLC
            bias(i)=Lc-Pc;
            slip(i)=(rtk.sat(sat).slip(1)||rtk.sat(sat).slip(2)); 
        elseif L(f)~=0&&P(f)~=0
            slip(i)=rtk.sat(sat).slip(f);
            [sys,~]=satsys(obs(i).sat);%#ok
            %if sys==glc.SYS_GAL,kk=3;else,kk=2;end
            kk=2;
            lam=nav.lam(sat,:);
            if obs(i).P(1)==0||obs(i).P(kk)==0||lam(1)==0||lam(kk)==0||lam(f)==0, continue;end
            ion=(obs(i).P(1)-obs(i).P(kk))/(1-(lam(kk)/lam(1))^2);
            bias(i)=L(f)-P(f)+2*ion*(lam(f)/lam(1))^2;
        end
        if rtk.x(j)==0||slip(i)||bias(i)==0,continue;end
        offset=offset+(bias(i)-rtk.x(j));
        k=k+1;
    end
    
    % correct phase-bias offset to enssure phase-code coherency
    if k>=2&&abs(offset/k)>0.0005*glc.CLIGHT
        for i=1:MAXSAT
            j=rtk.ib+(f-1)*MAXSAT+i;
            if rtk.x(j)~=0
                rtk.x(j)=rtk.x(j)+offset/k;
            end
        end
    end
    
    for i=1:nobs
        sat=obs(i).sat;
        j=rtk.ib+(f-1)*MAXSAT+sat;
        rtk.P(j,j)=rtk.P(j,j)+rtk.opt.prn(1)^2*abs(rtk.tt);
        if bias(i)==0||(rtk.x(j)~=0&&~slip(i)),continue;end
        
        % reinitialize ambiguity if detecting cycle slip
        rtk=initx(rtk,bias(i),VAR_BIAS,j);
        
    end
    
end

return


