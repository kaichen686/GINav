function rtk=estvel(rtk,obs,nav,sv,opt,sat_) %#ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%estimate reciever velocity and clock drift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MAXITER=10; iter=1; x=zeros(4,1); rtk.sol.dtrd=0;

while iter<=MAXITER
    
    % residual,measurement model,weight matrix
    [v,H,P,nv]=resdop(rtk,obs,nav,sv,sat_,x);
    if nv<4,break;end
    
    % least square
    [dx,~]=least_square(v,H,P);
    x=x+dx;
    
    if dot(dx,dx)<10^-4
        rtk.sol.vel=x(1:3)';
        rtk.sol.dtrd=x(4);
        break;
    end
    iter=iter+1;
    
end

return