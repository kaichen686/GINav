function yaw=yaw_nominal(beta,mu)

if abs(beta)<1E-12&&abs(mu)<1E-12
    yaw=pi;
    return;
end

yaw=atan2(-tan(beta),sin(mu))+pi;

return