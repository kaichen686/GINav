function rtk=detslip_LLI_ppp(rtk,obs)

nobs=size(obs,1);
for i=1:nobs
    for j=1:rtk.opt.nf
        if obs(i).L(j)==0||~bitand(obs(i).LLI(j),3),continue;end
        rtk.sat(obs(i).sat).slip(j)=1;
    end
end

return