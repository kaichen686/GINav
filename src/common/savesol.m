function savesol(rtk,solution)

n=size(solution,1);
for i=1:n
    time=solution(i).time;
    t.time=round(time.time+time.sec);
    t.sec=0;
    solution(i).time=t;
end

outfile=rtk.outfile;
idx=find(outfile=='.');
outfile_name=[outfile(1:idx(end)),'mat'];

save(outfile_name,'solution');

return