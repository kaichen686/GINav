function [rtk,D,nb]=ddmat(rtk,D)

global glc
nf=rtk.NF; na=rtk.na;nb=0;
MAXSAT=glc.MAXSAT;

for i=1:MAXSAT
    for j=1:glc.NFREQ
        rtk.sat(i).fix(j)=0;
    end
end

for i=1:na
   D(i,i)=1; 
end

for m=1:5
    nofix=(m==2&&rtk.opt.glomodear==0)||(m==4&&rtk.opt.bdsmodear==0);
    
    k=na;
    for f=1:nf
        
        for i=k+1:k+MAXSAT
            if rtk.x(i)==0||~test_sys(rtk.sat(i-k).sys,m)||...
                    ~rtk.sat(i-k).vsat(f)||~rtk.sat(i-k).half(f)
                continue;
            end
            if rtk.sat(i-k).lock(f)>0&&~bitand(rtk.sat(i-k).slip(f),2)&&...
                    rtk.sat(i-k).azel(2)>=rtk.opt.elmaskar&&~nofix
                rtk.sat(i-k).fix(f)=2;
                break;
            else
                rtk.sat(i-k).fix(f)=1;
            end
        end
        
        for j=k+1:k+MAXSAT
            if i==j||rtk.x(j)==0||~test_sys(rtk.sat(j-k).sys,m)||...
                    ~rtk.sat(j-k).vsat(f)
                continue;
            end
            if rtk.sat(j-k).lock(f)>0&&~bitand(rtk.sat(j-k).slip(f),2)&&...
                    rtk.sat(i-k).vsat(f)&&...
                    rtk.sat(j-k).azel(2)>=rtk.opt.elmaskar&&~nofix
                D(na+nb+1,i)= 1;
                D(na+nb+1,j)=-1;
                nb=nb+1;
                rtk.sat(j-k).fix(f)=2;
            else
                rtk.sat(j-k).fix(f)=1;
            end
        end
        
        k=k+MAXSAT;
    end
     
end

return

