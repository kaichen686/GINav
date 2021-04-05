function rtk=rtkins_feedback(rtk,x_fb,flag)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Closed-loop INS correction
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ins=rtk.ins; 

if flag==1
    ins.Cnb = (eye(3)+askew(x_fb(1:3)))*ins.Cnb;
    ins.att = Cnb2att(ins.Cnb);
    ins.vel = ins.vel-x_fb(4:6);
    ins.pos = ins.pos-x_fb(7:9);
    ins.bg  = ins.bg+x_fb(10:12);
    ins.ba  = ins.ba+x_fb(13:15);
    ins.x = [ins.att;ins.vel;ins.pos;ins.bg;ins.ba];
    ins.P = rtk.P(1:15,1:15);    
elseif flag==2
    Cnb = (eye(3)+askew(x_fb(1:3)))*ins.Cnb;
    ins.xa(1:3) = Cnb2att(Cnb);
    ins.xa(4:6) = ins.vel-x_fb(4:6);
    ins.xa(7:9) = ins.pos-x_fb(7:9);
    ins.xa(10:12)  = ins.bg+x_fb(10:12);
    ins.xa(13:15)  = ins.ba+x_fb(13:15);
    ins.Pa = rtk.Pa(1:15,1:15);  
end

rtk=rmfield(rtk,'ins');
rtk.ins=ins;

return

