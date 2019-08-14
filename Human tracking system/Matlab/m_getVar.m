%滑动窗口计算方差
function [t, fluc] = m_getVar(time, amp, ws)
    len         = length(amp);
    L           = floor(len/ws);
    t           = time(1:ws:end);
    fluc        = zeros(L,size(amp,2)).*nan;

    for i=1:L
        s = (i-1) * ws + 1;
        e = min(s + 0.5 * ws - 1, len);         % windows size 1s
        r = amp(s:e,:);
        variance    = var(r);
        fluc(i,:)   = variance;
    end
end

