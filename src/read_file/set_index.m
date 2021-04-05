function index=set_index(ver,sys,opt,tobs) %#ok

global glc
obscodes='CLDS';
index.n=0;
index.frq(1:glc.MAXOBSTYPE)=0;
index.pos(1:glc.MAXOBSTYPE)=0;
index.pri(1:glc.MAXOBSTYPE)=0;
index.type(1:glc.MAXOBSTYPE)=0;
index.code(1:glc.MAXOBSTYPE)=0;
index.shift(1:glc.MAXOBSTYPE)=0;

nn=size(tobs,1); n=0;
for i=1:nn
    if isempty(strfind(obscodes,tobs(i,1))),break;end 
    
    [index.code(i),index.frq(i)]=obs2code(tobs(i,2:3),sys);
    
    type=strfind(obscodes,tobs(i,1));
    if ~isempty(type)
        index.type(i)=type;
    else
        index.type(i)=0;
    end
    
    index.pri(i)=getcodepri(sys,index.code(i),opt);
    index.pos(i)=-1;
    index.code(i)=index.code(i)-1;
    n=n+1;
end

for i=1:glc.MAXFREQ
    
    % search for the highest level code
    k=-1;
    for j=1:n
        if index.frq(j)==i&&index.pri(j)~=0&&(k<0||index.pri(j)>index.pri(k))
            k=j;
        end
    end
    
    if k<0,continue;end
    
    for j=1:n
        if index.code(j)==index.code(k),index.pos(j)=i;end
    end
end

index.n=n;

return

