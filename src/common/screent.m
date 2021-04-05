function stat=screent(time,ts0,te0,ti)

global glc
stat=1;
ts=str2time(ts0);
te=str2time(te0);
[~,sow]=time2gpst(time);

if ti>0&&rem(sow+glc.DTTOL,ti)>2*glc.DTTOL
    stat=0;
end

if ts.time~=0&&timediff(time,ts)<-glc.DTTOL
    stat=0;
end

if te.time~=0&&timediff(time,te)>=glc.DTTOL
    stat=0;
end

return