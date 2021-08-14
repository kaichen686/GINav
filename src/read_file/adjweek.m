function t=adjweek(t1,t2)

tt=timediff(t1,t2);
if tt<-302400
    t=timeadd(t1,604800);
    return;
end
if tt>302400
    t=timeadd(t1,-604800);
    return;
end
t=t1;

return