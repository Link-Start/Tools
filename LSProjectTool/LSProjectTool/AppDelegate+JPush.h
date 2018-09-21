//
//  AppDelegate+JPush.h
//  LSProjectTool
//
//  Created by macbook v5 on 2018/8/7.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "AppDelegate.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>



#ifdef DEBUG
#define JPush_isProduction  NO  //开发(测试)证书
#else
#define JPush_isProduction  YES //生产证书
#endif

@interface AppDelegate (JPush)<JPUSHRegisterDelegate>

@end
