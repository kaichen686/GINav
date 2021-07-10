function plot_ppp_err(solution,stationname,snxfilename)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos_ref0=readsnx(stationname,snxfilename);
if norm(pos_ref0)==0
    fprintf('Warning:have no ground truth for %s station!\n',stationname);
    return
end

nsol=size(solution,1); 
if nsol==0
    error('Solution is empty!!!\n');
end

n=0; pos=zeros(nsol,3); time=zeros(nsol,1); UTC=zeros(nsol,6);
pos_mea=zeros(nsol,3); pos_ref=zeros(nsol,3);

for i=1:nsol
    if solution(i).time.time==0,continue;end
    ep=time2epoch(solution(i).time);
    UTC(n+1,:)=[ep(1),ep(2),ep(3),ep(4),ep(5),ep(6)];
    pos(n+1,:)=solution(i).pos;
    n=n+1;
end

[~,Cne]=xyz2blh(pos_ref0);

j=0;
for i=1:n
    if dot(pos(i,1:3),pos(i,1:3))<=0
        continue;
    end
    time(j+1,:)=UTC(i,4)*3600+UTC(i,5)*60+UTC(i,6);
    pos_mea(j+1,:)=Cne*pos(i,1:3)';
    pos_ref(j+1,:)=Cne*pos_ref0';
    j=j+1;
end

if j==0
    error('Solution is empty!!!\n');
end

if j<nsol
    time(j+1:end,:)=[];
    pos_mea(j+1:end,:)=[];
    pos_ref(j+1:end,:)=[];
end

%% plot
H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
figure;set(gcf,'Position',[x y w h]);
delta=pos_mea(:,1:3)-pos_ref(:,1:3);
time=time/3600;
plot(time,delta(:,1),'.r-');hold on;
plot(time,delta(:,2),'.g-');hold on;
plot(time,delta(:,3),'.b-');hold on;

grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('Time (h)'),ylabel('Error (m)');
axis([time(1) time(end)+1 -inf inf]);
set(gca,'Xtick',time(1):2:time(end)+1);

str1=sprintf('E RMS: %.4fm ', sqrt(sum(delta(:,1).^2)/size(delta,1)));
str2=sprintf('N RMS: %.4fm ', sqrt(sum(delta(:,2).^2)/size(delta,1)));
str3=sprintf('U RMS: %.4fm ', sqrt(sum(delta(:,3).^2)/size(delta,1)));
legend(str1,str2,str3,'Location','Best');

str4=sprintf('%4d/%2d/%2d\nStation:%s',UTC(1,1),UTC(1,2),UTC(1,3),stationname); 
x=time(1)+1;
ymin=min(delta);ymin=min(ymin);
ymax=max(delta);ymax=min(ymax);
y=ymin+0.2*(ymax-ymin);
text(x,y,str4);

return

