function att = Cnb2att(Cnb)

att=[asin(Cnb(3,2)); atan2(-Cnb(3,1),Cnb(3,3)); atan2(-Cnb(1,2),Cnb(2,2))];
    
return