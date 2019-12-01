beijipath = 'F:\UbuntuShare\';
fileName1 = 'ant1-1.dat';
fileName2 = 'ant2-1.dat';
totTime = 10; %minutes
winSize = 30; %seconds
sampleRate = 1000;
ratio = 250; %downsample
filterLow = 0.15;
filterHigh = 0.7;
%time = 1:ratio/sampleRate:winSize;
id = 1;

tic;
for t = 1: totTime * 60
    while toc < t
    end
    
    file1 = fopen([path, fileName1]);
    file2 = fopen([path, fileName2]);
    signal1 = fread(file1, 'float32');
    signal2 = fread(file2, 'float32');
    fclose(file1);
    fclose(file2);
    
    time = t:ratio/sampleRate:t+winSize-1;
    %realtime
    signal1 = signal1(end - winSize*sampleRate*2 + 1: end);
    signal2 = signal2(end - winSize*sampleRate*2 + 1: end);

    %samulate realtime
%     signal1 = signal1(id: id+winSize*sampleRate*2-1);
%     signal2 = signal2(id: id+winSize*sampleRate*2-1);
    id = id + sampleRate*2;
    
    i1 = signal1(1:2:end);
    q1 = signal1(2:2:end);
    s1 = complex(i1, q1);
    amp1 = abs(s1);
    
    i2 = signal2(1:2:end);
    q2 = signal2(2:2:end);
    s2 = complex(i2, q2);
    amp2 = abs(s2);
    
    Q = s1./s2;
    ampQ = abs(Q);
    phaseS = angle(Q);

    cut_freq = 10;    %低通滤波参数，可调
    denoisedAmp1 = denoise(amp1, cut_freq);
    detrendAmp1 = detrend(denoisedAmp1);
    downsampleAmp1 = downsample(denoisedAmp1, ratio);
    
    denoisedAmp2 = denoise(amp2, cut_freq);   
    detrendAmp2 = detrend(denoisedAmp2);
    downsampleAmp2 = downsample(denoisedAmp2, ratio);
    
    denoisedAmpQ = denoise(ampQ, cut_freq);   
    detrendAmpQ = detrend(denoisedAmpQ);
    downsampleAmpQ = downsample(denoisedAmpQ, ratio);
    
    subplot(3,1,1);
    plot(abs(downsampleAmp1));
    title('amp1');
    subplot(3,1,2);
    plot(abs(downsampleAmp2));
    title('amp2');
    subplot(3,1,3);
    plot(abs(downsampleAmpQ));
    title('ampS');
    drawnow;

    [pxx1, f1] = periodogram(detrendAmp1, [], [], sampleRate);
    selected_index1  = find(f1 > filterLow & f1 < filterHigh);
    f1 = f1(min(selected_index1) : max(selected_index1));
    pxx1 = pxx1(min(selected_index1) : max(selected_index1));

    [pxx2, f2] = periodogram(detrendAmp2*100, [], [], sampleRate);
    selected_index2  = find(f2 > filterLow & f2 < filterHigh);
    f2 = f2(min(selected_index2) : max(selected_index2));
    pxx2 = pxx2(min(selected_index2) : max(selected_index2));

    [pxxQ, fQ] = periodogram(detrendAmpQ, [], [], sampleRate);
    selected_indexQ  = find(fQ > filterLow & fQ < filterHigh);
    fQ = fQ(min(selected_indexQ) : max(selected_indexQ));
    pxxQ = pxxQ(min(selected_indexQ) : max(selected_indexQ));    
    
%     plot(f1,pxx1);
%     drawnow;
    
    disp(['Time: ', num2str(id/(2*sampleRate))]);

    [maxpxx1, bidx1] = max(pxx1);
    brate1 = f1(bidx1)*60;
    disp(['rate1: ', num2str(brate1)]);

    [maxpxx2, bidx2] = max(pxx2);
    brate2 = f2(bidx2)*60;
    disp(['rate2: ', num2str(brate2)]);
    
    [maxpxxQ, bidxQ] = max(pxxQ);
    brateQ = f1(bidxQ)*60;
    disp(['rateQ: ', num2str(brateQ)]);    

    save2DB(downsampleAmpQ*10, fQ, pxxQ*100, time, brateQ);
end

