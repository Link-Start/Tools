//
//  DefineSystemCommand.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/26.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

//系统命令

#ifndef DefineSystemCommand_h
#define DefineSystemCommand_h


///系统宏汇集
#ifdef __FILE__         //当前文件所在目录
#ifdef __DATE__         //“替代文字"是一个含有编译日期的字符串字面值，日期格式为“mm dd yyyy"
#ifdef __FUNCTION__     //当前函数名称
#ifdef __LINE__         //当前语句在源文件中的行数
#ifdef __TIME__         //此字符串字面值包含编译时间，格式为“hh:mm:ss"
#ifdef __STDC__         //整数常量1，表示此编译器遵循ISOC标准。
#ifdef __STDC_VERSION__ //如果实现复合C89整部1，则这个宏的值为19940SL；如果实现符合C99，则这个宏的值为199901L；否则数值是未定义
#ifdef __STDC_EOBTED__  //(C99)实现为宿主实现时为1,实现为独立实现为0
#ifdef __STDC_IEC_559__ //(C99)浮点数实现复合IBC 60559标准时定义为1，否者数值是未定义
#ifdef __STDC_IEC_559_COMPLEX__ //(C99)复数运算实现复合IBC 60559标准时定义为1，否者数值是未定义
#ifdef __STDC_ISO_10646__  //(C99)定义为长整型常量，yyyymmL表示wchar_t值复合ISO 10646标准及其指定年月的修订补充，否则数值未定义


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
#：                    将宏参数替代为以参数值为内容的字符串常量
##：                   将两个相邻的标记(token)连接为一个单独的标记
#pragma：              说明编译器信息
#warning               显示编译警告信息
#error：               显示编译错误信息




/**************************************0**************************************/
//意思是 如果标识符****已被#define命令定义过，则对代码1进行编译，否则对代码2进行编译
#ifdef ****
//代码1
#else
//代码2
#endif
/**************************************1**************************************/

#pragma mark - #if判断通常是用于你想编译出两个二进制文件：一个是iPhone的、另一个是iPad的
//不要在编译时判断并定义宏,应该在运行时判断，然后定义类似常量的东西

// 判断是不是iOS系统，如果是iOS系统在真机和模拟器输出都是YES
#if TARGET_OS_IPHONE
//NSLog(@"是 iOS 系统");
#endif

/**************************************2**************************************/
#pragma mark - iOS判断是模拟器还是真机
#if TARGET_IPHONE_SIMULATOR//模拟器
#define SIMULATOR 1
#elif TARGET_OS_IPHONE//真机
#define SIMULATOR 0
#endif

/**************************************3**************************************/
//__i386__ 与 __x86_64__   ：用于模拟器环境和真机环境的判断。满足该条件的代码只在模拟器下执行
#if defined (__i386__) || defined (__x86_64__)
//模拟器下执行
#else
//真机下执行
#endif

/**************************************4**************************************/
#pragma mark - 判断是ARC还是MRC
///使用ARC和不使用ARC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif

#pragma mark -
#if !__has_feature(objc_arc)
#error LS is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#error 此demo只支持ARC,把项目改为ARC或者使用-fobjc-arc标识
#error "只支持ARC"
#endif

/**************************************5**************************************/
#pragma mark - 开发模式还是生产模式
//__OPTIMIZE__  :用于release和debug的判断，当选择了__OPTIMIZE__  时，可以让代码在release时执行，在debug时不执行
#ifdef __OPTIMIZE__
//这里执行的是release模式下
#else
//这里执行的是debug模式下
#endif

#ifdef DEBUG
//这里执行的是debug模式下
#else
//这里执行的是release模式下
#endif



/**************************************6**************************************/
#pragma mark - 判断是OC还是C++
#ifdef __cplusplus
///表示这是 C++ 文件才会编译的
#endif
#ifdef __OBJC__
///说明编译规则（按照 OC 文件编译）

#endif


/**************************************7**************************************/
#pragma mark - 64位  32位
#if defined(__LP64__) && __LP64__
//64位
#else
//32 位
#endif

#if __LP64__
// 64-bit
#endif

/**************************************8**************************************/
#pragma mark - iOS
#ifdef __IPHONE_OS_VERSION_MIN_REQUIRED  // iOS
// 只能在iOS 下
#endif

#pragma mark - MAC
#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED //MAC
// 只能在mac os x
#endif



/**************************************9**************************************/
//判断文件是否存在
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

/**************************************10**************************************/






#endif /* DefineSystemCommand_h */
