function printv(v)

n=size(v,1);
fprintf('v     =\n');
for i=1:n
    fprintf('%11.6f',v(i));
    fprintf('\n');
end
fprintf('nv=%d\n',n);

return