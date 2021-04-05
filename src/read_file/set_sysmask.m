function mask=set_sysmask(opt)

mask(1:5)=0;

if ~isempty(strfind(opt,'G')),mask(1)=1;end
if ~isempty(strfind(opt,'R')),mask(2)=1;end
if ~isempty(strfind(opt,'E')),mask(3)=1;end
if ~isempty(strfind(opt,'C')),mask(4)=1;end
if ~isempty(strfind(opt,'J')),mask(5)=1;end

return