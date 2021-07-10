function printPa(P,rtk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fprintf('P     =');
fprintf('\n');
np=0;
for i=1:rtk.na
    if P(i,i)==0,continue;end
    fprintf('       %11.6f',P(i,i));
    fprintf('\n');
    np=np+1;
end
fprintf('nP=%d',np);
fprintf('\n');

return