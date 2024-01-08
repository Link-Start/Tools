//
//  编译参数OptimizationLevel.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/10/17.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#ifndef ____OptimizationLevel_h
#define ____OptimizationLevel_h

iOS之编译参数Optimization Level
https://blog.csdn.net/understand_XZ/article/details/70224227?spm=1001.2101.3001.6650.1&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-70224227-blog-49703143.235%5Ev38%5Epc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7ECTRLIST%7ERate-1-70224227-blog-49703143.235%5Ev38%5Epc_relevant_anti_vip&utm_relevant_index=2


编译参数的设置在Build Settings里面，搜索Optimization Level可以看到， 默认情况下Debug设定为None[-O0],Release设定为Fastest,Smallest[-Os]。它们有6个级别：-O0、-O（ O1）、-O2、-O3、-Os、-Ofast。

Optimization Level编译参数决定了程序在编译过程中的两个指标——编译速度和内存的占用,也决定了编译之后可执行结果的两个指标——速度和文件大小。如上所述,Optimization Level分为6个级别, 各个级别的含义如下所示。
 -O0。 默认级别。不进行任何优化,直接将源代码编译到执行文件中,结果不进行任何重排,编译时比较长。主要用于调试程序,可以进行设置断点、改变变量 、计算表达式等调试工作。Debug情况 是-O0级别。

-O （O1 ）。最常用的优化级别,不考虑速度和文件大小权衡问题。与-O0级别相比, 它生成的文件更 小,可执行的速度更快,编译时间更少。

-O2。在-O1级别基础上再进行优化, 增加指令调度的优化。与-O1级别相 ,它生成的文件大小没有变大,编译时间变长了,编译期间占用的内存更多了,但程序的运行速度有所提高。该级别是应用程序发布时的最理想级别,在增加文件大小的情况下提供了最大优化。

-O3。在-O2和-O1级别上进行优化,该级别可能会提高程序的运行速度, 是也会增加文件的大小。

-Os。这种级别用于在有限的内存和磁盘空间下生成尽可能小的文件。由于使用了很好的缓存技术, 它在某些情况下也会有很快的运行速度。该级别常用于发布iOS设备时,Release为-Os级别的情况。

-Ofast。 它是一种更为激进的编译参数, 它以点浮点数的精度为代价。
选择Optimization Level时,要权衡编译时间、编译内存占用、编译结果文件大小和执行速度等问题。
 

    一般情况下,  -O0适合于调试,   -Os级别是iOS设备上的应用发布最理想的选择。
    如果不满意这6个预定级别,用户可以自定义一个级别来编译。





#endif /* ____OptimizationLevel_h */
