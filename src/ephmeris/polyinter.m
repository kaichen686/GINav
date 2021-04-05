function out=polyinter(x,y)

n=size(x,1);

for j=1:n-1
    for i=0:n-j-1
        y(i+1)=(x(i+j+1)*y(i+1)-x(i+1)*y(i+1+1))/(x(i+j+1)-x(i+1));
    end 
end

out=y(1);

return