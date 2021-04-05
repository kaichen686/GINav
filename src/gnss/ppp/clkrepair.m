function  [rtk,obsr]=clkrepair(rtk,obsr,nav)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%repair receiver jump(only for GPS)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
delta0=0; delta1=0; validGPS=0; cjGPS=0; validobs=zeros(32,1);
nobs=size(obsr,1); obs_rcr=rtk.obs_rcr;

for i=1:nobs
    sat=obsr(i).sat;
    if sat>glc.MAXPRNGPS,continue;end
    lam=nav.lam(sat,:);
    
    if obsr(i).P(1)*obsr(i).P(2)*obsr(i).L(1)*obsr(i).L(2)==0,continue;end
    if obs_rcr(sat,1)*obs_rcr(sat,2)*obs_rcr(sat,3)*obs_rcr(sat,4)==0
        continue;
    end
    
    validGPS=validGPS+1;
    
    d1=obsr(i).P(1)-obs_rcr(sat,1);
    d2=obsr(i).P(2)-obs_rcr(sat,2);
    d3=(obsr(i).L(1)-obs_rcr(sat,3))*lam(1);
    d4=(obsr(i).L(2)-obs_rcr(sat,4))*lam(2);
    
    if abs(d1-d3)>290000 % ms clock jump
        delta0=delta0+(d1-d3);
        delta1=delta1+(d2-d4);
        cjGPS=cjGPS+1;
    end
end

if cjGPS~=0&&cjGPS==validGPS
    d1=delta0/cjGPS;
    d2=delta1/cjGPS; %#ok
    
%     CJ_F1=0; 
%     CJ_F2=0;
    CJ_F1=d1/glc.CLIGHT*1000;
    CJ_F2=myRound(CJ_F1);
    
    if abs(CJ_F1-CJ_F2)<2.5e-2
        rtk.clkjump=rtk.clkjump+fix(CJ_F2);
    end
end

for i=1:nobs
    sat=obsr(i).sat;
    if sat>glc.MAXPRNGPS,continue;end
    validobs(sat)=1;
    
    rtk.obs_rcr(sat,1)=obsr(i).P(1);
    rtk.obs_rcr(sat,2)=obsr(i).P(2);
    rtk.obs_rcr(sat,3)=obsr(i).L(1);
    rtk.obs_rcr(sat,4)=obsr(i).L(2);
    
    dclk1=rtk.clkjump*glc.CLIGHT/1000;
    dclk2=rtk.clkjump*glc.CLIGHT/1000;
    
    % repair phase observations
    if obsr(i).L(1)~=0,obsr(i).L(1)=obsr(i).L(1)+dclk1/lam(1);end
    if obsr(i).L(2)~=0,obsr(i).L(2)=obsr(i).L(2)+dclk2/lam(2);end   
    
end

for i=1:glc.MAXPRNGPS
    if validobs(i)==0
        rtk.obs_rcr(i,1)=0;
        rtk.obs_rcr(i,2)=0;
        rtk.obs_rcr(i,3)=0;
        rtk.obs_rcr(i,4)=0;
    end
end

return

