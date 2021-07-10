function plot_trajectory(solution)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nsol=size(solution,1);
if nsol==0
    error('Solution is empty!!!\n');
end

n=0; pos=zeros(nsol,3); pos0=zeros(nsol,3); 
for i=1:nsol
    pos(n+1,:)=solution(i).pos;
    n=n+1;
end

[~,Cne]=xyz2blh(pos(1,1:3));

j=0;
for i=1:n
    if dot(pos(i,1:3),pos(i,1:3))<=0
        continue;
    end
    pos0(j+1,:)=Cne*pos(i,1:3)';
    j=j+1;
end

if j==0
    error('Solution is empty!!!\n');
end

if j<nsol
    pos0(j+1:end,:)=[];
end

%% plot 
H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
figure;set(gcf,'Position',[x y w h]);
plot(pos0(:,1)-pos0(1,1), pos0(:,2)-pos0(1,2),':','linewidth',1,'color',[0.5,0.5,0.5]); hold on;
plot(pos0(:,1)-pos0(1,1), pos0(:,2)-pos0(1,2),'.b');
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5); 
xlabel('EAST (m)'),ylabel('NORTH (m)');title('Trajectory');
axis equal;

return
