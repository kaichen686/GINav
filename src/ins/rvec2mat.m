function mat=rvec2mat(vec)
% convert rotation vector to transformation matrix

theta=sqrt(vec'*vec);
mat=eye(3)+(sin(theta)/theta*askew(vec))+...
     ((1-cos(theta))/theta^2*(askew(vec))^2);

return