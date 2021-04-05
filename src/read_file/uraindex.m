function ind=uraindex(value)

ura_eph=[2.4,3.4,4.85,6.85,9.65,13.65,24.0,48.0,96.0,192.0,384.0,768.0,...
    1536.0,3072.0,6144.0,0.0];%ura values 

for i=1:15
    if ura_eph(i)>=value
        ind=i; return;
    end
end

return