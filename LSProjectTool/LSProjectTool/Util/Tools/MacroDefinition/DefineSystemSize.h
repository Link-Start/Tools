//
//  DefineSystemSize.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/26.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

//系统尺寸

#ifndef DefineSystemSize_h
#define DefineSystemSize_h
//iOS11之前导航栏默认高度为64pt(这里高度指statusBar + NavigationBar)，iOS11之后如果设置了prefersLargeTitles = YES则为96pt，默认情况下还是64pt，但在iPhoneX上由于刘海的出现statusBar由以前的20pt变成了44pt，所以iPhoneX上高度变为88pt

//状态栏高度 20/44
#define kLS_StatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
//navBar高度
#define kLS_NavigationBarHeight 44.0
//tabBar高度 49/83
#define kLS_TabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
//顶部高度 64/96/88
#define kLS_TopHeight (kLS_StatusBarHeight + kLS_NavigationBarHeight)
//底部安全距离(Home Indicator的高度宏定义)
#ifdef __IPHONE_11_0
#define kLS_iPhoneX_Home_Indicator_Height 34
#else
#define kLS_iPhoneX_Home_Indicator_Height 0
#endif



//获取屏幕宽高
#if  IOS_VERSION_8_OR_LATER
// 当前Xcode支持iOS8及以上
#define kLS_ScreenWidth ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.width)
#define kLS_ScreenHeight ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale:[UIScreen mainScreen].bounds.size.height)
#define kLS_Screen_Size ([[UIScreen mainScreen] respondsToSelector:@selector(nativeBounds)]?CGSizeMake([UIScreen mainScreen].nativeBounds.size.width/[UIScreen mainScreen].nativeScale,[UIScreen mainScreen].nativeBounds.size.height/[UIScreen mainScreen].nativeScale):[UIScreen mainScreen].bounds.size)
#else //iOS8以前
#define kLS_ScreenWidth ([[UIScreen mainScreen] bounds].size.width)
#define kLS_ScreenHeight ([[UIScreen mainScreen] bounds].size.height)
#define kLS_Screen_Size [UIScreen mainScreen].bounds.size
#define kLS_Screen_Bounds [UIScreen mainScreen].bounds
#endif


#define kLS_Iphone6ScaleWidth kLS_ScreenWidth/375.0
#define kLS_Iphone6ScaleHeight kLS_ScreenHeight/667.0
//根据ip6的屏幕来拉伸
#define kLS_RealValue(with) ((with)*(kLS_ScreenWidth/375.0f))



/****************************** 适配ios11 *************************************/
//如果不需要系统为你设置边缘距离
//如果iOS的系统是11.0，会有这样一个宏定义“#define __IPHONE_11_0  110000”；如果系统版本低于11.0则没有这个宏定义
#ifdef __IPHONE_11_0
if ([tableView respondsToSelector:@selector(setContentInsetAdjustmentBehavior:)]) {
    tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
}
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
