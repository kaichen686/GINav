function fullname=findclkfile(filepath,ftime)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 2020-2025, by Kai Chen, All rights reserved.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fullname='';

week=num2str(ftime.week); 
dow=num2str(fix(ftime.sow/3600/24)); %day of week
gpst=[week,dow];

fileExt = '*.clk';
files = dir(fullfile(filepath,fileExt));
if isempty(files)
    fileExt = '*.CLK';
    files = dir(fullfile(filepath,fileExt));
end
nf=size(files,1);
if nf>0
    for i=1:nf
        if ~isempty(strfind(files(i).name,gpst))
            fullname=[filepath,files(i).name];
            return;
        end
    end
end

return