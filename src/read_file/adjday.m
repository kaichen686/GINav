function t=adjday(t1,t2)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tt=timediff(t1,t2);

if tt<-43200
    t=timeadd(t1,86400);
    return;
end

if tt>43200
    t=timeadd(t1,-86400);
    return;
end

t=t1;
return