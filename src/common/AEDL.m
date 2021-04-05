function [AzEl, D ,LOS] = AEDL(Xr, Xs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% calculate the Azimth,Elevation,Distance,Light Of Sight
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Omegae_dot = 7.2921151467e-05;  
V_LIGHT=299792458; 

%line of sight from satellite to reciever(LOS)
D=sqrt(sum((Xs-Xr).^2 ,1));
LOS=((Xs-Xr)./D)';

%distance from reciever to satellite with sagnac effect correction
sagnac=Omegae_dot/V_LIGHT*(Xs(1)*Xr(2)-Xs(2)*Xr(1));
D=D+sagnac;

pos=ecef2pos(Xr);
if pos(3)>-6378137
    [~,Cne]=xyz2blh(Xr);
    enu=Cne*(Xs-Xr);  
    E = enu(1);
    N = enu(2);
    U = enu(3);
    hor_dis = sqrt(E.^2 + N.^2);
    
    if hor_dis < 1.e-20
        %azimuth 
        Az = 0;
        %elevation 
        El = 90;
    else
        %azimuth
        Az = atan2(E,N)/pi*180;
        %elevation
        El = atan2(U,hor_dis)/pi*180;
    end
    idx = find(Az < 0);
    Az(idx) = Az(idx)+360;
    AzEl=[Az,El]*pi/180;
else
    Az=0; El=90;
    AzEl=[Az,El]*pi/180;
end

