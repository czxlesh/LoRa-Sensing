%���ݷ������������ڷ���֮����뽨������������֮������
function disGraph = makeDisGraph(roomNum, roomDis)
    for i = 1:roomNum
        disGraph(i,i) = 0;
        for j = i+1:roomNum
            disGraph(i,j) = disGraph(i,j-1) + roomDis(j);
            disGraph(j,i) = 0;
        end
    end
end