function rtk=udiono_pppins(rtk,obs,nav)

global glc;
gap_resion=120; VAR_IONO=60^2;
nobs=size(size(obs.sat,1),2);

%reset ionospheric delay if the outc is greater than the threshold
for i=1:glc.MAXSAT
    idx=rtk.ii+i;
    if rtk.x(idx)~=0&&rtk.sat(i).outc(1)>gap_resion
        rtk.x(idx)=0;
    end
end

for i=1:nobs
    idx=rtk.ii+obs(i).sat;
    if rtk.x(idx)==0
        [sys,~]=satsys(obs(i).sat); %#ok
        %if sys==glc.SYS_GAL,k=3;else,k=2;end
        k=2;
        lam=nav.lam(obs(i).sat,:);
        if obs(i).P(1)==0||obs(i).P(k)==0||lam(1)==0||lam(k)==0,continue;end
        ion=(obs(i).P(1)-obs(i).P(k))/(1-(lam(k)/lam(1))^2);
        pos=xyz2blh(rtk.sol.pos);
        azel=rtk.sat(obs(i).sat).azel;
        ion=ion/ionmapf(pos,azel);
        rtk=initx(rtk,ion,VAR_IONO,idx);
    else
        el=rtk.sat(obs(i).sat).azel(2);
        if el>5*glc.D2R
            sinel=sin(el);
        else
            sinel=sin(5*glc.D2R);
        end
        rtk.P(idx,idx)=rtk.P(idx,idx)+(rtk.opt.prn(2)/sinel)^2*abs(rtk.tt);
    end
end

return


