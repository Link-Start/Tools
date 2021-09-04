//
//  DefineSystemVersion.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/26.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

//系统版本

#ifndef DefineSystemVersion_h
#define DefineSystemVersion_h


///IOS系统版本 版本判断
#define IOSAVAILABLEVERSION(version) ([[UIDevice currentDevice] availableVersion:version] < 0)

///检查系统版本
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)


///获取当前 手机的 系统版本
//这个方法不是特别靠谱
#define kLS_GetCurrentSystemVersion_F          ([[[UIDevice currentDevice] systemVersion] floatValue])
//这个方法不是特别靠谱
#define kLS_GetCurrentSystemVersion_D          ([[[UIDevice currentDevice] systemVersion] doubleValue])
//建议使用这个方法
#define kLS_GetCurrentSystemVersion            ([[UIDevice currentDevice] systemVersion])

//获取当前 APP的 版本  
#define kLS_GetCurrentAPPVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

// ios7系统判断 判断设备的操做系统是不是ios7 如果是iOS7系统 返回YES
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)



////使用 @available 导致旧版本 Xcode 编译出错。
////在 Xcode 11 的 SDK 工程的代码里面使用了 @available 判断当前系统版本，打出来的包放在 Xcode 10 中编译，会出现错误
//#ifndef __IPHONE_13_0
//#define __IPHONE_13_0 130000
//#endif
//
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
//
//#endif

#endif /* DefineSystemVersion_h */
