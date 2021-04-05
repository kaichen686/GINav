function [T, Dxyz] = Dblh2Dxyz(blh, Dblh)
% Convert perturbation error from n-frame to e-frame

global glc

B = blh(1); L = blh(2); H = blh(3);
sinB = sin(B); cosB = cos(B); sinL = sin(L); cosL = cos(L);
N = glc.RE_WGS84/sqrt(1-glc.ECC_WGS84^2*sinB^2); NH = N+H;
e2=glc.ECC_WGS84^2;
T = [  -NH*sinB*cosL,         -NH*cosB*sinL,  cosB*cosL;
    -NH*sinB*sinL,          NH*cosB*cosL,  cosB*sinL;
    (NH-e2*N)*cosB,                     0,       sinB ];
  
if nargin==2
    Dxyz = T*Dblh;
end

return