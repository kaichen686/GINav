function plot_pos_err(solution,pos_ref)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nsol=size(solution,1);
if nsol==0
    error('Solution is empty!!!\n');
end

n=0; pos_mea=zeros(nsol,5); time=zeros(nsol,1);
for i=1:nsol
    [week,sow]=time2gpst(solution(i).time);
    time(n+1)=sow;
    pos_mea(n+1,:)=[week,sow,solution(i).pos];
    n=n+1;
end

[~,Cne]=xyz2blh(pos_ref(1,3:5));

n=size(pos_mea,1); j=0; 
t=zeros(n,1); pos1=zeros(n,3); pos2=zeros(n,3);
for i=1:n
    if dot(pos_mea(i,1:3),pos_mea(i,1:3))<=0
        continue;
    end
    time=pos_mea(i,2);
    idx=find(abs(pos_ref(:,2)-time)<0.1);
    if any(idx)
        t(j+1,:)=time;
        pos1(j+1,:)=Cne*pos_mea(i,3:5)';
        pos2(j+1,:)=Cne*pos_ref(idx,3:5)';
        j=j+1;
    end
end

if j==0
    error('Solution is empty!!!\n');
end

if j<n
    t(j+1:end,:)=[]; pos1(j+1:end,:)=[]; pos2(j+1:end,:)=[];
end

%% plot
H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
figure;set(gcf,'Position',[x y w h]);
pos_err=pos1-pos2;

subplot(3,1,1),plot(t,pos_err(:,1),'.r-'); title('Position error');
xlabel('time/s'),ylabel('EAST error(m)');grid on;
legend(sprintf('RMS: %.4fm ', sqrt(sum(pos_err(:,1).^2)/size(pos_err,1))));

subplot(3,1,2),plot(t,pos_err(:,2),'.g-');
xlabel('time/s'),ylabel('NORTH error(m)'),grid on;
legend(sprintf('RMS: %.4fm ', sqrt(sum(pos_err(:,2).^2)/size(pos_err,1))));

subplot(3,1,3),plot(t,pos_err(:,3),'.b-');
xlabel('time/s'),ylabel('Up error(m)'),grid on;
legend(sprintf('RMS: %.4fm ', sqrt(sum(pos_err(:,3).^2)/size(pos_err,1))));

return

