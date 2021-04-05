function time=ydoy2time(yyyy,doy)

days_in_month=[31,28,31,30,31,30,31,31,30,31,30,31];
ep=zeros(1,6);

% check if yyyy is leap year
if rem(yyyy,4)==0&&(rem(yyyy,100)~=0||rem(yyyy,400)==0)
    days_in_month(2)=29;
end

id=doy; dd=0;
for mm=1:12
    id=id-days_in_month(mm);
    if id>0,continue;end
    dd=id+days_in_month(mm);
    break;
end

ep(1)=yyyy;ep(2)=mm;ep(3)=dd;
time=epoch2time(ep);

return

