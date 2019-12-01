function [denoisedAmp] = denoise(amp,cf)
%DENOISDE 此处显示有关此函数的摘要
%   此处显示详细说明
L = length(amp);
famp = fft(amp);
famp(cf:L-cf)=0;
denoisedAmp = abs(ifft(famp));
end

