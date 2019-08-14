%´øÍ¨ÂË²¨
function denoisedAmp = denoise(amp, fc)
    L = length(amp);  
    famp = fft(amp);
    famp(fc:L-fc)=0;
    denoisedAmp = abs(ifft(famp));   
end