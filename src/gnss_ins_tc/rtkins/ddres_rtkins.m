function [rtk,v,H,R,nv,vflag]=ddres_rtkins(rtk,nav,dt,x,P,zdr,zdb,ind) 

global glc
lam_carr0=glc.CLIGHT/glc.FREQ_GPS_L1;
ns=ind.ns;sat=ind.sat;ir=ind.ir;ib=ind.ib;
nf=rtk.NF; nv=0; nb=zeros(glc.NFREQ*4*2+2,1); b=0;opt=rtk.opt;
v=zeros(2*ns*nf+2,1); H=zeros(2*ns*nf+2,rtk.nx); 
vflag=zeros(2*ns*nf+2,1); vinfo=zeros(2*ns*nf+2,4);

roverpos=blh2xyz(x(7:9));
bl=norm(roverpos-rtk.basepos);
posr=ecef2pos(roverpos); posb=ecef2pos(rtk.basepos);

Cnb=rtk.ins.Cnb; [~,Cen]=blh2xyz(posr); lever=Cen*Cnb*rtk.ins.lever;
C_phi=askew(lever); % coefficient for phi-angle

Ri=zeros(2*ns*nf+2,1); Rj=zeros(2*ns*nf+2,1); im=zeros(ns,1);
tropr=zeros(ns,1); tropb=zeros(ns,1); 
dtdxr=zeros(ns,3); dtdxb=zeros(ns,3);

for i=1:glc.MAXSAT
    for j=1:glc.NFREQ
        rtk.sat(i).resp(j)=0;
        rtk.sat(i).resc(j)=0;
    end
end

% compute factors of ionospheric and tropospheric delay
for i=1:ns
    if opt.ionoopt==glc.IONOOPT_EST
        im(i)=(ionmapf(posr,zdr(ir(i)).azel)+ionmapf(posb,zdb(ib(i)).azel))/2;
    end
    if opt.tropopt>=glc.TROPOPT_EST
        [tropr(i),dtdxr(i,:)]=prectrop(rtk.sol.time,posr,1,zdr(ir(i)).azel,rtk,x);
        [tropb(i),dtdxb(i,:)]=prectrop(rtk.sol.time,posb,2,zdb(ib(i)).azel,rtk,x);
    end
end

for m=1:5
    
    if opt.mode>glc.PMODE_DGNSS,kk=1;else,kk=nf+1;end
    
    for f=kk:nf*2
        % search reference satellite with highest elevation
        i=-1;
        for j=1:ns
            sysi=rtk.sat(sat(j)).sys;
            if ~test_sys(sysi,m),continue;end
            if ~validobs(zdr(ir(j)).y,zdb(ib(j)).y,f,nf),continue;end
            if i<0||(zdr(ir(j)).azel(2)>zdr(ir(i)).azel(2)),i=j;end
        end
        
        if i<0,continue;end
        
        nb(b+1)=0; 
        for j=1:ns
            if i==j,continue;end
            sysi=rtk.sat(sat(i)).sys;
            sysj=rtk.sat(sat(j)).sys;
            if ~test_sys(sysj,m),continue;end
            if ~validobs(zdr(ir(j)).y,zdb(ib(j)).y,f,nf),continue;end
            
            ff=rem(f-1,nf)+1;
            lami=nav.lam(sat(i),ff);
            lamj=nav.lam(sat(j),ff);
            if lami<=0||lamj<=0,continue;end
            
            H(nv+1,:)=0;
            
            % double-differenced residual
            v(nv+1)=(zdr(ir(i)).y(f)-zdb(ib(i)).y(f))-(zdr(ir(j)).y(f)-zdb(ib(j)).y(f));
            
            % H for INS parameter
            H(nv+1,1:3)=-(-zdr(ir(i)).LOS+zdr(ir(j)).LOS)*C_phi;
            T=Dblh2Dxyz(posr);
            H(nv+1,7:9)=-(-zdr(ir(i)).LOS+zdr(ir(j)).LOS)*T;
            
            % double-differenced ionospheric delay term
            if opt.ionoopt==glc.IONOOPT_EST
                fi=lami/lam_carr0; fj=lamj/lam_carr0;
                if f<=nf,kk1=-1;else,kk1=1;end
                didxi=kk1*fi*fi*im(i);
                didxj=kk1*fj*fj*im(j);
                v(nv+1)=v(nv+1)-(didxi*x(rtk.ii+sat(i))-didxj*x(rtk.ii+sat(j)));
                H(nv+1,rtk.ii+sat(i))= didxi;
                H(nv+1,rtk.ii+sat(j))=-didxj;
            end
            
            % double-differenced tropospheric delay term
            if opt.tropopt>=glc.TROPOPT_EST
                v(nv+1)=v(nv+1)-((tropr(i)-tropr(j))-(tropb(i)-tropb(j)));
                if opt.tropopt==glc.TROPOPT_EST,kk2=1;else,kk2=3;end
                for k=1:kk2
                    H(nv+1,rtk.itr+k)= (dtdxr(i,k)-dtdxr(j,k));
                    H(nv+1,rtk.itb+k)=-(dtdxb(i,k)-dtdxb(j,k));
                end
            end
            
            % double-differenced phase-bias term
            if f<=nf
                if opt.ionoopt~=glc.IONOOPT_IFLC
                    idxi=rtk.ib+(f-1)*glc.MAXSAT+sat(i);
                    idxj=rtk.ib+(f-1)*glc.MAXSAT+sat(j);
                    v(nv+1)=v(nv+1)-(lami*x(idxi)-lamj*x(idxj));
                    H(nv+1,idxi)= lami;
                    H(nv+1,idxj)=-lamj;
                else
                    idxi=rtk.ib+(f-1)*glc.MAXSAT+sat(i);
                    idxj=rtk.ib+(f-1)*glc.MAXSAT+sat(j);
                    v(nv+1)=v(nv+1)-(x(idxi)-x(idxj));
                    H(nv+1,idxi)= 1;
                    H(nv+1,idxj)=-1;
                end
            end
            
            % glonass receiver h/w bias term
            if opt.glomodear==2&&sysi==glc.SYS_GLO&&sysj==glc.SYS_GLO&&ff<=glc.NFREQGLO
                df=(glc.CLIGHT/lami-glc.CLIGHT/lamj)/1e-6;
                v(nv+1)=v(nv+1)-df*x(rtk.il+ff);
                H(nv+1,rtk.il+ff)=df;
            % glonass interchannel bias correction,not surpport
            elseif sysi==glc.SYS_GLO&&sysj==glc.SYS_GLO 
                %v(nv+1)=v(nv+1)-gloicbcorr(sat(i),sat(j),opt,lami,lamj,f);
            end
            
            if f<=nf,rtk.sat(sat(j)).resc(f   )=v(nv+1);
            else    ,rtk.sat(sat(j)).resp(f-nf)=v(nv+1);
            end
            
            % test innovation
            if opt.maxinno>0&&abs(v(nv+1))>opt.maxinno
                if f<=nf
                    rtk.sat(sat(i)).rejc(f)=rtk.sat(sat(i)).rejc(f)+1;
                    rtk.sat(sat(j)).rejc(f)=rtk.sat(sat(j)).rejc(f)+1;
                end
                continue;
            end
            
            % single-differenced measurement error variances
            Ri(nv+1)=varerr_rel(sat(i),sysi,zdr(ir(i)).azel(2),bl,dt,f,rtk);
            Rj(nv+1)=varerr_rel(sat(j),sysj,zdr(ir(j)).azel(2),bl,dt,f,rtk);
            
            % INS-aid cycle slip detection
            if opt.ins.aid(1)==1&&rtk.ngnsslock>10&&f<=nf&&...
                    rtk.sat(sat(i)).lock(f)>5&&rtk.sat(sat(j)).lock(f)>5
                H0=H(nv+1,:); R0=Ri(nv+1)+Rj(nv+1);
                q=sqrt(H0*P*H0'+R0);
                if v(nv+1)>4*q
                    rtk.sat(sat(j)).lock(f)=-rtk.opt.minlock;
                    rtk=initx(rtk,x(idxj),rtk.opt.std(1)^2,idxj);
                end
            end
            
            if opt.mode>glc.PMODE_DGNSS
                if f<=nf
                    rtk.sat(sat(i)).vsat(f)=1;
                    rtk.sat(sat(j)).vsat(f)=1;
                end
            else
                rtk.sat(sat(i)).vsat(f-nf)=1;
                rtk.sat(sat(j)).vsat(f-nf)=1;
            end
            
            if f<=nf,kk3=0;else,kk3=1;end
            vflag(nv+1)=bitshift(sat(i),16)|bitshift(sat(j),8)|bitshift(kk3,4)|rem(f-1,nf);
            vinfo(nv+1,1)=m;vinfo(nv+1,2)=f;
            vinfo(nv+1,3)=sat(i);vinfo(nv+1,4)=sat(j);
            nv=nv+1;
            nb(b+1)=nb(b+1)+1;
        end
        b=b+1;
    end
end

v(nv+1:end)=[]; H(nv+1:end,:)=[]; Ri(nv+1:end,:)=[]; Rj(nv+1:end,:)=[];
vinfo(nv+1:end,:)=[];

R=ddcov(nb,b,Ri,Rj,nv);

% IGG-3 model proposed by YuanXi Yang
if opt.ins.aid(2)==1&&rtk.ngnsslock>10
    
    Q=H*rtk.P*H'+R;
    c0=2; c1=5;
    nv=size(v,1); std_res=zeros(nv,1); rfact=zeros(nv,1);
    
    for i=1:nv
        std_res(i)=abs(v(i))/sqrt(Q(i,i));
    end
    
    % robust factor 
    for i=1:nv
        f=vinfo(i,2);
        if f<=nf
            rfact(i)=1; continue;
        end
        if std_res(i)<=c0
            rfact(i) = 1;
        elseif (std_res(i) >= c0) && (std_res(i) <= c1)
            rfact(i)= abs(std_res(i))/c0 * ((c1-c0)/(c1-abs(std_res(i))))^2;
        else
            rfact(i) = 10^6;
        end
    end
    
    for i=1:nv
        for j=1:nv
            if j~=i,continue;end
            R(i,j)=R(i,j)*sqrt(rfact(i)*rfact(j));
        end
    end
    
    idx=(rfact==10^6);
    v(idx,:)=[]; H(idx,:)=[]; R(idx,:)=[]; R(:,idx)=[];
end

return

