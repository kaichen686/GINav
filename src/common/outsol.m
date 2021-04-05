function outsol(rtk)

global glc
sol=rtk.sol; solopt=rtk.opt.sol;
outfile=rtk.outfile; sep=' '; str_vel=''; str_att='';

if sol.stat==glc.SOLQ_NONE
    return
end

if solopt.timef==glc.SOLT_GPST
    [week,sow]=time2gpst(sol.time);
    if (86400*7-sow)<0.5/1e3
        week=week+1; sow=0;
    end
    str_time=sprintf('%4d%s%10.3f',week,sep,sow);
elseif solopt.timef==glc.SOLT_UTC
    if (1-sol.time.sec)<0.5/1e3
        sol.time.time=sol.time.time+1;
        sol.time.sec=0;
    end
    ep=time2epoch(sol.time);
    str_time=sprintf('%04.0f/%02.0f/%02.0f %02.0f:%02.0f:%06.3f',...
                     ep(1),ep(2),ep(3),ep(4),ep(5),ep(6));
else
    error('Time output options is wrong!!!');
end

if solopt.posf==glc.SOLF_XYZ
    stat=sol.stat; ns=sol.ns;
    pos=sol.pos; posP=sol.posP;
    for i=1:6
        posP(i)=sqvar(posP(i));
    end
    age=sol.age; ratio=sol.ratio;
    str_pos=sprintf('%s%14.4f%s%14.4f%s%14.4f%s%3d%s%3d%s%8.4f%s%8.4f%s%8.4f%s%8.4f%s%8.4f%s%8.4f%s%6.2f%s%6.1f',...
                   sep,pos(1),sep,pos(2),sep,pos(3),sep,stat,sep,ns,sep,posP(1),sep,posP(2),...
                   sep,posP(3),sep,posP(4),sep,posP(5),sep,posP(6),sep,age,sep,ratio);
    if solopt.outvel==1
        vel=sol.vel; velP=sol.velP;
        for i=1:6
            velP(i)=sqvar(velP(i));
        end
        str_vel=sprintf('%s%10.5f%s%10.5f%s%10.5f%s%9.5f%s%8.5f%s%8.5f%s%8.5f%s%8.5f%s%8.5f',...
                        sep,vel(1),sep,vel(2),sep,vel(3),sep,velP(1),sep,velP(2),...
                        sep,velP(3),sep,velP(4),sep,velP(5),sep,velP(6));
    end
elseif solopt.posf==glc.SOLF_LLH
    stat=sol.stat; ns=sol.ns;
    [pos,Cne]=xyz2blh(sol.pos); posP=sol.posP;
    P=[posP(1) posP(4) posP(6);
       posP(4) posP(2) posP(5);
       posP(6) posP(5) posP(3)];
    Q=Cne*P*Cne';
    posP(1)=Q(1,1);posP(2)=Q(2,2);posP(3)=Q(3,3);
    posP(4)=Q(1,2);posP(5)=Q(1,3);posP(6)=Q(2,3);
    for i=1:6
        posP(i)=sqvar(posP(i));
    end
    age=sol.age; ratio=sol.ratio;
    str_pos=sprintf('%s%14.9f%s%14.9f%s%10.4f%s%3d%s%3d%s%8.4f%s%8.4f%s%8.4f%s%8.4f%s%8.4f%s%8.4f%s%6.2f%s%6.1f',...
                      sep,pos(1)/glc.D2R,sep,pos(2)/glc.D2R,sep,pos(3),sep,stat,sep,ns,sep,posP(1),sep,posP(2),...
                      sep,posP(3),sep,posP(4),sep,posP(5),sep,posP(6),sep,age,sep,ratio);
    if solopt.outvel==1
        vel=sol.vel; velP=sol.velP;
        vel=Cne*vel';
        P=[velP(1) velP(4) velP(6);
           velP(4) velP(2) velP(5);
           velP(6) velP(5) velP(3)];
        Q=Cne*P*Cne';
        velP(1)=Q(1,1);velP(2)=Q(2,2);velP(3)=Q(3,3);
        velP(4)=Q(1,2);velP(5)=Q(1,3);velP(6)=Q(2,3);
        for i=1:6
            velP(i)=sqvar(velP(i));
        end
        str_vel=sprintf('%s%10.5f%s%10.5f%s%10.5f%s%9.5f%s%8.5f%s%8.5f%s%8.5f%s%8.5f%s%8.5f',...
                        sep,vel(2),sep,vel(1),sep,vel(3),sep,velP(2),sep,velP(1),...
                        sep,velP(3),sep,velP(5),sep,velP(4),sep,velP(6));
    end
else
    error('Position output options is wrong!!!');
end


if solopt.outatt==1
    att=sol.att;
    attP=sol.attP;
    for i=1:6
        attP(i)=sqvar(attP(i));
    end
    str_att=sprintf('%s%10.5f%s%10.5f%s%10.5f%s%9.5f%s%8.5f%s%8.5f%s%8.5f%s%8.5f%s%8.5f',...
                    sep,att(1),sep,att(2),sep,att(3),sep,attP(1),sep,attP(2),...
                    sep,attP(3),sep,attP(4),sep,attP(5),sep,attP(6));
end


if rtk.opt.ins.mode==glc.GIMODE_OFF
    str=[str_time,str_pos];
    if ~strcmp(str_vel,'')
        str=[str,str_vel];
    end
else
    str=[str_time,str_pos];
    if ~strcmp(str_vel,'')
        str=[str,str_vel];
    end
    if ~strcmp(str_att,'')
        str=[str,str_att];
    end
end

fp=fopen(outfile,'a');
fprintf(fp,'%s',str);
fprintf(fp,'\n');
fclose(fp);

return

