function var=var_uraeph(sys,ura)

global glc
STD_GAL_NAPA =500.0;
ura_value=[2.4,3.4,4.85,6.85,9.65,13.65,24.0,48.0,96.0,192.0,384.0,768.0,1536.0,3072.0,6144.0];
ura=ura-1;

if sys==glc.SYS_GAL
    ura=ura+1;
    if ura<=49,var=(ura*0.01)^2;return;end
    if ura<=74,var=(0.5+(ura- 50)*0.02)^2;return;end
    if ura<=99,var=(1.0+(ura- 75)*0.04)^2;return;end
    if ura<=125,var=(2.0+(ura-100)*0.16)^2;return;end
    var=STD_GAL_NAPA^2;return;
else
    if ura<0||ura>15
        var=6144^2; return;
    else
        var=ura_value(ura+1)^2;return;
    end
end