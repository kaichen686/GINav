function [rtk,sat_,stat]=estpos(rtk,obs,nav,sv,opt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%estimate reciever position and clock bias
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global  glc
NX=3+glc.NSYS; MAXITER=10; iter=1;
time=obs(1).time; xr0=[rtk.sol.pos';zeros(glc.NSYS,1)];

while iter<=MAXITER
    
    % compute residual,measurement model,weight matrix
    [v,H,P,vsat,azel,resp,nv,ns]=rescode(iter,obs,nav,sv,xr0,opt);
    sat_.vsat=vsat; 
    sat_.azel=azel;
    sat_.resp=resp;
    
    if nv<NX, stat=0;return;end
    
    % least square algrithm
    [dx,Q]=least_square(v,H,P);
    
    xr0=xr0+dx;
    iter=iter+1;
    
    if dot(dx,dx)<1e-4
        rtk.sol.time=timeadd(obs(1).time,-xr0(4)/glc.CLIGHT);
        rtk.sol.ns  =ns;
        rtk.sol.ratio=0;
        rtk.sol.pos =xr0(1:3)';
        rtk.sol.vel =zeros(1,3);
        rtk.sol.posP(1)=Q(1,1);rtk.sol.posP(2)=Q(2,2);rtk.sol.posP(3)=Q(3,3);
        rtk.sol.posP(4)=Q(1,2);rtk.sol.posP(5)=Q(2,3);rtk.sol.posP(6)=Q(1,3);
        rtk.sol.dtr(1) =xr0(4)/glc.CLIGHT;
        rtk.sol.dtr(2) =xr0(5)/glc.CLIGHT;
        rtk.sol.dtr(3) =xr0(6)/glc.CLIGHT;
        rtk.sol.dtr(4) =xr0(7)/glc.CLIGHT;
        rtk.sol.dtr(5) =xr0(8)/glc.CLIGHT;
          
        % validate solution
        stat=valsol(time,v,P,vsat,azel,opt);
        if stat==1
            rtk.sol.stat=glc.SOLQ_SPP; return;
        end
        return;
    end  
    
end

if iter>MAXITER
    stat=0;
    [week,sow]=time2gpst(time);
    fprintf('Warning:GPS week = %d sow = %.3f,SPP iteration divergent!\n',week,sow);
    return;
end

return



