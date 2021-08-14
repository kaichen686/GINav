function obs=adjobs(obs,opt)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%adjust priority frequencies for BDS2 and BDS3
%convert the obs.data struct to obs.data matrix
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc
data0=zeros(obs.n,3+6*glc.NFREQ);

if obs.n==0,return;end

bds_frq_flag=1;
data=obs.data; obs=rmfield(obs,'data'); 
if glc.NFREQ>3&&(size(opt.bd2frq,2)<=3||size(opt.bd3frq,2)<=3)&&~isempty(strfind(opt.navsys,'C'))
    bds_frq_flag=0;
    fprintf('Warning:Specified frequency of BDS less than used number of frequency!\n');
end

for i=1:obs.n
    P=zeros(1,glc.NFREQ); L=zeros(1,glc.NFREQ); D=zeros(1,glc.NFREQ); 
    S=zeros(1,glc.NFREQ); LLI=zeros(1,glc.NFREQ); code=zeros(1,glc.NFREQ); 
    [sys,prn]=satsys(data(i).sat);
    if sys==glc.SYS_BDS
        if prn<19 %BD2
            if ~bds_frq_flag,continue;end
            frq=opt.bd2frq;
            for j=1:glc.NFREQ
               P(j)=data(i).P(frq(j));
               L(j)=data(i).L(frq(j));
               D(j)=data(i).D(frq(j));
               S(j)=data(i).S(frq(j));
               LLI(j)=data(i).LLI(frq(j));
               code(j)=data(i).code(frq(j));
            end
        else %BD3
            if ~bds_frq_flag,continue;end
            frq=opt.bd3frq;
            for j=1:glc.NFREQ
                P(j)=data(i).P(frq(j));
                L(j)=data(i).L(frq(j));
                D(j)=data(i).D(frq(j));
                S(j)=data(i).S(frq(j));
                LLI(j)=data(i).LLI(frq(j));
                code(j)=data(i).code(frq(j));
            end
        end
    else %GPS GLO GAL QZS
        for j=1:glc.NFREQ
            P(j)=data(i).P(j);
            L(j)=data(i).L(j);
            D(j)=data(i).D(j);
            S(j)=data(i).S(j);
            LLI(j)=data(i).LLI(j);
            code(j)=data(i).code(j);
        end
    end
    time=data(i).time; sat=data(i).sat;
    data0(i,:)=[time.time time.sec sat P L D S LLI code];
end
obs.data=data0;

return

