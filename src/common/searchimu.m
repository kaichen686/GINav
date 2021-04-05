function [imud,imu,stat]=searchimu(imu)

global gls
imud=gls.imud; stat=1;

imu.idx=imu.idx+1;
if imu.idx<0||imu.idx>imu.n
    stat=0;return
end

imud=imu.data(imu.idx);

return