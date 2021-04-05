function rtk = detslip_LLI(rtk,obs,i,rcv)

global glc;
sat=obs(i).sat;

for f=1:rtk.opt.nf
    
    if obs(i).L(f)==0||abs(timediff(obs(i).time,rtk.sat(sat).pt(rcv,f)))<glc.DTTOL
        continue;
    end
    
    % restore previous LLI
    if rcv==1
        LLI=getbitu(rtk.sat(sat).slip(f),0,2);
    else
        LLI=getbitu(rtk.sat(sat).slip(f),2,2);
    end
    
    % detect slip by cycle slip flag in LLI
    if rtk.tt>=0
        slip=obs(i).LLI(f);
    else
        slip=LLI;
    end
    
    if (bitand(LLI,2)&&~bitand(obs(i).LLI(f),2))||(~bitand(LLI,2)&&bitand(obs(i).LLI(f),2))
        slip=bitor(slip,1);
    end
    
    if rcv==1
        rtk.sat(sat).slip(f)=setbitu(rtk.sat(sat).slip(f),0,2,obs(i).LLI(f));
    else
        rtk.sat(sat).slip(f)=setbitu(rtk.sat(sat).slip(f),2,2,obs(i).LLI(f));
    end
    
    rtk.sat(sat).slip(f)=bitor(rtk.sat(sat).slip(f),slip);
    if bitand(obs(i).LLI(f),2)
        rtk.sat(sat).half(f)=0;
    else
        rtk.sat(sat).half(f)=1;
    end
    
end

return

