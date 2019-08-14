%匹配出最合适的行走路线
function [ra, rb] = roomMatch(roomNum, disGraph, dis, dir, var, threshold)
    ra=-1;
    rb=-1;
    maxDis = -1;
    for i = 1:roomNum
        for j = i+1:roomNum
            if disGraph(i,j)<=dis && disGraph(i,j)>maxDis
                maxDis = disGraph(i,j);
            end
        end
    end
    
    a=[];
    b=[];
    for i = 1:roomNum
        for j = i+1:roomNum
            if disGraph(i,j)<=maxDis && maxDis-disGraph(i,j)<=2
                a(end+1)=i;
                b(end+1)=j;
            end
        end
    end
    
    if isempty(a)
        return;
    end
    
    if length(a)>1
        thrVar = [];
        thrVar = var(var>threshold);
        if isempty(thrVar)
            ra = a(1);
            rb = b(1);
        else
            ra = a(2);
            rb = b(2);
        end
    else
        ra = a(1);
        rb = b(1);
    end
    
    if dir == 1
        t = ra;
        ra = rb;
        rb = t;
    end
end