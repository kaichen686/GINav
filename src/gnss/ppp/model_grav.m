function dgrav=model_grav(sys,rr,rs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%obtains the gravitational delay correction for the effect of general 
%relativity (red shift) to the GPS signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
dgrav=0;

if norm(rr)<=0||norm(rs)<=0,return;end

rec_module=sqrt(rr(1)^2+rr(2)^2+rr(3)^2);
sat_module=sqrt(rs(1)^2+rs(2)^2+rs(3)^2);
distance  =norm(rr-rs);

switch sys
    case glc.SYS_GLO,MU=glc.MU_GLO;
    case glc.SYS_GAL,MU=glc.MU_GAL;
    case glc.SYS_BDS,MU=glc.MU_BDS;
    otherwise,       MU=glc.MU_GPS;
end

dgrav=2*MU/glc.CLIGHT^2*log((rec_module+sat_module+distance)/(rec_module+sat_module-distance));

return

