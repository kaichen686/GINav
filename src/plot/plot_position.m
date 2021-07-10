function plot_position(solution)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nsol=size(solution,1);
if nsol==0
    error('Solution is empty!!!\n');
end

pos=zeros(nsol,3); pos0=zeros(nsol,3); time=zeros(nsol,1);
n=0;
for i=1:nsol
    [~,sow]=time2gpst(solution(i).time);
    time(n+1)=sow;
    pos(n+1,:)=solution(i).pos;
    n=n+1;
end

[~,Cen]=xyz2blh(pos(1,1:3));

j=0;
for i=1:n
    if dot(pos(i,1:3),pos(i,1:3))<=0
        continue;
    end
    pos0(j+1,:)=Cen*pos(i,1:3)';
    j=j+1;
end

if j==0
    error('Solution is empty!!!\n');
end

if j<nsol
    time(j+1:end,:)=[];
    pos0(j+1:end,:)=[];
end
%% 
delta=pos0(:,1:3)-repmat(pos0(1,1:3),j,1);

H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
figure;set(gcf,'Position',[x y w h]);

subplot(3,1,1);
plot(time,delta(:,1),'.b-');hold on;
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('GPS Time (s)'),ylabel('East (m)');
title('Position');

subplot(3,1,2);
plot(time,delta(:,2),'.b-');hold on;
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('GPS Time (s)'),ylabel('North (m)');

subplot(3,1,3);
plot(time,delta(:,3),'.b-');hold on;
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5); 
xlabel('GPS Time (s)'),ylabel('Up (m)');


return
