function [xyz, Cen] = blh2xyz(blh)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Convert geodetic coordinate blh to cartesian coordinate xyz
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc

B = blh(1); L = blh(2); H = blh(3);
sinB = sin(B); cosB = cos(B); sinL = sin(L); cosL = cos(L);
N = glc.RE_WGS84/sqrt(1-glc.ECC_WGS84^2*sinB^2);
X = (N+H)*cosB*cosL;
Y = (N+H)*cosB*sinL;
Z = (N*(1-glc.ECC_WGS84^2)+H)*sinB;
xyz = [X; Y; Z];

% transformation matrix from n-frame to e-frame
if nargout==2
    Cen = [ -sinL,     cosL,    0
        -sinB*cosL, -sinB*sinL, cosB
        cosB*cosL,  cosB*sinL, sinB ]';
end

return