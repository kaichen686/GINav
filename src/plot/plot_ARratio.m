function plot_ARratio(solution)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nsol=size(solution,1);
if nsol==0
    error('Solution is empty!!!\n');
end

ratio=zeros(nsol,1); stat=zeros(nsol,1); time=zeros(nsol,1); j=0;
for i=1:nsol
    if dot(solution(i).pos,solution(i).pos)<=0
        continue;
    end
    [~,sow]=time2gpst(solution(i).time);
    time(j+1)=sow;
    ratio(j+1,:)=solution(i).ratio;
    stat(j+1,:)=solution(i).stat;
    j=j+1; 
end

if j==0
    error('Solution is empty!!!\n');
end

if j<nsol
    time(j+1:end,:)=[];
    ratio(j+1:end,:)=[];
    stat(j+1:end,:)=[];
end

nt=size(time,1); k=0; tt=zeros(nt,1);
if nt==1
    n_all=1;
else
    tspan=time(end)-time(1);
    for i=1:nt
        if i==nt
            break;
        end
        tt(k+1,1)=time(i+1)-time(i);
        k=k+1;
    end
    tt(end,:)=[];
    dt=mode(tt);
    n_all=tspan/dt+1;
end

%% plot
H=get(0,'ScreenSize'); w=600; h=450; x=H(3)/2-w/2; y=H(4)/2-h/2; 
figure;set(gcf,'Position',[x y w h]);
plot(time,ratio,'.b','linewidth',2,'Markersize',10);hold on
plot(time,repmat(3,j,1),'.m','linewidth',2,'Markersize',10);hold on
plot(time,ratio,':','linewidth',1,'color',[0.5,0.5,0.5]);
grid on ;set(gca,'GridLineStyle',':','GridColor','k','GridAlpha',0.5);
xlabel('GPS Time (s)'),ylabel('Ratio test value');
axis([time(1) time(end) -100 max(ratio)+100 ]);
legend('ratio test value','ratio test threshold (3.0)');

idx1=find(ratio>=3.0&stat==1);
n_fix=size(idx1,1); fix_rate=n_fix/n_all;
n_other=size(ratio,1)-n_fix; other_rate=n_other/n_all;
n_none=abs(n_all-n_fix-n_other);
none_rate=abs(1-fix_rate-other_rate);
str1=[sprintf('Fix:%d (%.2f',n_fix,fix_rate*100),'%)'];
str2=[sprintf('Other:%d (%.2f',n_other,other_rate*100),'%)'];
str3=[sprintf('None:%d (%.2f',n_none,none_rate*100),'%)'];
str=[str1,'  ',str2,'  ',str3];
text(time(1)+(time(end)-time(1))*0.1,-50,str);

return

