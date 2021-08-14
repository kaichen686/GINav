function [nav,fid]=decode_navh(nav,fid)

while ~feof(fid)
    
    line=fgets(fid);label=line(61:end);
    
    if ~isempty(strfind(label,'ION ALPHA')) %ver.2
        j=2;
        for i=1:4
            nav.ion_gps(i)=str2num(line(j+1:j+12)); %#ok
            j=j+12;
        end
    elseif ~isempty(strfind(label,'ION BETA')) %ver.2
        j=2;
        for i=1:4
            nav.ion_gps(i+4)=str2num(line(j+1:j+12)); %#ok
            j=j+12;
        end
    elseif ~isempty(strfind(label,'DELTA-UTC: A0,A1,T,W')) %ver.2
        j=3;
        for i=1:2
            nav.utc_gps(i)=str2num(line(j+1:j+19)); %#ok
            j=j+19;
        end
        if i<=3
            ii=i+1;
            for i=ii:4
                nav.utc_gps(i)=str2num(line(j+1:j+9)); %#ok
                j=j+9;
            end  
        end
    elseif ~isempty(strfind(label,'IONOSPHERIC CORR')) %ver.3
        if ~isempty(strfind(line,'GPSA'))
            j=5;
            for i=1:4
                nav.ion_gps(i)=str2num(line(j+1:j+12)); %#ok
                j=j+12;
            end
        elseif  ~isempty(strfind(line,'GPSB'))
            j=5;
            for i=1:4
                nav.ion_gps(i+4)=str2num(line(j+1:j+12)); %#ok
                j=j+12;
            end
        elseif ~isempty(strfind(line,'GAL'))
            j=5;
            for i=1:4
                nav.ion_gal(i)=str2num(line(j+1:j+12)); %#ok
                j=j+12;
            end
        elseif ~isempty(strfind(line,'BDSA')) %v.3.02
            j=5;
            for i=1:4
                nav.ion_bds(i)=str2num(line(j+1:j+12)); %#ok
                j=j+12;
            end
        elseif ~isempty(strfind(line,'BDSB')) %v.3.02
            j=5;
            for i=1:4
                nav.ion_bds(i+4)=str2num(line(j+1:j+12)); %#ok
                j=j+12;
            end
        elseif ~isempty(strfind(line,'QZSA')) %v.3.02
            j=5;
            for i=1:4
                nav.ion_qzs(i)=str2num(line(j+1:j+12)); %#ok
                j=j+12;
            end
        elseif ~isempty(strfind(line,'QZSB')) %v.3.02
            j=5;
            for i=1:4
                nav.ion_qzs(i+4)=str2num(line(j+1:j+12)); %#ok
                j=j+12;
            end
        end
    elseif ~isempty(strfind(label,'TIME SYSTEM CORR')) %ver.3 
        if ~isempty(strfind(line,'GPUT'))
            nav.utc_gps(1)=str2double(line(6:22));
            nav.utc_gps(2)=str2double(line(23:38));
            nav.utc_gps(3)=str2double(line(39:45));
            nav.utc_gps(4)=str2double(line(46:50));
        elseif ~isempty(strfind(line,'GLUT'))
            nav.utc_glo(1)=str2double(line(6:22));
            nav.utc_glo(2)=str2double(line(23:38));
        elseif ~isempty(strfind(line,'GAUT')) %v.3.02
            nav.utc_gal(1)=str2double(line(6:22));
            nav.utc_gal(2)=str2double(line(23:38));
            nav.utc_gal(3)=str2double(line(39:45));
            nav.utc_gal(4)=str2double(line(46:50));
        elseif ~isempty(strfind(line,'BDUT')) %v.3.02
            nav.utc_bds(1)=str2double(line(6:22));
            nav.utc_bds(2)=str2double(line(23:38));
            nav.utc_bds(3)=str2double(line(39:45));
            nav.utc_bds(4)=str2double(line(46:50));
        elseif ~isempty(strfind(line,'QZUT')) %v.3.02
            nav.utc_qzs(1)=str2double(line(6:22));
            nav.utc_qzs(2)=str2double(line(23:38));
            nav.utc_qzs(3)=str2double(line(39:45));
            nav.utc_qzs(4)=str2double(line(46:50));    
        end
    elseif ~isempty(strfind(label,'LEAP SECONDS'))
        nav.leaps=str2double(line(1:7));
    elseif ~isempty(strfind(label,'END OF HEADER'))
        break;
    end
end

return

