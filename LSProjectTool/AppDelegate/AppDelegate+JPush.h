//
//  AppDelegate+JPush.h
//  LSProjectTool
//
//  Created by macbook v5 on 2018/8/7.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "AppDelegate.h"


#ifdef DEBUG
#define JPush_isProduction  NO  //开发(测试)证书
#else
#define JPush_isProduction  YES //生产证书
#endif

@interface AppDelegate (JPush)

///初始化极光推送
//极光推送__注册方法
- (void)registerJPushWithOptions:(NSDictionary *)launchOptions;

@end


/**
 创建 UNNotification Service Extension 通知服务扩展
 https://developer.apple.com/documentation/usernotifications/unnotificationserviceextension?language=objc
 https://www.jianshu.com/p/c0a65526e653
 https://www.jianshu.com/p/b130368c6d66
 https://www.jianshu.com/p/7941f05e2bef
 https://www.jianshu.com/p/8c362a6dcc0e
 https://www.jianshu.com/p/734998be68dc
 http://www.qianfanyun.com/help/475
 
1. 创建 Extension
 Targets ------> File ------> New ------> Target... ------> Notification Service Extension ------> NotificationService ------> Activate
 Targets ------> Editor ------> Add Target ------> Notification Service Extension ------> NotificationService ------> Activate


 
    主  bundleID：com.xxx.xxx                                                     创建对应的推送证书
    推送bundleID：com.xxx.xxx.NotificationService                     不需要创建对应的推送证书，使用主bundleID创建的推送证书即可
 
 UNNotificationServiceExtension：负责拦截通知，对通知内容做中间处理
 UNNotificationContent：               负责自定义通知界面的。
 
 iOS 10 开始，苹果新增了UserNotifications.framework库用于对通知的扩展
 iOS 10 新增的 Notification Service Extension 功能，用 mutable-content 字段来控制。 若使用 Web 控制台，需勾选 “可选设置”中 mutable-content 选项；若使用 RESTFul API 需设置 mutable-content 字段为 true。

 创建 UNNotificationServiceExtension，选择Activate，在在info.plist文件中添加http协议防止图片视频资源加载不了.(AppTransportSecuritySettings-AllowArbitraryLoads=YES)
    
 NotificationService是通知拦截响应的类，Info.plist是NotificationsServiceExtension的配置信息。
 在NotificationService.m中，自动生成了contentHandler与bestAttemptContent两个属性。
    didReceiveNotificationRequest:withContentHandler与
    serviceExtensionTimeWillExpire方法。
 第一个方法是用于拦截通知并处理好通知
 第二个方法是当方法一资源超时则会调用默认这里走原始推送即可
 

2. 处理拦截：
    切换运行target：选择新创建的 NotificationService target运行
 
 
3. UNNotificationAction：
  UNNotificationActionOptionAuthenticationRequired  执行前需要解锁确认
  UNNotificationActionOptionDestructive  显示高亮（红色）
  UNNotificationActionOptionForeground  将会引起程序启动到前台
 //
 NSMutableArray *actionMutableArr = [[NSMutableArray alloc] initWithCapacity:1];
 UNNotificationAction * actionA = [UNNotificationAction actionWithIdentifier:@"ActionA" title:@"不感兴趣" options:UNNotificationActionOptionAuthenticationRequired];
 UNNotificationAction * actionB = [UNNotificationAction actionWithIdentifier:@"ActionB" title:@"不感兴趣" options:UNNotificationActionOptionDestructive];
 UNNotificationAction * actionC = [UNNotificationAction actionWithIdentifier:@"ActionC" title:@"进去瞅瞅" options:UNNotificationActionOptionForeground];
 UNTextInputNotificationAction * actionD = [UNTextInputNotificationAction actionWithIdentifier:@"ActionD" title:@"作出评论" options:UNNotificationActionOptionDestructive textInputButtonTitle:@"send" textInputPlaceholder:@"say some thing"];

 [actionMutableArr addObjectsFromArray:@[actionA,actionB,actionC,actionD]];

 if (actionMutableArr.count)
 {
     UNNotificationCategory * notficationCategory = [UNNotificationCategory categoryWithIdentifier:@"categoryNoOperationAction" actions:actionMutableArr intentIdentifiers:@[@"ActionA",@"ActionB",@"ActionC",@"ActionD"] options:UNNotificationCategoryOptionCustomDismissAction];
     [[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:[NSSet setWithObject:notficationCategory]];
 }

 
 
 4. 自定义UI contentExtension（长按查看通知界面）
 File ------> New ------> Target... ------> Notification Content Extension ------>

    NNotificationExtensionDefaultContentHidden 为YES 隐藏系统UI
    然后设置在NotificationService.m中设置categoryIdentifier：self.bestAttemptContent.categoryIdentifier = @"myNotificationCategory";


 
 
 5. Push开关是否打开
 Push功能完成后，我们一般会有判断App是否打开了通知开关的需求。如果用户没有打开可以提示用户再次打开，以保证Push消息能够推动给更多的用户，提高消息转化率。由于iOS10以上的通知相关API发生了较大变化，我们需要针对不同的系统版本使用不同的API来判断。具体代码如下：

 + (BOOL)isOpenNotificationSetting {
     __block BOOL isOpen = NO;
     if (@available(iOS 10.0, *)) { //iOS10及iOS10以上系统
        dispatch_semaphore_t semaphore;
        semaphore = dispatch_semaphore_create(0);
        // 异步方法，使用信号量的方式加锁保证能够同步拿到返回值
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                isOpen = YES;
            }
            dispatch_semaphore_signal(semaphore);
        }];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    } else {
        UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
        if (settings.types != UIUserNotificationTypeNone) {
            isOpen = YES;
        }
    }
    return isOpen;
 }
 由于getNotificationSettingsWithCompletionHandler:方法是一个异步方法，如果直接在回调中去判断当前的push授权状态的话，还未给isOpen赋值就已经return返回结果了。

 问题有了，那么解决方案也有很多，如代码中所示，我们使用了信号量dispatch_semaphore，功能类似于iOS开发中的锁（比如NSLock，@synchronize等），它是一种基于计数器的多线程同步机制。

 使用dispatch_semaphore_create创建信号量semaphore，此时信号量的值是0。
 异步跳过block块代码，执行dispatch_semaphore_wait，信号量的值减1。此时当前线程处于阻塞状态，等待信号量加1才能继续执行。
 block块代码异步执行，dispatch_semaphore_signal执行后发送一个信号，信号量的值加1，线程被唤醒，继续执行，给isOpen赋值，然后return，保证了每次能够正确取到当前的push开关状态。

 
 */
