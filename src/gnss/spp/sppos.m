function [rtk,stat0]=sppos(rtk,obs,navs)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%% standard point positioning %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%input:  rtk - rtk control struct
%        obs - observations
%        nav - navigation message
%output: rtk - rtk control struct
%        stat0 - state (0:error 1:ok)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

global glc
opt=rtk.opt; nobs=size(obs,1);

if nobs<4, stat0=0; return; end

rtk.sol.stat=glc.SOLQ_NONE;
rtk.sol.time=obs(1).time;

% defulat options for spp
if rtk.opt.mode~=glc.PMODE_SPP
    opt.sateph =glc.EPHOPT_BRDC;
    opt.tropopt=glc.IONOOPT_BRDC;
    opt.ionoopt=glc.TROPOPT_SAAS;
end

% cumpute satellite(space vehicle) position,clock bias,velocity,clock drift
sv=satposs(obs,navs,opt.sateph); 

% compute reciever position,clock bias
[rtk,sat_,stat0]=estpos(rtk,obs,navs,sv,opt); 

% raim failure detection and exclution(FDE)
if stat0==0&&nobs>=6&&rtk.opt.posopt(5)==1
    [wn,sow]=time2gpst(rtk.sol.time);
    fprintf('Info:GPS week = %d sow = %.3f,RAIM failure detection and exclution\n',wn,sow);
    [rtk,sat_,stat0]=raim_FDE(rtk,obs,navs,sv,opt,sat_);
end

% compute reciever velocity,clock drift
if stat0~=0
    rtk=estvel(rtk,obs,navs,sv,opt,sat_);
end

% check the consistency of position and velocity
tt=timediff(obs(1).time,rtk.rcv.time);
if norm(rtk.rcv.oldpos)~=0&&norm(rtk.sol.pos)~=0&&...
        norm(rtk.rcv.oldvel)~=0&&norm(rtk.sol.vel)~=0&&abs(tt)<=1
    dpos0=(rtk.sol.vel+rtk.rcv.oldvel)/2*abs(tt);
    dpos1=rtk.sol.pos-rtk.rcv.oldpos;
    diff=abs(dpos0-dpos1);
    if max(diff)>30||norm(diff)>50
        stat0=0;
        rtk.sol.stat=glc.SOLQ_NONE;
    end 
end

% check the correctness of the receiver clock bias estimation
tt=timediff(obs(1).time,rtk.rcv.time);
if abs(rtk.sol.dtrd)>5&&abs(tt)<=10
    if rtk.rcv.clkbias~=0&&rtk.rcv.clkdrift~=0&&rtk.sol.dtr(1)~=0&&...
        rtk.sol.dtrd~=0
        clkbias0=rtk.rcv.clkbias+(rtk.rcv.clkdrift+rtk.sol.dtrd)/2*abs(tt);
        clkbias1=rtk.sol.dtr(1)*glc.CLIGHT;
        if abs(clkbias0-clkbias1)>0.3*abs(rtk.rcv.clkdrift+rtk.sol.dtrd)/2
            stat0=0;
            rtk.sol.stat=glc.SOLQ_NONE;
        end
    end
end

if rtk.sol.stat~=glc.SOLQ_NONE
    rtk.rcv.time=obs(1).time;
    rtk.rcv.oldpos=rtk.sol.pos;
    rtk.rcv.oldvel=rtk.sol.vel;
    rtk.rcv.clkbias=rtk.sol.dtr(1)*glc.CLIGHT;
    rtk.rcv.clkdrift=rtk.sol.dtrd;
end

for i=1:glc.MAXSAT
    rtk.sat(i).vs=0;
    rtk.sat(i).azel=[0,0];
    rtk.sat(i).snr(1)=0;
    rtk.sat(i).resp(1)=0;
    rtk.sat(i).resc(1)=0;
end

for i=1:nobs
    rtk.sat(obs(i).sat).azel=sat_.azel(i,:);
    rtk.sat(obs(i).sat).snr(1)=obs(i).S(1);
    if sat_.vsat(i)==0,continue;end
    rtk.sat(obs(i).sat).vs=1;
    rtk.sat(obs(i).sat).resp(1)=sat_.resp(i);
end

return

