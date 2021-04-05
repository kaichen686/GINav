function eth=earth_update(pos,vel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% update the earth parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% earth constant
eth.Re = 6378137;                    
eth.f  = 1/298.257223563;            
eth.Rp = (1-eth.f)*eth.Re;           
eth.e1 = sqrt(eth.Re^2-eth.Rp^2)/eth.Re;
eth.e2 = sqrt(eth.Re^2-eth.Rp^2)/eth.Rp; 
eth.wie = 7.2921151467e-5;           
eth.g0 = 9.7803267714;             

% update earth related parameters
B = pos(1); L = pos(2); h = pos(3); %#ok
ve = vel(1); vn = vel(2); vu = vel(3); %#ok
eth.RN = eth.Re/sqrt(1-eth.e1^2*sin(B)^2);           
eth.RM = eth.RN*(1-eth.e1^2)/(1-eth.e1^2*sin(B)^2); 
eth.Mpv2 = sec(B)/(eth.RN+h);
eth.Mpv4 = 1/(eth.RM+h);
eth.RNh  = eth.RN+h;
eth.RMh  = eth.RM+h;
eth.tanL = tan(B);
eth.secL = sec(B);
eth.sinL = sin(B);
eth.cosL = cos(B);
eth.sin2L= sin(2*B);
eth.cos2L= cos(2*B);

% earth rotation rate projected in the n-frame
eth.wnie = [0; eth.wie*cos(B); eth.wie*sin(B)];

% the rate of n-frame respect to e-fame projected in the n-frame
eth.wnen = [-vn/(eth.RM+h); ve/(eth.RN+h); ve/(eth.RN+h)*tan(B)];

% the rate of n-frame respect to i-fame projected in the n-frame
eth.wnin = eth.wnie + eth.wnen;

% earth gravity vector projected in the n-frame
eth.g  = eth.g0*(1+5.27094e-3*sin(B)^2+2.32718e-5*sin(B)^4)-3.086e-6*h; 
eth.gn = [0; 0; -eth.g];

% gcc:gravitational acceleration/coriolis acceleration/centripetal acceleration
eth.wnien = 2*eth.wnie + eth.wnen;
eth.gcc = -cross(eth.wnien,vel)+eth.gn;

return

