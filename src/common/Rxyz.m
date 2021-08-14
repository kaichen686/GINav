function R=Rxyz(t,flag)

if flag==1
    R=[1       0         0;
       0     cos(t)   -sin(t);
       0     sin(t)    cos(t)]';
elseif flag==2
     R=[cos(t)       0         sin(t);
           0         1           0;
       -sin(t)       0         cos(t)]';
elseif flag==3
    R=[   cos(t)      -sin(t)       0;
          sin(t)       cos(t)       0;
           0            0           1]';
end

return;