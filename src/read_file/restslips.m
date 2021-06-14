function [data,slips]=restslips(data,slips)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Copyright(c) 2016 by T.TAKASU, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global glc

for i=1:glc.NFREQ
   if bitand(slips(data.sat,i),1)
       data.LLI(i)=bitor(data.LLI(i),1);
   end
   slips(data.sat,i)=0;
end

return