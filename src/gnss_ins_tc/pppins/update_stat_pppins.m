function rtk=update_stat_pppins(rtk,obs,sol_stat)

global glc
opt=rtk.opt;
nobs=size(obs,1);

rtk.sol.time=obs(1).time;
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

if rtk.sol.ns<3 %note ns!!!
    rtk.sol.stat=0;
else
    rtk.sol.stat=sol_stat;
end


if rtk.sol.stat==glc.SOLQ_FIX
    
else
    x=rtk.ins.x; P=rtk.ins.P;
    [rr,Cen]=blh2xyz(x(7:9)); T=Dblh2Dxyz(x(7:9));
    rtk.sol.pos=rr';
    rtk.sol.vel=(Cen*x(4:6))';
    rtk.sol.att=x(1:3)'/glc.D2R;
    
    if rtk.sol.att(3)>=0
        rtk.sol.att(3)=360-rtk.sol.att(3);
    else
        rtk.sol.att(3)=-rtk.sol.att(3);
    end
    
    posvar=P(7:9,7:9); posvar=T*posvar*T';        %blh_var to xyz_var
    velvar=P(4:6,4:6); velvar=Cen*velvar*Cen';    %enu_var to xyz_var
    attvar=P(1:3,1:3); attvar=attvar./glc.D2R^2;  %rad_var to deg_var
    
    rtk.sol.posP(1)=posvar(1,1);
    rtk.sol.posP(2)=posvar(2,2);
    rtk.sol.posP(3)=posvar(3,3);
    rtk.sol.posP(4)=posvar(1,2);
    rtk.sol.posP(5)=posvar(2,3);
    rtk.sol.posP(6)=posvar(1,3);
    
    rtk.sol.velP(1)=velvar(1,1);
    rtk.sol.velP(2)=velvar(2,2);
    rtk.sol.velP(3)=velvar(3,3);
    rtk.sol.velP(4)=velvar(1,2);
    rtk.sol.velP(5)=velvar(2,3);
    rtk.sol.velP(6)=velvar(1,3);
    
    rtk.sol.attP(1)=attvar(1,1);
    rtk.sol.attP(2)=attvar(2,2);
    rtk.sol.attP(3)=attvar(3,3);
    rtk.sol.attP(4)=attvar(1,2);
    rtk.sol.attP(5)=attvar(2,3);
    rtk.sol.attP(6)=attvar(1,3);
end

% update clk and isb
rtk.sol.dtr(1)=rtk.x(rtk.ic+1)/glc.CLIGHT;
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

