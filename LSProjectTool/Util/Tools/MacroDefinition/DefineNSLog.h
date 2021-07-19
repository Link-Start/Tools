//
//  DefineNSLog.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/26.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

//打印信息

#ifndef DefineNSLog_h
#define DefineNSLog_h

#pragma mark - NSLog 打印
// 项目打包上线都不会打印日志，因此可放心。
//__VA_ARGS__ 是一个可变参数的宏，这个可变参数的宏是新的C99规范中新增的，目前似乎只有gcc支持（VC6.0的编译器不支持）。实现思想就是宏定义中参数列表的最后一个参数为省略号（也就是三个点）。这样预定义宏_ _VA_ARGS_ _就可以被用在替换部分中，替换省略号所代表的字符串。
//重新定义系统的NSLog，__OPTIMIZE__ 是release 默认会加的宏
//---------------------------1
//#ifndef __OPTIMIZE__                         ////调试状态 -- 打印日志
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else                                        ////发布状态 -- 不会打印日志
//#define NSLog(...){}
//#endif
// ---------------------------2
////NSLog的使用效率比较低，所以在我们的项目中非调试状态下不应该出现大量的NSLog,让调试打印函数只在调试的时候有用，发布的时候就不能使用。
// 让NSLog打印我们输出的内容,附加输出文件名和打印语句的行号
#ifdef DEBUG
#define NSLog(FORMAT, ...) fprintf(stderr,"[文件名：%s]:[函数名：%s]:[行号：%d]\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif
// ---------------------------3
//替换NSLog来使用，debug模式下可以打印很多方法名，行信息。
//#ifdef DEBUG
//#   define NSLog(fmt, ...) NSLog((@"%s 行数:[Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define NSLog(...)
//#endif
// ---------------------------4
//直接替换NSLog
//#if DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif
// ---------------------------5
//DEBUG  模式下打印日志,当前行以及弹出一个警告
//#ifdef DEBUG
//#   define NSLog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
//#else
//#   define NSLog(...)
//#endif
// ---------------------------6
//自己写的
//#ifdef DEBUG
//#   define LSLog(fmt, ...) NSLog((@"\n\t\t  /-\\ \n************  ************" @"\n\t控制器：%s \n\t方法：%s 行数：[Line %d] \n\t打印信息：" fmt @"\n************  ************\n\t\t  \\-/"), [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//#   define LSLog(...)
//#endif


//
////修复打印不完整，打印中文显示Unicode码问题
//#ifndef __OPTIMIZE__
//#define NSLog(FORMAT, ...) fprintf(stderr, "[%s %s %s-%d] %s\n", __DATE__ , __TIME__, [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]?[[[NSString alloc] initWithData:[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] dataUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding] UTF8String]:[[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);
//#else
//#define NSLog(FORMAT, ...) nil
//#endif


#endif /* DefineNSLog_h */
