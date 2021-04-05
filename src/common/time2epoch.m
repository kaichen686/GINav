function ep=time2epoch(t)

mday=[31,28,31,30,31,30,31,31,30,31,30,31,31,28,31,30,31,30,31,31,30,31,30,31,...
     31,29,31,30,31,30,31,31,30,31,30,31,31,28,31,30,31,30,31,31,30,31,30,31];
days=fix(t.time/86400);
sec=fix(t.time-days*86400);
day=rem(days,1461); mon=0;

while mon<48
    if day>=mday(mon+1)
        day=day-mday(mon+1);
    else
        break;
    end
    mon=mon+1;
end

ep(1)=1970+fix(days/1461)*4+fix(mon/12);
ep(2)=rem(mon,12)+1;
ep(3)=day+1;
ep(4)=fix(sec/3600);
ep(5)=fix(rem(sec,3600)/60);
ep(6)=rem(sec,60)+t.sec;

return

