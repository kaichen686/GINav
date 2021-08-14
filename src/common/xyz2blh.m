function [blh, Cne] = xyz2blh(xyz)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert cartesian coordinate xyz to geodetic coordinate blh
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos=ecef2pos(xyz); blh=pos;
B=pos(1); L=pos(2);
sinB = sin(B); cosB = cos(B);
sinL = sin(L); cosL = cos(L);

if nargout==2
    % transformation matrix from e-frame to n-frame
    Cne = [   -sinL,      cosL,        0;
        -sinB*cosL, -sinB*sinL, cosB;
        cosB*cosL,  cosB*sinL, sinB ];
end
     
return