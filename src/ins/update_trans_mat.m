function Phi=update_trans_mat(ins)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update state transformation matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

zero33 = zeros(3);
tanL = ins.eth.tanL;   secL = ins.eth.secL;
sin2L= ins.eth.sin2L;  cos2L= ins.eth.cos2L;
RNh  = ins.eth.RNh;    RMh  = ins.eth.RMh;
vE   = ins.vel(1);     vN   = ins.vel(2);  vU   = ins.vel(3); %#ok

F1=zero33; F1(2)=-ins.eth.wnie(3); F1(3)=ins.eth.wnie(2);

F2=zero33; F2(2)=1/RNh; F2(3)=tanL/RNh; F2(4)=-1/RMh;

F3=zero33; F3(3)=vE*secL^2/RNh; F3(7)=vN/RMh^2; F3(8)=-vE/RNh^2; F3(9)=-vE*tanL/RNh^2;

x = -ins.eth.g0*sin2L*(5.27094e-3-4*2.32718e-5*cos2L); 
F4=zero33; F4(3)=x; F4(9)=3.086e-6;

% transition matrix for phi
Faa = -askew(ins.eth.wnin);     
Fav = F2;
Fap = F1+F3;
    
% transition matrix for delta-vel
Fva = askew(ins.fn);
Fvv = askew(ins.vel)*F2 - askew(ins.eth.wnien);
Fvp = askew(ins.vel)*(2*F1+F3+F4);

% transition matrix for delta-pos
Fpp = zero33; Fpp(2)=vE*secL*tanL/RNh; Fpp(7)=-vN/RMh^2; Fpp(8)= -vE*secL/RNh^2;
Fpv = ins.Mpv;    
    
% time continuous state transition matrix
Ft = [ Faa       Fav       Fap      -ins.Cnb            zero33
       Fva       Fvv       Fvp      zero33              ins.Cnb
       zero33    Fpv       Fpp      zero33              zero33
       zero33    zero33    zero33   diag(-1./ins.tauG)  zero33
       zero33    zero33    zero33   zero33              diag(-1./ins.tauA)];      

% discretization
if ins.nt>0.1
    Phi = expm(Ft*ins.nt); 
else
    Phi = eye(size(Ft))+Ft*ins.nt;
end

return

