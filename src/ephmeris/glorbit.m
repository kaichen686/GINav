function x=glorbit(t,x,acc)

w=zeros(6,1);
k1=deq(x,acc);
for i=1:6
    w(i)=x(i)+k1(i)*t/2;
end
k2=deq(w,acc);
for i=1:6
    w(i)=x(i)+k2(i)*t/2;
end
k3=deq(w,acc);
for i=1:6
    w(i)=x(i)+k3(i)*t;
end
k4=deq(w,acc);
for i=1:6
    x(i)=x(i)+(k1(i)+2*k2(i)+2*k3(i)+k4(i))*t/6;
end

return