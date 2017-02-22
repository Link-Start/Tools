//
//  MacroDefinition.h
//  Test
//
//  Created by Xcode on 16/5/17.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
// Xcode6之后，可能是因为大家把大量的头文件和宏定义放到pch里边，导致编译时间过长，苹果就去掉了pch文件
//
//  宏定义：

#pragma mark - 宏定义：

#import <UIKit/UIKit.h>

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
//#ifdef DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"%s:%d\t %s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//#else
//#define NSLog(...)
//#endif
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




#pragma mark - iOS判断是模拟器还是真机
#if TARGET_IPHONE_SIMULATOR//模拟器
#define SIMULATOR 1
#elif TARGET_OS_IPHONE//真机
#define SIMULATOR 0
#endif


#pragma mark - 判断是ARC还是MRC
///使用ARC和不使用ARC
#if __has_feature(objc_arc)
// ARC
#else
// MRC
#endif


#ifdef __cplusplus
///表示这是 C++ 文件才会编译的
#endif
#ifdef __OBJC__
///说明编译规则（按照 OC 文件编译）

#endif


#pragma mark - 防止block循环引用
/*
//ARC 使用__weak
//避免宏循环引用 部分变量也需要weak 这个宏不仅仅只支持self
//小技巧:添加@符号在前面,可以让我们的这个宏看起来更原生一些(使用时要使用@weakObj())
*/
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




#pragma mark - #if判断通常是用于你想编译出两个二进制文件：一个是iPhone的、另一个是iPad的
//不要在编译时判断并定义宏,应该在运行时判断，然后定义类似常量的东西

//Objective-C的检查方式
///通过条件编译的方式判断是否是某个系统版本之上
#if __IPHONE_OS_VERSION_MIN_REQUIRED < __IPHONE_7_0
// 调用7.0以后才支持的API
#endif



#pragma mark - 颜色
///设置颜色 - RGBA  (R:红, G:绿, B:蓝, A:透明度) 利用这种方法设置颜色和透明值，可不影响子视图背景色
#define RGBACOLOR(R, G, B, A) [UIColor colorWithRed:(R)/255.0 green:(G)/255.0 blue:(B)/255.0 alpha:(A)]
///rgb颜色转换（16进制->10进制） UIColorFromRGB(0xeef0f2)
#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]



///获取系统版本
///这个方法不是特别靠谱
#define IOS_VERSION_F          ([[[UIDevice currentDevice] systemVersion] floatValue])
///这个方法不是特别靠谱
#define IOS_VERSION_D          ([[[UIDevice currentDevice] systemVersion] doubleValue])
///建议使用这个方法
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





//建议使用前两种宏定义,性能高于后者
//----------------------图片----------------------------
//----------------------颜色类---------------------------
// rgb颜色转换（16进制->10进制）
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
//带有RGBA的颜色设置
#define COLOR(R, G, B, A) [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
// 获取RGB颜色
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
#define RGB(r,g,b) RGBA(r,g,b,1.0f)
//背景色
#define BACKGROUND_COLOR [UIColor colorWithRed:242.0/255.0 green:236.0/255.0 blue:231.0/255.0 alpha:1.0]
//清除背景色
#define CLEARCOLOR [UIColor clearColor]
#pragma mark - color functions
#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]



/* ******************图片 的宏定义 -- 优先使用前两种宏定义,性能高于后面***********************/
///读取本地图片
#define LOADIMAGE(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:file ofType:ext]]
///定义UIImage对象//    imgView.image = IMAGE(@"Default.png");
#define IMAGE(A) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:A ofType:nil]]
//定义UIImage对象
#define ImageNamed(_pointer) [UIImage imageNamed:[UIUtil imageName:_pointer]]
//可拉伸的图片
#define ResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define ResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]



//获取temp
#define kPathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kPathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kPathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]



//角度转弧度
#define DEGREES_TO_RADIANS(d) (d * M_PI / 180)
//由弧度获取角度
#define radianToDegrees(radian) (radian*180.0)/(M_PI)

//自动提示宏：就是在输入宏的时候有提示功能 自动提示宏：（objc.keyPath）这一部分内容，仅仅是让你的宏具有提示功能
#define keyPath(objc,keyPath) @(((void)objc.keyPath, #keyPath))

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



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MacroDefinition : NSObject
/*
 NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END。
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull(不能为空)，因此我们只需要去指定那些nullable(可以为空)的指针
 */
@end
NS_ASSUME_NONNULL_END


