%计算行走距离和方向
function [dis, dir] = calDisDir(Q, wave_length)
    angle_diff = [];
    delta = [];
    for i = 1: length(Q)-1
        delta(i) = Q(i+1) - Q(i);    %切线向量
        angle_diff(i) = angle(delta(i));    %切线向量的相位
    end
    
    phase_diff = [];
    for i = 1:length(angle_diff) - 1
        phase_diff(i) = angle_diff(i+1) - angle_diff(i);    %切线向量相位的变化
    end
    
    unwarp_phase_diff = phase_diff;
    for i = 2:length(phase_diff)-1
        if phase_diff(i)>5 || phase_diff(i)<-5
            unwarp_phase_diff(i) = (phase_diff(i-1) + phase_diff(i+1)) / 2;    %切线向量相位的变化中异常点去除
        end
    end
    
    unwarp_phase = [];
    unwarp_phase(1) = unwarp_phase_diff(1);
    for i = 2:length(unwarp_phase_diff)
        unwarp_phase(i) = unwarp_phase(i-1) + unwarp_phase_diff(i);    %解绕后的切向向量相位
    end
    
    tot_phase_change = unwarp_phase(end) - unwarp_phase(1);
    dis = abs(tot_phase_change * wave_length / 4 / pi);
    if tot_phase_change > 0
        dir = 0;    %靠近
    else
        dir = 1;    %远离
    end
end