function stat=validobs(yr,yb,f,nf)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if yr(f)~=0&&yb(f)~=0&&(f<=nf||(yr(f-nf)~=0&&yb(f-nf)~=0))
    stat=1;
else
    stat=0;
end

return