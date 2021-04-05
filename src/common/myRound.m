function inum=myRound(dnum)

if dnum>0
    inum=fix(dnum+0.5);
else
    inum=fix(dnum-0.5);
end

return