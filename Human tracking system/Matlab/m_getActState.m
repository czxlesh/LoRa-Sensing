%actState = 0 -> static
%actState = 1 -> walking

%actTime = [-1, -1] -> no state transition
%actTime = [sId, eId] -> state transition time

%stateTrans = 1 -> from static to walking
%stateTrans = 0 -> from walking to static

function [actState, actTime, stateTrans] = m_getActState(t, variance, threshold, lastAct)
    
    actState    = 0;
    actTime     = [-1, -1];
    stateTrans  = -1;
    
    thrVar      = ones(size(variance)).*nan;
    thrVar(variance<=threshold)   = 0;
    thrVar(variance>threshold)    = 1;
    
    thrVar(end)=thrVar(end-1);    %��ͨ�˲����±߽紦���׼����˲������һ��ķ���

    for i = 2:length(thrVar)-1    %���ݹ۲����þ��������쳣��
        if thrVar(i) ~= thrVar(i-1) && thrVar(i) ~= thrVar(i+1) && thrVar(i)==0
            thrVar(i)=thrVar(i-1);
        end
    end
    
    L = length(t);
    lastSecond = 2;    %%ȡ�������
    lastThrVar = thrVar(L-L/30*lastSecond + 1: end);
    
    if sum(lastThrVar) > 0.6*length(lastThrVar)    %%����������󲿷ַ���Ϊ1����Ϊ���߶�
        actState    = 1;
    end
    
    if actState == 0 && lastAct == 1   %just stop walking
        stateTrans = 0;
        diffVar = diff(thrVar);
        sLoc    = find(diffVar==1);    %start walking
        if isempty(sLoc)
            actTime(1) = t(1);
        else
            actTime(1) = t(sLoc(end));
        end
    
        eLoc    = find(diffVar==-1);    %end walking
        actTime(2) = t(eLoc(end));

        if actTime(2)-actTime(1)<=3 || actTime(1)==t(1)    %�˶�ʱ�����3s����Ϊ���߶�
            stateTrans = -1;
            actState = 0;
        end
    end
end