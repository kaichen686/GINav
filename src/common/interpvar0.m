function value=interpvar0(sat,ang,var,bsat) %#ok

limit=18;

if bsat
    ang=ang/5;
    if ang>=limit
        value=var(19); return
    end
    if ang<0
        value=var(1); return
    end
    i=fix(ang);
    value=var(i+1)*(1+i-ang)+var(i+2)*(ang-i);
else
    a=ang/5;
    i=fix(a);
    if i<0
        value=var(1);return
    elseif i>19
        value=var(19);return
    end
    value=var(i+1)*(1-a+i)+var(i+2)*(a-i);
end

return
