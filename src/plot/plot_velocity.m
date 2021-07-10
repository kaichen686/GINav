function plot_velocity(solution)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nsol=size(solution,1);
if nsol==0
    error('Solution is empty!!!\n');
end

n=0; vel=zeros(nsol,3); vel0=zeros(nsol,3); time=zeros(nsol,1);
for i=1:nsol
    [~,sow]=time2gpst(solution(i).time);
    time(n+1)=sow;
    
    vel(n+1,:)=solution(i).vel;
    n=n+1;
end

[~,Cne]=xyz2blh(solution(1).pos);

j=0;
for i=1:n
    if dot(vel(i,1:3),vel(i,1:3))<=0
        continue;
    end
    vel0(j+1,:)=Cne*vel(i,1:3)';
    j=j+1;
end

if j==0
    error('Solution is empty!!!\n');
end

if j<nsol
    time(j+1:end,:)=[];
    vel0(j+1:end,:)=[];
end

%% plot
H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
figure;set(gcf,'Position',[x y w h]);

subplot(3,1,1);
plot(time,vel0(:,1),'.b-');hold on;
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('GPS Time (s)'),ylabel('East (m/s)');
title('Velocity');

subplot(3,1,2);
plot(time,vel0(:,2),'.b-');hold on;
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('GPS Time (s)'),ylabel('North (m/s)');

subplot(3,1,3);
plot(time,vel0(:,3),'.b-');hold on;
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5); 
xlabel('GPS Time (s)'),ylabel('Up (m/s)');

return

