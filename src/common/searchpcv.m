function [pcv,stat]=searchpcv(sat,type,time,pcvs)

global gls;
stat=0; pcv=gls.pcv;

if sat~=0 %search satellite antena parameters
    for i=1:pcvs.n
        pcv=pcvs.pcv(i);
        if pcv.sat~=sat,continue;end
        if pcv.ts.time~=0&&timediff(pcv.ts,time)>0,continue;end
        if pcv.te.time~=0&&timediff(pcv.te,time)<0,continue;end
        stat=1; return;
    end
else %search reciever antenna parameters
    if strcmp(type,''),return;end
    buff=type;nt=0;
    for i=1:2
        [tmp,buff]=strtok(buff); %#ok
        if isempty(tmp),continue;end
        types(i).str=tmp; %#ok
        nt=nt+1;
    end
    if nt<=0,return;end
    
    % search receiver antenna with radome at first
    for i=1:pcvs.n
        pcv=pcvs.pcv(i);
        for j=1:nt
            if isempty(strfind(pcv.type,types(j).str)),break;end
        end
        if j>=nt,stat=1;return;end
    end
    
    % search receiver antenna without radome
    for i=1:pcvs.n
        pcv=pcvs.pcv(i);
        if ~isempty(strfind(pcv.type,types(1).str))
            if types(1).str~=pcv.type,continue;end
        end
        stat=1; return;
    end
end

return

