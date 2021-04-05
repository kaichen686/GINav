function zd=zdres_sat(flag,r,obs,nav,azel,dant,opt,rtk,zd) %#ok

global glc
lam=nav.lam(obs.sat,:); nf=rtk.NF;

if opt.ionoopt==glc.IONOOPT_IFLC
    if lam(1)==0||lam(2)==0,return;end
    
    % check snr mask,not surpport
    
    f1=glc.CLIGHT/lam(1); f2=glc.CLIGHT/lam(2);
    C1=f1^2/(f1^2-f2^2);  C2=-f2^2/(f1^2-f2^2);
    
    dant_if=C1*dant(1)+C2*dant(2);
    
    if obs.L(1)~=0&&obs.L(2)~=0
        zd.y(1)=C1*obs.L(1)*lam(1)+C2*obs.L(2)*lam(2)-r-dant_if;
    end
    if obs.P(1)~=0&&obs.P(2)~=0
        zd.y(2)=C1*obs.P(1)+C2*obs.P(2)-r-dant_if;
    end 
else
    for i=1:nf
        if lam(i)==0,continue;end
        
        % check snr mask,not surpport
        
        if obs.L(i)~=0,zd.y(i   )=obs.L(i)*lam(i)-r-dant(i);end
        if obs.P(i)~=0,zd.y(i+nf)=obs.P(i)       -r-dant(i);end
    end 
end

return

