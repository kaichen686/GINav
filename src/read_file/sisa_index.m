function ind=sisa_index(value)

if value<0.0 || value>6.0
    ind=255;return;
elseif value<=0.5
    ind=fix(value/0.01);return;
elseif value<=1
    ind=fix((value-0.5)/0.02)+50;return;
elseif value<=2
    ind=fix((value-1.0)/0.04)+75;return;
else
    ind=fix(fix(value-2.0)/0.16+100);return;
end

