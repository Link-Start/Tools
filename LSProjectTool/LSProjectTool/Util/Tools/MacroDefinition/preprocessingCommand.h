//
//  preprocessingCommand.h
//  LSProjectTool
//
//  Created by Xcode on 16/10/9.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef preprocessingCommand_h
#define preprocessingCommand_h

// Include any system framework and library headers here that should be included in all compilation units.
// You will also need to set the Prefix Header build setting of one or more of your targets to reference this file.

#endif /* preprocessingCommand_h */




/******** 预处理命令简介 *******/
#define：             定义一个预处理宏
#undef：              取消宏的定义
#include：            包含文件命令
#include_next：       与#include相似, 但它有着特殊的用途
#if：                 编译预处理中的条件命令, 相当于C语法中的if语句
#ifdef：              判断某个宏是否被定义, 若已定义, 执行随后的语句
#ifndef：             与#ifdef相反, 判断某个宏是否未被定义
#elif：               若#if, #ifdef, #ifndef或前面的#elif条件不满足, 则执行#elif之后的语句, 相当于C语法中的else-if
#else：               与#if, #ifdef, #ifndef对应, 若这些条件不满足, 则执行#else之后的语句, 相当于C语法中的else
#endif：              #if, #ifdef, #ifndef这些条件命令的结束标志.
#defined：             与#if, #elif配合使用, 判断某个宏是否被定义
#line：                标志该语句所在的行号
#：                    将宏参数替代为以参数值为内容的字符窜常量
##：                   将两个相邻的标记(token)连接为一个单独的标记
#pragma：              说明编译器信息
#warning               显示编译警告信息
#error：               显示编译错误信息

