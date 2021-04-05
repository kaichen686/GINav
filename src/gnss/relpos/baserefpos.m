function rtk=baserefpos(rtk,opt,obs,nav)

global glc

if opt.basepostype==glc.POSOPT_POS
    rtk.basepos=opt.basepos;
elseif opt.basepostype==glc.POSOPT_SPP
    rtk.basepos=avepos(rtk,opt,obs,nav);
elseif opt.basepostype==glc.POSOPT_RINEX
    if norm(obs.sta.pos)<=0
        error('Have no base position in renix header!!!\n');
    end
    [~,Cne]=xyz2blh(obs.sta.pos);
    dr=Cne'*obs.sta.del;
    rtk.basepos=obs.sta.pos+dr;
else
    error('Unable to obtain base position!!!\n');
end

if norm(rtk.basepos)==0
    error('The coordinates of the base station is zero!!!');
end

return

