function dop = dops(azel)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compute diluion of precision
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
az=azel(:,1); el=azel(:,2);
H=[cos(el).*sin(az),cos(el).*cos(az),sin(el),ones(size(az,1),1)];
Q=(H'*H)^-1;

dop(1)=sqrt(Q(1,1)+Q(2,2)+Q(3,3)+Q(4,4)); %GDOP
dop(2)=sqrt(Q(1,1)+Q(2,2)+Q(3,3));%PDOP
dop(3)=sqrt(Q(1,1)+Q(2,2));%HDOP
dop(4)=sqrt(Q(3,3));%VDOP

return;