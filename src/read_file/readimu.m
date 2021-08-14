function imu=readimu(opt,fname)

global glc gls
idx=strfind(fname,glc.sep); fname0=fname(idx(end)+1:end);
fprintf('Info:reading imu file %s...',fname0);

ts=str2time(opt.ts); te=str2time(opt.te);
imu=gls.imu; ins=opt.ins;
NMAX=200000; imu.data=repmat(gls.imud,NMAX,1);
imudata=csvread(fname,1,0); n=size(imudata,1);

if ins.data_format==1
    dt=1/ins.sample_rate;
    for i=1:n
        time=gpst2time(imudata(i,1),imudata(i,2));
        if ts.time~=0&&timediff(time,ts)<0,continue;end
        if te.time~=0&&timediff(time,te)>0,continue;end
        
        if imu.n+1>size(imu.data,1)
            imu.data(imu.n+1:imu.n+NMAX)=repmat(gls.imud,NMAX,1);
        end
        imu.data(imu.n+1).time=time;
        imu.data(imu.n+1).dw(1:3)=imudata(i,3:5)*dt;
        imu.data(imu.n+1).dv(1:3)=imudata(i,6:8)*dt;
        imu.n=imu.n+1;
    end
elseif ins.data_format==2
    for i=1:n
        time=gpst2time(imudata(i,1),imudata(i,2));
        if ts.time~=0&&timediff(time,ts)<0,continue;end
        if te.time~=0&&timediff(time,te)>0,continue;end
        
        if imu.n+1>size(imu.data,1)
            imu.data(imu.n+1:imu.n+NMAX)=repmat(gls.imud,NMAX,1);
        end
        imu.data(imu.n+1).time=time;
        imu.data(imu.n+1).dw(1:3)=imudata(i,3:5);
        imu.data(imu.n+1).dv(1:3)=imudata(i,6:8);
        imu.n=imu.n+1;
    end
end

if imu.n<size(imu.data,1)
    imu.data(imu.n+1:end,:)=[];
end

fprintf('over\n');

return

