function printR(R)

n=size(R,1);
fprintf('R     =');
fprintf('\n');
for i=1:n
    fprintf('       %f',R(i,i));
    fprintf('\n');
end

return;

