function rtk=udstate_rtkins(rtk,obsr,obsb,nav,ind)

global glc
tt=rtk.tt;

% update the position/velocity/attitude
rtk=udpos_rtkins(rtk,tt);

% update ionosphereic parameter
if rtk.opt.ionoopt==glc.IONOOPT_EST
    roverpos=blh2xyz(rtk.x(7:9))';
    bl=norm(roverpos-rtk.basepos);
    rtk=udion_rtkins(rtk,tt,bl,ind);
end

% update tropspheric parameter
if rtk.opt.tropopt>=glc.TROPOPT_EST
    rtk=udtrop_rtkins(rtk,tt,bl);
end

% update reciever inter-frequency bias for glonass
if rtk.opt.glomodear==2&&rtk.mask(2)==1
    rtk=udrcvbias_rtkins(rtk,tt);
end

% update the ambiguity
if rtk.opt.mode>glc.PMODE_DGNSS
    rtk=udbias_rtkins(rtk,obsr,obsb,nav,ind);
end

return

