function rtk=initx(rtk,x,var,k)

rtk.x(k)=x;

% for i=1:rtk.nx
%     if i==k
%         rtk.P(k,k)=var;
%         continue;
%     end
%     rtk.P(i,k)=0; rtk.P(k,i)=0;
% end

rtk.P(k,:)=0; rtk.P(:,k)=0;
rtk.P(k,k)=var;

return;