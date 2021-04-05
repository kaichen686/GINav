function xdot=deq(x,acc)

RE_GLO   =6378136.0;
MU_GLO   =3.9860044E14;
OMGE_GLO =7.292115E-5;
J2_GLO   =1.0826257E-3; 

r2=dot(x,x); r3=r2*sqrt(r2); omg2=OMGE_GLO^2;

if r2<=0
    xdot=zeros(6,1); return;
end

a=1.5*J2_GLO*MU_GLO*RE_GLO^2/r2/r3;    %3/2*J2*mu*Ae^2/r^5 
b=5.0*x(3)*x(3)/r2;                    %5*z^2/r^2 */
c=-MU_GLO/r3-a*(1.0-b);                %-mu/r^3-a(1-b)
xdot(1)=x(4); xdot(2)=x(5); xdot(3)=x(6);
xdot(4)=(c+omg2)*x(1)+2*OMGE_GLO*x(5)+acc(1);
xdot(5)=(c+omg2)*x(2)-2*OMGE_GLO*x(4)+acc(2);
xdot(6)=(c-2*a)*x(3)+acc(3);

return

