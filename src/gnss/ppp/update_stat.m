function rtk=update_stat(rtk,obs,sol_stat)

global glc
opt=rtk.opt;
nobs=size(obs,1);

rtk.sol.time=timeadd(obs(1).time,-rtk.x(rtk.ic+1)/glc.CLIGHT);
rtk.sol.ns=0;
for i=1:nobs
    for j=1:opt.nf
        sat=obs(i).sat;
        if rtk.sat(sat).vsat(j)==0,continue;end
        rtk.sat(sat).lock(j)=rtk.sat(sat).lock(j)+1;
        rtk.sat(sat).outc(j)=0;
        if j==1,rtk.sol.ns=rtk.sol.ns+1;end
    end
end

if rtk.sol.ns<4
    rtk.sol.stat=0;
else
    rtk.sol.stat=sol_stat;
end

if rtk.sol.stat==glc.SOLQ_FIX
    
else
    rtk.sol.pos=rtk.x(1:3)';
    rtk.sol.posP(1)=rtk.P(1,1);
    rtk.sol.posP(2)=rtk.P(2,2);
    rtk.sol.posP(3)=rtk.P(3,3);
    rtk.sol.posP(4)=rtk.P(1,2);
    rtk.sol.posP(5)=rtk.P(2,3);
    rtk.sol.posP(6)=rtk.P(1,3);
end

% clk
rtk.sol.dtr(1)=rtk.x(rtk.ic+1)/glc.CLIGHT;
% isb
rtk.sol.dtr(2)=rtk.x(rtk.ic+2)/glc.CLIGHT;
rtk.sol.dtr(3)=rtk.x(rtk.ic+3)/glc.CLIGHT;
rtk.sol.dtr(4)=rtk.x(rtk.ic+4)/glc.CLIGHT;
rtk.sol.dtr(5)=rtk.x(rtk.ic+5)/glc.CLIGHT;

for i=1:nobs
    for j=1:rtk.opt.nf
        rtk.sat(obs(i).sat).snr(j)=obs(i).S(j);
    end
end

for i=1:glc.MAXSAT
    for j=1:rtk.opt.nf
        if bitand(rtk.sat(i).slip(j),3)
            rtk.sat(i).slip(j)=rtk.sat(sat).slip(j)+1;
        end
        if rtk.sat(i).fix(j)==2&&sol_stat~=glc.SOLQ_FIX
            rtk.sat(i).fix(j)=1;
        end
    end
end

return

