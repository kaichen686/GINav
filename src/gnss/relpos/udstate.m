function rtk=udstate(rtk,obsr,obsb,nav,ind)

global glc
tt=rtk.tt;

% update the position/velocity/acceleration
rtk=udpos(rtk,tt);

% update ionosphereic parameter
if rtk.opt.ionoopt==glc.IONOOPT_EST
    bl=norm(rtk.x(1:3)-rtk.basepos);
    rtk=udion(rtk,tt,bl,ind);
end

% update tropspheric parameter
if rtk.opt.tropopt>=glc.TROPOPT_EST
    rtk=udtrop(rtk,tt,bl);
end

% update reciever inter-frequency bias for glonass
if rtk.opt.glomodear==2&&rtk.mask(2)==1
    rtk=udrcvbias(rtk,tt);
end

% update the ambiguity
if rtk.opt.mode>glc.PMODE_DGNSS
    rtk=udbias(rtk,obsr,obsb,nav,ind);
end

return

