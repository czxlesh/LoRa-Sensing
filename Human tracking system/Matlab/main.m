path = 'F:\ubuntuShared\';
fileName1 = 'ant1-walk-2.dat';
fileName2 = replace(fileName1, 'ant1', 'ant2');

roomNum = 4;
roomDis = [0, 8.0, 11.2, 8];    %相邻两房间之间距离
disGraph = makeDisGraph(roomNum, roomDis);

totTime = 100;    %minutes，系统总运行时间
winSize = 30;    %seconds，时间窗口大小
sampleRate = 10000;    %原始采样率
ratio = 250;    %降采样倍数
filterLow = 0.15;    %带通滤波下限
filterHigh = 0.7;    %带通滤波上限
waveLength = 0.3279;
lastAct = -1;

cnt = 0;

tic;
for t = 1: totTime * 60
    %% == read file
    while toc < t
    end
    
    file1 = fopen([path, fileName1]);
    file2 = fopen([path, fileName2]);
    rawSignal1 = fread(file1, 'float32');    %天线1原始iq信号
    rawSignal2 = fread(file2, 'float32');    %天线2原始iq信号
    fclose(file1);
    fclose(file2);
    
    totLen = length(rawSignal1);
    now = floor(totLen/(sampleRate*2))-winSize;
    disp(['Time: ', num2str(now)]);
    nowid = 1+now*sampleRate*2;
    
    time = t:ratio/sampleRate:t+winSize-ratio/sampleRate;

    signal1 = rawSignal1(nowid: nowid+winSize*sampleRate*2-1);    %截取末尾片段
    signal2 = rawSignal2(nowid: nowid+winSize*sampleRate*2-1);    %截取末尾片段
    
% %     读离线时用
% %     signal1 = originalSignal1(end - winSize*sampleRate*2 + 1: end);
% %     signal2 = originalSignal2(end - winSize*sampleRate*2 + 1: end);
    i1 = signal1(1:2:end);
    q1 = signal1(2:2:end);
    s1 = complex(i1, q1);
    amp1 = abs(s1);
    
    i2 = signal2(1:2:end);
    q2 = signal2(2:2:end);
    s2 = complex(i2, q2);
    amp2 = abs(s2);
    
    quotient = s1./s2;
    ampQ = abs(quotient);
    phaseQ = angle(quotient);
    
    %% == denoise and downsample
    fc = 300;
    denoisedAmp1 = denoise(amp1, fc);
    denoisedAmp2 = denoise(amp2, fc);
    denoisedAmpQ = denoise(ampQ, fc);

    downsampleAmp1 = downsample(denoisedAmp1, ratio);
    downsampleAmp2 = downsample(denoisedAmp2, ratio);
    downsampleAmpQ = downsample(denoisedAmpQ, ratio);
    downsampleQ    = downsample(quotient, ratio); 
    
    %% == segmentation, calculation and recognition
    status = [];
    actSID = 0;
    actEID = 0;
    %status = [0,0,0] -> static
    %status = [1,0,0] -> walking
    %status = [2,ra,rb] -> just finish walking from ra to rb
    
    ws=1;    %1s，计算方差的滑动窗口大小
    [t, variance] = m_getVar(time, downsampleAmp1, ws*sampleRate/ratio);
    
    threshold = 0.3e-6;
    
    [actState, actTime, stateTrans] = m_getActState(t, variance, threshold, lastAct);
    lastAct = actState;
    if cnt>0    %检测到一次由动到静之后五秒内不再检测，防止误切
        status = [3,0,0];
    elseif actState == 1    %walking
        status = [1,0,0];
    elseif stateTrans == -1    %static
        status = [0,0,0];
    elseif stateTrans == 0    %static, just stop walking
        cnt = 5;
        sId = find(time == actTime(1));
        sId = sId + 40;    %为了切割更准引入的修正，可调
        eId = find(time == actTime(2));
        segmentAmp1 = downsampleAmp1(sId: eId);
        segmentAmp2 = downsampleAmp2(sId: eId);
        segmentAmpQ = downsampleAmpQ(sId: eId);
        segmentQ    = downsampleQ(sId: eId);
        
        [dis, dir] = calDisDir(segmentQ, waveLength);
        
        threshold1 = 0.4e-3;    %用于区分远近两处相同距离（r1->r2和r3->r4）
        [ra, rb] = roomMatch(roomNum, disGraph, dis, dir, variance, threshold1);
        if ra == -1
            status = [0,0,0];
        else
            status = [2,ra,rb];
        end

        disp(['dis: ', num2str(dis)]);
        disp(['dir: ', num2str(dir)]);
        disp(['ra: ', num2str(ra), ',rb: ', num2str(rb)]);
        paraTime = time(end/30*17+1:end/30*29);    %只在前端展示30s窗口中17s-29s的波形
        paraAmpQ = downsampleAmpQ(end/30*17+1:end/30*29);
        actSID = find(paraTime == actTime(1));    %以下用于生成前端中走动波形部分高亮，端点做了修正，可调
        if isempty(actSID)
            actSID = 0;
        else
            actSID = actSID + 40;
        end
        actEID = find(paraTime == actTime(2));
        actEID = min([actEID+60, length(paraTime)]);
    end
    cnt = cnt-1;
    %% == save to database
    save2DB(paraAmpQ*10, paraTime, status, [actSID, actEID]);
end
