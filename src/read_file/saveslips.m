function [data,slips]=saveslips(data,slips)

global glc

for i=1:glc.NFREQ
   if bitand(data.LLI(i),1)
       slips(data.sat,i)=bitor(slips(data.sat,i),1);
   end
end

return