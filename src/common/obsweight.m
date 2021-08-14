function [Q] = obsweight(elR, snr_R)

snr_0=10; snr_1=50; snr_a=30;snr_A=30;

n = length(elR);

if (~any(elR) || ~any(snr_R))
    %code-code or phase-phase co-factor matrix Q construction
    Q = eye(n);
else
    %weight vectors (elevation and signal-to-noise ratio)
    q_R = 1 ./ (sin(elR * pi/180).^2) .* (10.^(-(snr_R-snr_1)/snr_a) .* ((snr_A/10.^(-(snr_0-snr_1)/snr_a)-1)./(snr_0-snr_1).*(snr_R-snr_1)+1));
    q_R(snr_R >= snr_1) = 1;
    Q = diag(q_R);
end