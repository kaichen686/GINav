function rtk=initx(rtk,x,var,k)

rtk.x(k)=x;
rtk.P(k,:)=0; rtk.P(:,k)=0;
rtk.P(k,k)=var;

return;