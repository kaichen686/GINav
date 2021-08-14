function dants=antmodel_s(pcvs,nadir)

global glc;
dants=zeros(3,1); R2D=glc.R2D; NFREQ=glc.NFREQ;
sat=pcvs.sat; [sys,~]=satsys(sat);

for i=1:glc.NFREQ
    if sys==glc.SYS_GPS
        dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(i,:),1);
        if i==3
            dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(2,:),1);
        end
    elseif sys==glc.SYS_GLO
        dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(i+NFREQ,:),1);
        if i==3
            dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(2+NFREQ,:),1);
        end
    elseif sys==glc.SYS_GAL
        dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(i+2*NFREQ,:),1);
        if i==3
            dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(2+2*NFREQ,:),1);
        end
    elseif sys==glc.SYS_BDS
        dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(i+3*NFREQ,:),1);
        if i==3
            dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(2+3*NFREQ,:),1);
        end
    elseif sys==glc.SYS_QZS
        dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(i+4*NFREQ,:),1);
        if i==3
            dants(i)=interpvar0(sat,nadir*R2D*5,pcvs.var(2+4*NFREQ,:),1);
        end
    end
end

return

