//
//  CommonMacroDefinition.h
//  LSProjectTool
//
//  Created by Xcode on 16/9/9.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef CommonMacroDefinition_h
#define CommonMacroDefinition_h


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


// Xcode6之后，可能是因为大家把大量的头文件和宏定义放到pch里边，导致编译时间过长，苹果就去掉了pch文件
//
//  宏定义：

#pragma mark - 宏定义：

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
#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif
// ---------------------------3
//替换NSLog来使用，debug模式下可以打印很多方法名，行信息。
//#ifdef DEBUG
//#   define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
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


#pragma mark - 防止block循环引用
/*
 //ARC 使用__weak
 //避免宏循环引用 部分变量也需要weak 这个宏不仅仅只支持self
 //小技巧:添加@符号在前面,可以让我们的这个宏看起来更原生一些(使用时要使用@weakObj())
 //如果weak前置，当然也可以，生成的会是weakobj这样的变量名，只需要把宏中o##Weak 换成weak##o
 //1. 利用了@autoreleasepool{}这个系统的关键字来实现的
 #define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
 //在block中调用self会引起循环引用，但是在block中需要对weakSelf进行strong,保证代码在执行到block中，self不会被释放，当block执行完后，会自动释放该strongSelf
 #define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
 //2. 利用@try{}@finally{} (这部分空的@try或者空的@autoreleasepool会在编译时被优化掉，不必担心性能问题)
 //#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
 
 */

//以下代码是对__weak __typeof(self)weakSelf = self
//和__strong __typeof(weakSelf)strongSelf = weakSelf的宏定义
#ifndef ls_weakify   //如果标识符未被定义过,执行程序段 1 否则执行程序段2
    #if DEBUG
        #if __has_feature(objc_arc)
        #define ls_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
        #define ls_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define ls_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
        #define ls_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef ls_strongify
    #if DEBUG
        #if __has_feature(objc_arc)  //ARC
        #define ls_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else                        //MRC
        #define ls_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
        #define ls_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
        #define ls_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif



#pragma mark - 颜色
///设置颜色 - RGBA  (R:红, G:绿, B:蓝, A:透明度) 利用这种方法设置颜色和透明值，可不影响子视图背景色
#define RGBACOLOR(R, G, B, A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
///rgb颜色转换（16进制->10进制） UIColorFromRGB(0xeef0f2)
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



///获取系统版本
#define IOS_VERSION_F          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define IOS_VERSION_D          ([[[UIDevice currentDevice] systemVersion] doubleValue])
#define CurrentSystemVersion    ([[UIDevice currentDevice] systemVersion])



#pragma mark - 判断设备
/**
 *  ios7系统判断 判断设备的操做系统是不是ios7
 *
 *  @param BOOL
 *
 *  @return 如果是iOS7系统 返回YES
 */
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0)

/**
 *  判断是否是Retina屏
 *  @return
 */
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

///判断是否是iPhone 4
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
///判断是否是iPhone 5
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
///判断是否是iPhone 6
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
///判断是否是iPhone 6 P
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)

///手机序列号 UUID
#define kIdentifierNumber ([[UIDevice currentDevice] identifierForVendor])
///用户为设备设置的名称
#define kName [[UIDevice currentDevice] name]
///系统名称
#define kDeviceName [[UIDevice currentDevice] systemName]
///手机系统版本
#define kVERSION [[UIDevice currentDevice] systemVersion]
///手机型号(是iPhone还是iPad)
#define kPhoneModel [[UIDevice currentDevice] model]
///地方型号（国际化区域名称）
#define kLocalPhoneModel [[UIDevice currentDevice] localizedModel]
///获取当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])


///判断是否是IPhone5
#define IsIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)

//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
/**
 *  判断是否是IPad
 *  @return
 */
#define IsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPodtouch"])

///屏幕分辨率
#define SCREEN_RESOLUTION (SCREEN_WIDTH * SCREEN_HEIGHT * ([UIScreen mainScreen].scale))

///获取系统时间戳
#define kGetCurentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]



///检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)



///打印当前方法的名称。
#define kITTDPRINTMETHODNAME()   ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

/// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define kLocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define kAppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)

/**
 *  设备的 DeviceToken
 *
 *  @return
 */
#define DeviceToken @"DeviceToken"

#pragma mark - 屏幕尺寸

#if  IOS_VERSION_8_OR_LATER
// 当前Xcode支持iOS8及以上
#define kScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define kScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define kScreenSize ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)

#else //iOS8以前
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define kScreenSize [UIScreen mainScreen].bounds.size
#endif

/**
 *  keyWindow
 *
 *  @return
 */
#define kKeyWindow [UIApplication sharedApplication].keyWindow

/**
 *  KAppDelegate
 *
 *  @return
 */
#define KAppDelegate [UIApplication sharedApplication].delegate



// 当我们使用kvo或者做动画的时候需要使用keyPath，但是keyPath是字符串类型，为了防止输入错误，我们可以使用下面的自动提示宏
// 自动提示宏如下：
#define keyPath(objc,keyPath) @(((void)objc.keyPath, #keyPath))
//接下来简单对这个宏定义进行解释:
//- 宏定义里面的#号，会自动把后面的参数变成C语言的字符串
//- @(基本类型)可以对基本类型进行装箱操作（也就是基本类型转换为OC的对象）
//- 对于逗号表达式，例如：`(5, 10, 2)`会去最后一个值，为了防止前面两个值因为没有使用报警告可以这样写((void)5, (void)10, 2)，这个括号相当于return 2,所以为了把整个值转变成对象类型可以再加一个括号@(((void)5, (void)10, 2))
//- 对于@(((void)objc.keyPath, #keyPath))来说就是取keyPath位置的字符串






/**
 宏与const 的使用:
 
 很多小伙伴在定义一个常量字符串，都会定义成一个宏，最典型的例子就是服务器的地址。在此所有用宏定义常量字符的小伙伴以后就用const来定义吧！为什么呢 ？我们看看：
 
 宏的用法： 一般字符串抽成宏，代码抽成宏使用。
 
 const用法：一般常用的字符串定义成const（对于常量字符串苹果推荐我们使用const）。
 
 宏与const区别：
 
 1.编译时刻不同，宏属于预编译 ，const属于编译时刻
 
 2.宏能定义代码，const不能，多个宏对于编译会相对时间较长，影响开发效率，调试过慢，const只会编译一次，缩短编译时间。
 
 3.宏不会检查错误，const会检查错误
 
 通过以上对比，我们以后在开发中如果定义一个常量字符串就用const，定义代码就用宏
 
 我们创建一个类只要在.h和.m中包含#import <Foundation/Foundation.h>就可以，然后再.h文件声明一个字符串，在.m中实现就可以了，最后把这个类导入PCH文件中
 
 
 */



#endif /* CommonMacroDefinition_h */
