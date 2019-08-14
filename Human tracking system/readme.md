系统结构如下图所示

![system_plot](https://github.com/czxlesh/LoRa-Sensing/blob/master/Human%20tracking%20system/system_plot.PNG)

代码分三部分：GnuRadio、Matlab和Web

首先在Ubuntu虚拟机中运行GnuRadio流图，将数据存储到共享文件夹中。再从主机中运行Matlab代码，实时读取数据，经过计算，将生成的结果存储到数据库中。前端Web代码从数据库中读取要展示的数据并展示。
