function [sv,stat]=peph2pos(time,sat,nav,opt,sv)

global glc
stat=1; tt=0.001;

if sat<=0||glc.MAXSAT<sat, stat=0;return; end

%calculate satellite position and clock bias
[pos,dts,vare,varc,stat1]=pephpos(time,sat,nav); 
if stat1==0,stat=0;return;end
[dts,varc,stat2]=pephclk(time,sat,nav,dts,varc);
if stat2==0,stat=0;return;end

time_ss=timeadd(time,tt);
[pos1,dts1,~,~,stat1]=pephpos(time_ss,sat,nav);
if stat1==0,stat=0;return;end
[dts1,~,stat2]=pephclk(time_ss,sat,nav,dts1,0);
if stat2==0,stat=0;return;end

%antenna phase offset correction
dant=zeros(3,1);
if opt==1 && isfield(nav,'pcvs')
    dant=satantoff(time,pos,sat,nav);
end

%calculate satellite velocity and clock drift
vel=(pos1-pos)/tt;

%relativistic effect correction
if dts~=0
    dtsd=(dts1-dts)/tt;
    dts=dts-2*dot(pos,vel)/glc.CLIGHT/glc.CLIGHT;
else
    dts=0; dtsd=0;
end

vars=vare+varc;

sv.pos=pos+dant; sv.vel=vel; 
sv.dts=dts;      sv.dtsd=dtsd;
sv.vars=vars;    sv.svh=0;

return

