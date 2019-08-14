%根据房间数量和相邻房间之间距离建立任意两房间之间距离表
function disGraph = makeDisGraph(roomNum, roomDis)
    for i = 1:roomNum
        disGraph(i,i) = 0;
        for j = i+1:roomNum
            disGraph(i,j) = disGraph(i,j-1) + roomDis(j);
            disGraph(j,i) = 0;
        end
    end
end