function obsr=bds2mp_corr(rtk,obsr)

global glc
IGSOCOEF=[-0.55,-0.40,-0.34,-0.23,-0.15,-0.04,0.09,0.19,0.27,0.35;...	%B1
		  -0.71,-0.36,-0.33,-0.19,-0.14,-0.03,0.08,0.17,0.24,0.33;...	%B2
		  -0.27,-0.23,-0.21,-0.15,-0.11,-0.04,0.05,0.14,0.19,0.32]; 	%B3
MEOCOEF=[-0.47,-0.38,-0.32,-0.23,-0.11,0.06,0.34,0.69,0.97,1.05;...	%B1
		 -0.40,-0.31,-0.26,-0.18,-0.06,0.09,0.28,0.48,0.64,0.69;...	%B2
		 -0.22,-0.15,-0.13,-0.10,-0.04,0.05,0.14,0.27,0.36,0.47];	%B3
nobs=size(obsr,1); 

for i=1:nobs
   sat=obsr(i).sat;
   [sys,prn]=satsys(sat);
   if sys~=glc.SYS_BDS,continue;end
   if prn<=5,continue;end
   
   el=rtk.sat(sat).azel(2)*glc.R2D;
   if el<=0,continue;end
   
   dmp=zeros(1,3);
   
   a=el*0.1;
   b=fix(a);
   
   if find(glc.BD2_IGSO==prn) %IGSO
       if b<0
           for j=1:3
               dmp(j)=IGSOCOEF(j,1);
           end
       elseif b>=9
           for j=1:3
               dmp(j)=IGSOCOEF(j,10);
           end
       else
           for j=1:3
               dmp(j)=IGSOCOEF(j,b+1)*(1-a+b)+IGSOCOEF(j,b+2)*(a-b);
           end
       end
   elseif find(glc.BD2_MEO==prn) %MEO
       if b<0
           for j=1:3
               dmp(j)=MEOCOEF(j,1);
           end
       elseif b>=9
           for j=1:3
               dmp(j)=MEOCOEF(j,10);
           end
       else
           for j=1:3
               dmp(j)=MEOCOEF(j,b+1)*(1-a+b)+MEOCOEF(j,b+2)*(a-b);
           end
       end
   end
   
   for j=1:3
       obsr(i).P(j)=obsr(i).P(j)+dmp(j);
   end
    
end

return


      
          
          