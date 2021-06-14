function  obs = sortobs(obs)
global glc gls
A=zeros(obs.n,3); data1=repmat(gls.obsd,obs.n,1);

%sort obs
for i=1:obs.n
    A(i,:)=[obs.data(i).time.time,obs.data(i).time.sec,obs.data(i).sat];
end
[~,index]=sortrows(A);
for i=1:obs.n
    data1(i)=obs.data(index(i));
end

%delete duplicated data
j=1;
for i=2:obs.n
    t=timediff(data1(i).time,data1(j).time);
    if data1(i).sat~=data1(j).sat||t~=0
        j=j+1;
        data1(j)=data1(i);
    end
end

obs.n=j; data2=repmat(gls.obsd,obs.n,1);
for i=1:obs.n
    data2(i)=data1(i);
end
obs=rmfield(obs,'data'); obs.data=data2;

clearvars data1 data2

%count obs
i=1; nepoch=0; dt=0;
while i<obs.n
    for j=i+1:obs.n
        t=timediff(obs.data(j).time,obs.data(i).time);
        if t>glc.DTTOL
            dt=t; 
            break;
        end
    end
    nepoch=nepoch+1;
    i=j; 
end

obs.nepoch=nepoch;
obs.dt=dt;

return

