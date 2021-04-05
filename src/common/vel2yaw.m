function yaw=vel2yaw(vel)

if abs(vel(1))<1e-4
    vel(1)=1e-4;
end

yaw=-atan2(vel(1),vel(2));

return


