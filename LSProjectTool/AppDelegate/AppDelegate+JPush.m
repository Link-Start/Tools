//
//  AppDelegate+JPush.m
//  LSProjectTool
//
//  Created by macbook v5 on 2018/8/7.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "AppDelegate+JPush.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

//地理围栏
//#import <CoreLocation/CoreLocation.h>
//#import <PushKit/PushKit.h>//Voip

/**
 从2021年4月26日开始，AppStore上的应用程序必须在收集用于跟踪他们或他们的设备的数据之前，使用AppTrackingTransform获得用户的许可。
 使用IDFA功能必须导入AppTrakingTransparency.framework库,并且在Info.plist中添加NSUserTrackingUsageDescription和询问用户时候的描述语。
 
 Xcode 12中添加后在iOS14的设备和测试机上都没问题，但是运行在iOS14以下设备时候会崩溃。
 解决方案：
 Xcode 导入库时候AppTrackingTransparency.framework时在 Build Phases -> Link Binary With Libraries 中找到 AppTrackingTransparency.framework 状态设置为 Optional
 Optional 意思为如果 IOS系统支持就会加载
 */


@interface AppDelegate ()<JPUSHRegisterDelegate, JPUSHGeofenceDelegate
//, PKPushRegistryDelegate
>
//{
////    CLLocationManager * _locationManager;
//}

@end

@implementation AppDelegate (JPush)

//极光推送__注册方法
- (void)registerJPushWithOptions:(NSDictionary *)launchOptions {
    /************ 极光推送 ************/
    //1. 添加初始化APNs代码
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    if (@available(iOS 12.0, *)) {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound|JPAuthorizationOptionProvidesAppNotificationSettings;
    } else {
        entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    }
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
        //可以添加自定义categories
        //    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        //      NSSet<UNNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
        //    else {
        //      NSSet<UIUserNotificationCategory *> *categories;
        //      entity.categories = categories;
        //    }
    }
    //新版本的注册方法（兼容iOS10）
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
//    如果使用地理围栏，请先获取地理位置权限。
//    [self getLocationAuthority];
//    如果使用地理围栏功能，需要注册地理围栏代理
//    [JPUSHService registerLbsGeofenceDelegate:self withLaunchOptions:launchOptions];
//
    //2 . 添加初始化JPush代码
    // Optional
    // 获取IDFA
    // 如需使用IDFA功能请添加此代码并在初始化方法的advertisingIdentifier参数中填写对应值
    __block NSString *advertisingId = @"";
    if (@available(iOS 14, *)) {
        //设置Info.plist中 NSUserTrackingUsageDescription 需要广告追踪权限，用来定位唯一用户标识
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                advertisingId = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            }
        }];
    } else {
        // 使用原方式访问 IDFA
        advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    }
    
    
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions
                           appKey:@"kJPUSHAppKey"
                          channel:@"AppStore"
                 apsForProduction:JPush_isProduction
            advertisingIdentifier:advertisingId];
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0){
            NSLog(@"极光推送 registrationID获取成功：%@",registrationID);
            
        } else {
            NSLog(@"极光推送 registrationID获取失败，code：%d",resCode);
        }
    }];
    
//    //注册 voip
//    [self voipRegistration];
 
    
#pragma mark - 获取自定义消息推送内容
    /************** 极光推送自定义消息 *****************/
    //https://docs.jiguang.cn/jpush/client/iOS/ios_api/#_67
    //获取 iOS 的推送内容需要在 delegate 类中注册通知并实现回调方法。
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
}

/// 获取IDFA 广告标志符
- (NSString *)obtainIDFA {
    
    __block NSString *idfaStr = @"";
    
    // iOS14方式访问 IDFA
    if (@available(iOS 14, *)) { //
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {//用户同意授权
                idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                NSLog(@"获取IDFA 广告标志符 - %@", idfaStr);
            } else {
                NSLog(@"iOS14 用户开启了限制广告追踪");
           }
        }];
    } else {
        // 使用原方式访问 IDFA
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            NSLog(@"获取IDFA 广告标志符 - %@", idfaStr);
        } else {
            NSLog(@"用户开启了限制广告追踪");
       }
    }
    
    return idfaStr;
}

#pragma mark - 获取自定义消息推送内容
///只有在前端运行的时候才能收到自定义消息的推送。
//自定义的推送消息 设置为本地推送
//实现回调方法 networkDidReceiveMessage
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"极光推送 自定义消息:%@", userInfo);
    NSString *contents = [userInfo valueForKey:@"content"];//获取推送的内容
    NSString *messageID = [userInfo valueForKey:@"_j_msgid"];//获取推送的 messageID（key 为 @"_j_msgid"）
    NSDictionary *extras = [userInfo valueForKey:@"extras"];//获取用户自定义参数
    NSString *customizeField1 = [extras valueForKey:@"customizeField1"]; //服务端传递的 Extras 附加字段，key 是自己定义的
    
    JPushNotificationContent *content = [[JPushNotificationContent alloc] init];
    content.title = @"Test Notifications";// 推送标题
    content.subtitle = @"2016";           // 推送副标题
    content.body = @"This is a test code";// 推送内容
    content.badge = @1;                   // 角标的数字。如果不需要改变角标传@(-1)
    content.categoryIdentifier = @"Custom Category Name"; // 行为分类标识
    content.userInfo = userInfo;//设置为本地推送后，点击消息根据内容做不同操作
    
    // 5s 后提醒 iOS 10 以上支持
    JPushNotificationTrigger *trigger1 = [[JPushNotificationTrigger alloc] init];
    trigger1.timeInterval = 5;
    
    
    //[JPushNotificationRequest] 实体类型，可传入推送的属性
    JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
    //request 中传入已有推送的 request.requestIdentifier 即更新已有的推送，否则为注册新推送。
    request.requestIdentifier = @"sampleRequest";//这个 推送请求标识 要添加，否则自定义消息转本地通知时通知栏不显示
    request.content = content;
    request.trigger = trigger1;//trigger2;//trigger3;//trigger4;//trigger5;
    request.completionHandler = ^(id result) {
        NSLog(@"结果返回：%@", result);
    };
    [JPUSHService addNotification:request];//API 用于注册或更新推送
}
//用于移除待推送或已在通知中心显示的推送
- (void)testRemoveNotification {
    JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
    identifier.identifiers = @[@"sampleRequest"];
    identifier.delivered = YES;  //iOS 10 以上有效，等于 YES 则在通知中心显示的里面移除，等于 NO 则为在待推送的里面移除；iOS 10 以下无效
    [JPUSHService removeNotification:identifier];
}
//用于移除待推送或已在通知中心显示的推送
- (void)testRemoveAllNotification {
    [JPUSHService removeNotification:nil];  // iOS 10 以下移除所有推送；iOS 10 以上移除所有在通知中心显示推送和待推送请求
    //  //iOS 10 以上支持
    //  JPushNotificationIdentifier *identifier = [[JPushNotificationIdentifier alloc] init];
    //  identifier.identifiers = nil;
    //  identifier.delivered = YES;  //等于 YES 则移除所有在通知中心显示的，等于 NO 则为移除所有待推送的
    //  [JPUSHService removeNotification:identifier];
}

/************************* 极光推送 *************************/
//1. 注册APNs成功并上报DeviceToken 请在AppDelegate.m实现该回调方法并添加回调方法中的代码
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    const unsigned int *tokenBytes = [deviceToken bytes];
    NSString *tokenString = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
                          ntohl(tokenBytes[0]), ntohl(tokenBytes[1]), ntohl(tokenBytes[2]),
                          ntohl(tokenBytes[3]), ntohl(tokenBytes[4]), ntohl(tokenBytes[5]),
                          ntohl(tokenBytes[6]), ntohl(tokenBytes[7])];
    NSLog(@"Device Token: %@", tokenString);
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}
// 2. 实现注册APNs失败接口（可选）
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"极光推送注册APNs失败接口: %@", error);
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forLocalNotification:(UILocalNotification *)notification completionHandler:(void (^)())completionHandler {
}
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
}
#endif
//当程序正在运行时，收到远程推送，就会调用,如果两个方法都实现了，就只会调用上面的那个方法
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required,For systems with less than or equal to iOS6
    NSLog(@"iOS6及以下系统，收到通知 极光推送信息：%@", userInfo);
    // 取得 APNs 标准信息内容，如果没需要可以不取
    
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //    NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
    
    application.applicationIconBadgeNumber = 0;
    [JPUSHService handleRemoteNotification:userInfo];
}
////当程序处于后台或者被杀死状态，收到远程通知后，当你进入程序时，就会调用
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    // Required, iOS 7 Support
    NSLog(@"iOS7及以上系统，收到通知 极光推送信息：%@", userInfo);
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
    
    completionHandler(UIBackgroundFetchResultNewData);
}

///本地通知
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
//    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
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
//    NSLog(@"iOS 10 __应用在前台__极光推送消息: %@", userInfo);
//    NSLog(@"标题：%@", title);
//    NSLog(@"___%@", subtitle);
    
    
    /******** 1 ** 和下面的方法选择其中一个 ******/
//    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) { //应用在前台
//        // 需要执 这个 法，选择 是否提醒 户，有Badge、Sound、Alert三种类型可以选择设置
//        if (@available(iOS 10.0, *)) {
//            completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert);
//        } else {
//            // Fallback on earlier versions
//        }
//    } else if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) { //应用在后台
//        //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//        if (@available(iOS 10.0, *)) {
//            completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge);
//        } else {
//            // Fallback on earlier versions
//        }
//    } else { //未启动
//        //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
//        if (@available(iOS 10.0, *)) {
//            completionHandler(UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert|UNNotificationPresentationOptionBadge);
//        } else {
//            // Fallback on earlier versions
//        }
//    }
//
    
    
    /******** 2 ** 和上面的方法选择其中一个 ******/
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            NSLog(@"iOS10__应用在前台__收到远程通知:%@", [self logDic:userInfo]);
        } else {
            // 判断为本地通知,(自定义消息 设置为本地消息推送在这里设置)
            
            NSLog(@"iOS10__应用在前台__收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
            
            
        }
    } else {
        // Fallback on earlier versions
    }
     completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

// iOS 10 Support 在前台点击通知消息后也走didReceiveNotificationResponse方法（即后台收到通知后，点击通知的回调方法）。
#pragma mark - iOS10 __应用在后台_极光推送信息
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    // Required
    NSDictionary *userInfo = response.notification.request.content.userInfo;
//    NSLog(@"iOS10 __应用在后台_极光推送信息：%@", userInfo);
    UNNotificationRequest *request = response.notification.request; // 收到推送的请求
    UNNotificationContent *content = request.content; // 收到推送的消息内容
    NSNumber *badge = content.badge; // 推送消息的角标
    NSString *body = content.body;  // 推送消息体
    UNNotificationSound *sound = content.sound; // 推送消息的声音
    NSString *subtitle = content.subtitle; // 推送消息的副标题
    NSString *title = content.title; // 推送消息的标题
//    NSLog(@"推送消息的标题：%@ , 推送消息的副标题:%@, 推送消息体:%@", title, subtitle, body);

    if (@available(iOS 10.0, *)) {
        if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
            NSLog(@"iOS10__应用在后台__极光推送信息 收到远程通知:%@", [self logDic:userInfo]);
        } else {
            // 判断为本地通知
            NSLog(@"iOS10__应用在后台__收到本地通知:{\nbody:%@，\ntitle:%@,\nsubtitle:%@,\nbadge：%@，\nsound：%@，\nuserInfo：%@\n}",body,title,subtitle,badge,sound,userInfo);
            //自定义的推送消息 设置为本地推送之后 点击事件 可以在这里
        }
    } else {
        // Fallback on earlier versions
    }

    completionHandler();  // 系统要求执行这个方法
}
//监测通知授权状态返回的结果
- (void)jpushNotificationAuthorization:(JPAuthorizationStatus)status withInfo:(NSDictionary *)info {
  NSLog(@"receive notification authorization status:%lu, info:%@", status, info);
  [self alertNotificationAuthorization:status];
}
#endif


#ifdef __IPHONE_12_0
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    NSString *title = nil;
    if (notification) {
        title = @"从通知界面直接进入应用";
    }else{
        title = @"从系统设置界面进入应用";
    }
    UIAlertView *test = [[UIAlertView alloc] initWithTitle:title
                                                   message:@"pushSetting"
                                                  delegate:self
                                         cancelButtonTitle:@"yes"
                                         otherButtonTitles:nil, nil];
    [test show];
    
}
#endif

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




#pragma mark - 通知权限引导
// 检测通知权限授权情况
- (void)checkNotificationAuthorization {
  [JPUSHService requestNotificationAuthorization:^(JPAuthorizationStatus status) {
    // run in main thread, you can custom ui
    NSLog(@"notification authorization status:%lu", status);
    [self alertNotificationAuthorization:status];
  }];
}

// 通知未授权时提示，是否进入系统设置允许通知，仅供参考
- (void)alertNotificationAuthorization:(JPAuthorizationStatus)status {
  if (status < JPAuthorizationStatusAuthorized) {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"允许通知" message:@"是否进入设置允许通知？" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
    [alertView show];
  }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  if (buttonIndex == 1) {
    if(@available(iOS 8.0, *)) {
      [JPUSHService openSettingsForNotification:^(BOOL success) {
        NSLog(@"open settings %@", success?@"success":@"failed");
      }];
    }
  }
}



#pragma mark -JPUSHGeofenceDelegate
//进入地理围栏区域
- (void)jpushGeofenceIdentifer:(NSString * _Nonnull)geofenceId didEnterRegion:(NSDictionary * _Nullable)userInfo error:(NSError * _Nullable)error{
    NSLog(@"进入地理围栏区域");
    if (error) {
        NSLog(@"错误信息 = %@",error);
        return;
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self testAlert:userInfo];
    }else{
        // 进入后台
        [self geofenceBackgroudTest:userInfo];
    }
}
//离开地理围栏区域
- (void)jpushGeofenceIdentifer:(NSString * _Nonnull)geofenceId didExitRegion:(NSDictionary * _Nullable)userInfo error:(NSError * _Nullable)error{
    NSLog(@"离开地理围栏区域");
    if (error) {
        NSLog(@"错误信息 = %@",error);
        return;
    }
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        [self testAlert:userInfo];
    }else{
        // 进入后台
        [self geofenceBackgroudTest:userInfo];
    }
}
- (void)jpushGeofenceRegion:(NSDictionary *)geofence error:(NSError *)error {
  NSLog(@"region:%@", geofence);
}
- (void)jpushCallbackGeofenceReceived:(NSArray<NSDictionary *> *)geofenceList {
  NSLog(@"region list:%@", geofenceList);
}

//
- (void)geofenceBackgroudTest:(NSDictionary * _Nullable)userInfo{
    //静默推送：
    if(!userInfo){
        NSLog(@"静默推送的内容为空");
        return;
    }
    //TODO
    
}

- (void)testAlert:(NSDictionary*)userInfo{
    if(!userInfo){
        NSLog(@"messageDict 为 nil ");
        return;
    }
    NSString *title = userInfo[@"title"];
    NSString *body = userInfo[@"content"];
    if (title &&  body ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:body delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}


#pragma mark location  地理围栏
//- (void)getLocationAuthority{
//  _locationManager= [[CLLocationManager alloc] init];
//  if(@available(iOS 8.0, *)) {
//    [_locationManager requestAlwaysAuthorization];
//  } else {
//    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined){
//      NSLog(@"kCLAuthorizationStatusNotDetermined");
//    }
//  }
//  _locationManager.delegate = (id<CLLocationManagerDelegate>)self;
//}
//#pragma mark -CLLocationManagerDelegate
//- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
//  if (status != kCLAuthorizationStatusNotDetermined) {
//    NSLog(@"获取地理位置权限成功");
//  }
//}



#pragma mark - Voip
///**
// 注册Voip服务（以下示例代码，开发者可根据需要修改）JPush 3.3.2 JCore 2.2.4 及以上支持Voip功能
// */
//- (void)voipRegistration{
//  dispatch_queue_t mainQueue = dispatch_get_main_queue();
//  PKPushRegistry *voipRegistry = [[PKPushRegistry alloc] initWithQueue:mainQueue];
//  voipRegistry.delegate = self;
//  // Set the push type to VoIP
//  voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
//}
//#pragma mark- PKPushRegistryDelegate
//
///// 系统返回VoipToken,上报给极光服务器
//- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)pushCredentials forType:(PKPushType)type{
//    [JPUSHService registerVoipToken:pushCredentials.token];
//    NSLog(@"Voip Token: %@", pushCredentials.token);
//}
//
///**
// * 接收到Voip推送信息，并向极光服务器上报（iOS 8.0 - 11.0）
// */
//- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type{
//  // 提交回执给极光服务器
//  [JPUSHService handleVoipNotification:payload.dictionaryPayload];
//  NSLog(@"Voip Payload: %@, %@",payload,payload.dictionaryPayload);
//  // [ 示例代码 ] 发起一个本地通知
//  JPushNotificationContent *content = [[JPushNotificationContent alloc] init];;
//  content.title = @"测试标题";
//  content.body = @"测试内容";
//  JPushNotificationTrigger *triggger = [[JPushNotificationTrigger alloc] init];
//  triggger.timeInterval = 3;
//  JPushNotificationRequest *request = [[JPushNotificationRequest alloc] init];
//  request.content = content;
//  request.trigger = triggger;
//  request.requestIdentifier = @"test";
//  request.completionHandler = ^(id result) {
//    if (result) {
//      NSLog(@"添加 timeInterval 通知成功 --- %@", result);
//    }else {
//      NSLog(@"添加 timeInterval 通知失败 --- %@", result);
//    }
//  };
//  [JPUSHService addNotification:request];
//}
//
///**
// * 接收到Voip推送信息，并向极光服务器上报（iOS 11.0 以后）
// */
//- (void)pushRegistry:(PKPushRegistry *)registry didReceiveIncomingPushWithPayload:(PKPushPayload *)payload forType:(PKPushType)type withCompletionHandler:(void(^)(void))completion{
//  // 提交回执给极光服务器
//  [JPUSHService handleVoipNotification:payload.dictionaryPayload];
//  NSLog(@"Voip Payload: %@, %@",payload,payload.dictionaryPayload);
//}


@end
