function frq=get_glo_fcn(sat,nav)

global glc
frq=-100;

[sys,~]=satsys(sat);

if sys~=glc.SYS_GLO,return;end
idx=nav.geph(:,1)==sat;
if any(idx)
    eph=nav.geph(idx,:);
    frq=eph(1,3);
end

return