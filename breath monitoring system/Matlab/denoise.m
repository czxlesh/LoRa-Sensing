function [denoisedAmp] = denoise(amp,cf)
%DENOISDE �˴���ʾ�йش˺�����ժҪ
%   �˴���ʾ��ϸ˵��
L = length(amp);
famp = fft(amp);
famp(cf:L-cf)=0;
denoisedAmp = abs(ifft(famp));
end

