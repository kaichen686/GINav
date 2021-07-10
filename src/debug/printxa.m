function printxa(x,rtk)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
opt=rtk.opt; nf=rtk.NF; %#ok

fprintf('pos   = ');fprintf('%14.5f %14.5f %14.5f',x(1),x(2),x(3));fprintf('\n');

if rtk.NP==9
    fprintf('vel   = ');fprintf('%9.5f%9.5f%9.5f',x(4),x(5),x(6));fprintf('\n');
    fprintf('acc   = ');fprintf('%9.5f%9.5f%9.5f',x(7),x(8),x(9));fprintf('\n');
end

if rtk.NI>0
    fprintf('iono  = ');
    for i=1:glc.MAXSAT
        if abs(x(rtk.ii+i))>=1e-6,fprintf('%9.5f',x(rtk.ii+i));end
    end
    fprintf('\n');
end

if rtk.NT>0
    fprintf('trop  = ');
    if opt.tropopt==glc.TROPOPT_EST
        fprintf('%9.5f',x(rtk.itr+1));
        fprintf('%9.5f',x(rtk.itb+1));
    else
        fprintf('%9.5f',x(rtk.itr+1));
        fprintf('%9.5f',x(rtk.itr+2));
        fprintf('%9.5f',x(rtk.itr+3));
        fprintf('%9.5f',x(rtk.itb+1));
        fprintf('%9.5f',x(rtk.itb+2));
        fprintf('%9.5f',x(rtk.itb+3));
    end
    fprintf('\n');
end

if rtk.NL>0
    fprintf('glo   = ');
    fprintf('%9.5f',x(rtk.il+1)); fprintf('%9.5f',x(rtk.il+2));
    fprintf('\n');
end

return

