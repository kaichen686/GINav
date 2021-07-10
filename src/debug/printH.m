function printH(H)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=size(H,1);
m=size(H,2);
fprintf('H     =');
fprintf('\n');

for i=1:n
    for j=1:m
        if H(i,j)==0,continue;end
        fprintf('%10.5f',H(i,j));
    end
    fprintf('\n');
end

return;

