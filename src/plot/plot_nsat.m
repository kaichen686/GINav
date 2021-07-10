function plot_nsat(solution)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nsol=size(solution,1);
if nsol==0
    error('Solution is empty!!!\n');
end

nsat=zeros(nsol,1);
time=zeros(nsol,1);
j=0;
for i=1:nsol
    if dot(solution(i).pos,solution(i).pos)<=0
        continue;
    end
    [~,sow]=time2gpst(solution(i).time);
    time(j+1)=sow;
    
    nsat(j+1,:)=solution(i).ns;
    j=j+1;
end

if j==0
    error('Solution is empty!!!\n');
end

if j<nsol
    time(j+1:end,:)=[];
    nsat(j+1:end,:)=[];
end

%% plot
maxsat=max(nsat);
H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
figure;set(gcf,'Position',[x y w h]);
plot(time,nsat,':','linewidth',1,'color',[0.5,0.5,0.5]);hold on
plot(time,nsat,'.b','linewidth',2,'Markersize',10);
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('GPS Time (s)'),ylabel('# of satellite');
axis([time(1) time(end) 0 maxsat+5 ]);

return

