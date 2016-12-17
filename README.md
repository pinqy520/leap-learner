# 写JavaScript来用神经网络识别手势

Brain.js只支持输入为一维数组，所以我们需要将多维数据拉平成一维

多维数据包括：帧->手->手指->位置和速度。

~~预处理包括：位置使用相对位置。 ~~

输出为，名字与1的键值对

首先生成噪声无意义数据，输出为空

~~无意义数据产生方法，首先用一只手描述出空间范围 x最大值最小值，y最大值最小值, z最大值最小值，速度最大值最小值（手动设置）,然后开始生成范围内的随机数~~

多个手势输入之后，brain会输出每个手势的匹配率。取最高并大于阈值的哪个

或者用深度学习

Reactive programing

响应式识别手势

先不考虑性能，最大化取数据


处理流

监听frame: ---f---f---f---f---

frame预处理: ---f1----f1----f1---

手势：     ---g1--g2--g3---g4----

选取关键帧:  ---x1---x2----x3----x4---

筛选 : ---x1----x4---

关键帧矩阵:   ---m1---m4----

训练:      ------------------t---




http://128.148.32.110/people/jfh/papers/Zeleznik-SAI-1996/paper.pdf

https://pdfs.semanticscholar.org/dd74/19df61e774f03839eb1908aa5f7d881bba3c.pdf

用隐马尔可夫链做手势识别
https://www.cmpe.boun.edu.tr/pilab/pilabfiles/similar/gestureinterface/CKeskinICANNPaper.pdf

各种手势识别方式的调研
https://arxiv.org/pdf/1303.2292.pdf

总结了当前3D手势识别的一些成果
https://www.hindawi.com/journals/isrn/2013/514641/

Leap Motion的文档
https://developer.leapmotion.com/documentation/v2/javascript/api/Leap_Classes.html
