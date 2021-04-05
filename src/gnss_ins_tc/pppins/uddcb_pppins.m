function rtk=uddcb_pppins(rtk)

VAR_DCB=30^2;
idx=rtk.id+1;

if rtk.x(idx)==0
    rtk=initx(rtk,1e-6,VAR_DCB,idx);
end

return