function [rtk,sat_,stat]=raim_FDE(rtk,obs,nav,sv,opt,sat_)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%receiver autonomous integrity monitoring, failure detection and exclution
%only detect and exclude a faulty satellite
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global gls
stat=0; rms_max=100; nobs=size(obs,1);
obs_tmp=repmat(gls.obs_tmp,nobs-1,1);
sv_tmp=repmat(gls.sv,nobs-1,1);

for i=1:nobs
    
    % exclude a satellite
    k=0;
    for j=1:nobs
        if j==i,continue;end
        obs_tmp(k+1)=obs(j);
        sv_tmp(k+1)=sv(j);
        k=k+1;
    end
    
    %estimate position without a satellite
    [rtk_tmp,sat_tmp,stat0]=estpos(rtk,obs_tmp,nav,sv_tmp,opt);
    if stat0==0,continue;end
    
    resp_tmp=sat_tmp.resp; vsat_tmp=sat_tmp.vsat;
    rms=0; nvsat=0;
    for j=1:nobs-1
        if vsat_tmp(j)==0,continue;end
        rms=rms+resp_tmp(j)^2;
        nvsat=nvsat+1;
    end
    if nvsat<5,continue;end
    
    rms_ave=sqrt(rms/nvsat);
    if rms_ave>rms_max,continue;end
    
    %save result
    m=1;
    for j=1:nobs
        if j==i,continue;end
        sat_.azel(j,:)=sat_tmp.azel(m,:);
        sat_.vsat(j,:)=sat_tmp.vsat(m);
        sat_.resp(j,:)=sat_tmp.resp(m);
        m=m+1;
    end
    stat=1;
    rtk.sol=rtk_tmp.sol;
    rms_max=rms_ave;
    sat_.vsat(i)=0;
    
end

return

