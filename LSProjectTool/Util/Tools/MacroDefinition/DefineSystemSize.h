//
//  DefineSystemSize.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/26.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

//系统尺寸
/*
设备               屏幕尺寸    分辨率（pt）    Reader     分辨率（px）    渲染后         PPI
iPhone 3GS         3.5吋      320x480        @1x       320x480                    163
iPhone 4/4s        3.5吋      320x480        @2x       640x960                    330
iPhone 5/5s/5c     4.0吋      320x568        @2x       640x1136                   326
iPhone 6           4.7吋      375x667        @2x       750x1334                   326
iPhone 6Plus       5.5吋      414x736        @3x       1242x2208    1080x1920     401
iPhone 6s          4.7吋      375x667        @2x       750x1334                   326
iPhone 6sPlus      5.5吋      414x736        @3x       1242x2208    1080x1920     401
iPhone 7           4.7吋      375x667        @2x       750x1334                   326
iPhone 7Plus       5.5吋      414x736        @3x       1242x2208    1080x1920     401
iPhone 8
iPhone 8Plus
iPhone SE
iPhone X                      812*375                  1125*2436
iPhoneXS           5.8英寸     812*375        @3x       1125*2436
iPhoneXS Max       6.5英寸     896*414        @3x       1242x2688
iPhoneXR           6.1英       896*414        @2x       828x1792
*/

//iPhoneXR宽度828/2=414pt，iPhoneXS Max宽度1242/3=414pt；
//iPhoneXR高度1792/2=896pt，iPhoneXS Max高度2688/3=896pt；





#ifndef DefineSystemSize_h
#define DefineSystemSize_h
//iOS11之前导航栏默认高度为64pt(这里高度指statusBar + NavigationBar)，iOS11之后如果设置了prefersLargeTitles = YES则为96pt，默认情况下还是64pt，但在iPhoneX上由于刘海的出现statusBar由以前的20pt变成了44pt，所以iPhoneX上高度变为88pt
////由于iPhone X、iPhone XS、iPhone XS Max、iPhone XR这些机型的navigationBar高度以及tabBar高度都一致，所以可以用来判断当前设备是否有“齐刘海”。

//状态栏高度 20/44
#define kLS_StatusBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height)
//navBar高度
#define kLS_NavigationBarHeight 44.0
//tabBar高度 49/83
#define kLS_TabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
//顶部高度 64/96/88
#define kLS_TopHeight (kLS_StatusBarHeight + kLS_NavigationBarHeight)
//底部安全距离(Home Indicator的高度宏定义)
#define kLS_iPhoneX_Home_Indicator_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

//iPhoneX系列底部安全距离
#define kLS_iPhoneX_Series_Home_Indicator_Height ([[UIApplication sharedApplication] statusBarFrame].size.height>20?34:0)

//横屏有工具栏 20 没有 0
//iPhone X竖屏时占满整个屏幕的控制器的view的safeAreaInsets是（44，0，34，0），横屏是（0，44，21，44），inset后的区域正好是safeAreaLayoutGuide区域



//获取屏幕宽高
#if  IOS_VERSION_8_OR_LATER
// 当前Xcode支持iOS8及以上
#define kLS_ScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define kLS_ScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define kLS_Screen_Size ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else //iOS8以前
#define kLS_ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kLS_ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kLS_Screen_Size ([UIScreen mainScreen].bounds.size)
#define kLS_Screen_Bounds ([UIScreen mainScreen].bounds)
#endif


//#define kLS_Iphone6ScaleWidth        (kLS_ScreenWidth/375.0f)
//#define kLS_Iphone6ScaleHeight       (kLS_ScreenHeight/667.0f)
////相对宽度 以iphone6 4.7寸为依据
//#define kLS_relative_width(width)    ((width)*(kLS_ScreenWidth/375.0f))
////相对高度
//#define kLS_relative_height(height)  ((height)*(kLS_ScreenHeight/667.0f))

// 不同屏幕尺寸适配 以iphone6 4.7寸为依据
#define kLS_relative_Width_Ratio   (kLS_ScreenWidth / 375.0)
#define kLS_relative_Height_Ratio  (kLS_ScreenHeight / 667.0)
#define kLS_relative_Width(x)      (ceilf((x) * kLS_relative_Width_Ratio))
#define kLS_relative_Height(y)     (ceilf((y) * kLS_relative_Height_Ratio))
// 字体适配
#define ALS_relative_systemFontSize(fontsize) [UIFont systemFontOfSize:kLS_relative_Width_Ratio(fontsize)]
#define kLS_relative_FontSize(fontName,fontsize) [UIFont fontWithName:fontName size:kLS_relative_Width_Ratio(fontsize)]

/****************************** 适配ios11 *************************************/
//如果不需要系统为你设置边缘距离
//如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
#ifdef __IPHONE_11_0
//if ([tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
//    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//}
#endif


#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)


#endif /* DefineSystemSize_h */
