function time=epoch2time(ep)

time.time=0; time.sec=0;
doy=[1,32,60,91,121,152,182,213,244,274,305,335];
year=ep(1);mon=ep(2);day=ep(3);

if (year<1970||2099<year||mon<1||12<mon) ,return;end 

if mod(year,4)==0&&mon>=3
    temp=1;
else
    temp=0;
end
days=(year-1970)*365+fix((year-1969)/4)+doy(mon)+day-2+temp;
sec=floor(ep(6));
time.time=fix(days*86400+ep(4)*3600+ep(5)*60+sec);
time.sec=ep(6)-sec;

return;
