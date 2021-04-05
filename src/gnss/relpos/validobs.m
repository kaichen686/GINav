function stat=validobs(yr,yb,f,nf)

if yr(f)~=0&&yb(f)~=0&&(f<=nf||(yr(f-nf)~=0&&yb(f-nf)~=0))
    stat=1;
else
    stat=0;
end

return