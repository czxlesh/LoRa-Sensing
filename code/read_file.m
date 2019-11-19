function [signal] = read_file(path, prefix, N)
%READ_FILE 从文件中读取信号并返回
%   path是路径文件夹
%   prefix是同一组数据文件名的共同前缀
%   N是天线数量
%   文件名的一般格式是prefix_i.dat，i是天线编号（从1开始）
rawData = [];
shortestLen = 1e10;
for i = 1:N
    file = fopen([path, prefix, num2str(i), '.dat']);
    readStr = ['rawData' num2str(i) '= fread(file, ''float32'');'];
    shortStr = ['shortestLen = min(shortestLen, length(rawData' num2str(i) '));'];
    eval(readStr);
    eval(shortStr);
    fclose(file);
end

signal = zeros(shortestLen/2, N);
for i = 1:N
    copyStr = ['rawData=rawData' num2str(i) ';'];
    eval(copyStr);
    rawData = rawData(1:shortestLen);
    is = rawData(1:2:end);
    qs = rawData(2:2:end);
    signal(:,i) = complex(is, qs);
end
end
