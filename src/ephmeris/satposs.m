function sv=satposs(obs,nav,ephopt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%compute satellite position,clock bias,velocity,clock drift
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input£ºobs   - observation
%       nav   - navigation message
%       ephopt- ephemeric option(0:using broadcast eph;1:using precise eph)
%output£ºsv   - space vehicle struct(record satellite position,clock bias,
%           velocity and clock drift)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%1.satellite position and clock are values at signal transmission time
%2.satellite position is referenced to antenna phase center
%3.satellite clock does not include code bias correction (tgd or bgd)
%4.any pseudorange and broadcast ephemeris are always needed to get signal 
%  transmission time
%5.only surport broadcast/precise ephemeris,not RTCM-SSR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc gls
STD_BRDCCLK =30.0; time0=obs(1).time;
nobs=size(obs,1); % number of observation
sv=repmat(gls.sv,nobs,1);

for i=1:nobs 
    
    for j=1:glc.NFREQ
        pr=obs(i).P(j);
        if pr~=0,break;end      
    end 
    if pr==0,continue;end
    
    time=timeadd(time0,-pr/glc.CLIGHT); %raw single transition time
    
    [dts,stat1]=ephclk(time,obs(i),nav);
    if stat1==0,continue;end
    
    time=timeadd(time,-dts); %signal transition time
    
    [sv(i),stat2]=satpos(time,obs(i),nav,ephopt,sv(i));
    if stat2==0,continue;end
    
    if sv(i).dts==0
        [dts,stat1]=ephclk(time,obs(i),nav);
        if stat1==0,continue;end
        sv(i).dtsd=dts; sv(i).dtsd=0; 
        sv(i).vars=STD_BRDCCLK^2;
    end
    
end

return

