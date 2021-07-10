function printv(v)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=size(v,1);
fprintf('v     =\n');
for i=1:n
    fprintf('%11.6f',v(i));
    fprintf('\n');
end
fprintf('nv=%d\n',n);

return