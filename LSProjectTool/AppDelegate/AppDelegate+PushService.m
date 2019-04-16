//
//  AppDelegate+PushService.m
//  MiAiApp
//
//  Created by 徐阳 on 2017/5/25.
//  Copyright © 2017年 徐阳. All rights reserved.
//

#import "AppDelegate+PushService.h"

//极光推送
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
//// 如果需要使用idfa功能所需要引入的头文件（可选）
//#import <AdSupport/AdSupport.h>

@implementation AppDelegate (PushService)

/************************* 极光推送 *************************/
//1. 注册APNs成功并上报DeviceToken 请在AppDelegate.m实现该回调方法并添加回调方法中的代码
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
// 2. 实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"极光推送注册APNs失败接口: %@", error);
}
// 3. 添加处理APNs通知回调方法
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
#pragma mark - iOS 10 __应用在前台__极光推送消息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary *userInfo = notification.request.content.userInfo;
    UNNotificationRequest *request = notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge; // 推送消息的角标
    NSString *body = content.body;  // 推送消息体
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *title = content.title; // 推送消息的标题
    NSLog(@"iOS 10 __应用在前台__极光推送消息: %@", userInfo);
    NSLog(@"标题：%@", title);
    NSLog(@"___%@", subtitle);
    
//    [kLS_NotificationCenter postNotificationName:kNotification_changePriceReloadData object:nil];
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) { //应用在前台
        // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置
        if (@available(iOS 10.0, *)) {
            completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
        } else {
            // Fallback on earlier versions
        }
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) { //应用在后台
        //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        if (@available(iOS 10.0, *)) {
            completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge);
        } else {
            // Fallback on earlier versions
        }
    } else { //未启动
        //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        if (@available(iOS 10.0, *)) {
            completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge);
        } else {
            // Fallback on earlier versions
        }
    }
    
    
    
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            //            NSLog(@"iOS10 前台收到远程通知:%@", [self logDic:userInfo]);
        } else {
            // 判断为本地通知
            
            NSLog(@"iOS10 前台收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        }
    } else {
        // Fallback on earlier versions
    }
}

// iOS 10 Support
#pragma mark - iOS10 __应用在后台_极光推送信息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    NSLog(@"iOS10 __应用在后台_极光推送信息：%@", userInfo);
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge; // 推送消息的角标
    NSString *body = content.body;  // 推送消息体
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *title = content.title; // 推送消息的标题
    NSLog(@"推送消息的标题：%@ , 推送消息的副标题:%@, 推送消息体:%@", title, subtitle, body);
    
//    //点击推送消息跳转到消息界面
//    MessageVC *vc = [[MessageVC alloc] init];
//    vc.isFirstShowSystemNotice = YES;
//
//    LSTabBarController *tabBarCon = (LSTabBarController *)self.window.rootViewController;
//    LSNavigationController *nav = (LSNavigationController *)tabBarCon.selectedViewController;
//    [nav.topViewController.navigationController pushViewController:vc animated:YES];
//
//    ///
//    [kLS_NotificationCenter postNotificationName:kNotification_changePriceReloadData object:nil];
    
    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            //            NSLog(@"iOS10 收到远程通知:%@", [self logDic:userInfo]);
        } else {
            // 判断为本地通知
            
            NSLog(@"iOS10 收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
        }
    } else {
        // Fallback on earlier versions
    }
    
    
    
    completionHandler();  // 系统要求执行这个方法
}
////当程序处于后台或者被杀死状态，收到远程通知后，当你进入程序时，就会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    // Required, iOS 7 Support
    NSLog(@"iOS7 极光推送信息：%@", userInfo);
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    
    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
    application.applicationIconBadgeNumber = 0;
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) { //应用在前台
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:sureAction];
        [alertC addAction:cancelAction];
        
    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) { //应用在后台
        
    } else { //未启动
        
    }
    
}
//当程序正在运行时，收到远程推送，就会调用,如果两个方法都实现了，就只会调用上面的那个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    NSLog(@"iOS6之前 极光推送信息：%@", userInfo);
    // 取得 APNs 标准信息内容，如果没需要可以不取
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
    
    
    application.applicationIconBadgeNumber = 0;
    [JPUSHService handleRemoteNotification:userInfo];
}

///打印log
- (NSString *)logDic:(NSDictionary *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    NSLog(@"%@", str);
    return str;
}

@end
