function plot_trajectory_kine(hfig,rtk_gi) %#ok
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc
persistent pos0 Cne0 
persistent h1 h2 h3 h4 hmark

if isempty(pos0)&&isempty(Cne0)
    [~,Cne0]=xyz2blh(rtk_gi.sol.pos);
    pos0=Cne0*rtk_gi.sol.pos';
end

pos=Cne0*rtk_gi.sol.pos';
delta=pos-pos0;
plot(delta(1),delta(2),'.b-'); hold on;
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('EAST (m)');ylabel('NORTH (m)');title('Trajectory');
    
ep=time2epoch(rtk_gi.sol.time);
str_time=sprintf('UTC: %04.0f/%02.0f/%02.0f  %02.0f:%02.0f:%06.3f',...
                     ep(1),ep(2),ep(3),ep(4),ep(5),ep(6));
                 
[blh,Cne]=xyz2blh(rtk_gi.sol.pos);
str_pos=sprintf('Lat: %.8f%s  Lon: %.8f%s  Height: %.4fm ',blh(1)/glc.D2R,...
                     '\circ',blh(2)/glc.D2R,'\circ',blh(3));
                 
vel=Cne*rtk_gi.sol.vel';
str_vel=sprintf('Ve:%.4fm/s   Vn: %.4fm/s   Vu: %.4fm/s',vel(1),vel(2),vel(3));

att=rtk_gi.sol.att;
str_att=sprintf('Pitch: %.4f%s  Roll: %.4f%s  Yaw: %.4f%s',att(1),'\circ',...
                   att(2),'\circ',att(3),'\circ');

xlim=get(gca,'Xlim');xmin=xlim(1);xmax=xlim(2);dx=xmax-xmin;
ylim=get(gca,'Ylim');ymin=ylim(1);ymax=ylim(2);dy=ymax-ymin;
if isempty(h1)
    h1=text(xmin+0.1*dx,ymax-0.05*dy,str_time);
else
    set(h1,'Position',[xmin+0.1*dx,ymax-0.05*dy,0]);
    set(h1,'String',str_time);
end
if isempty(h2)
    h2=text(xmin+0.1*dx,ymax-0.10*dy,str_pos);
else
    set(h2,'Position',[xmin+0.1*dx,ymax-0.10*dy,0]);
    set(h2,'String',str_pos);
end
if isempty(h3)
    h3=text(xmin+0.1*dx,ymax-0.15*dy,str_vel);
else
    set(h3,'Position',[xmin+0.1*dx,ymax-0.15*dy,0]);
    set(h3,'String',str_vel);
end
if isempty(h4)
    h4=text(xmin+0.1*dx,ymax-0.20*dy,str_att);
else
    set(h4,'Position',[xmin+0.1*dx,ymax-0.20*dy,0]);
    set(h4,'String',str_att);
end
if isempty(hmark)
    hmark=plot(delta(1),delta(2),'or');
else
    set(hmark,'XData',delta(1),'YData',delta(2));
end

return

