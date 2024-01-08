//
//  AppDelegate+UMConfiguration.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/21.
//  Copyright © 2021 Link-Start. All rights reserved.
//
/**
 https://developer.umeng.com/docs/128606/detail/129467
 微信原生SDK有包含微信支付和不包含微信支付两个版本，友盟UShare微信分享组件中不包含微信支付模块，所以UShare SDK里的WXApiObject文件里没有PayReq对象
 用微信包含支付的库文件替换方式只能通过上述手动集成方式完成，因为自动集成方式这样替换会校验不通过，因此要想同时使用支付和分享功能，请您采用手动集成方式
 */

#import "AppDelegate+UMConfiguration.h"
//友盟
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>//日志
#import <UMShare/UMShare.h>//分享
#import <UMPush/UMessage.h>
#import "LSConstAppKey.h"


@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate (UMConfiguration)

//初始化 UMeng
-(void)initUMengConfigurationWithOptions:(NSDictionary *)launchOptions {

#if DEBUG
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];//此处在初始化函数前面是为了打印初始化的日志
#endif
    [MobClick setAutoPageEnabled:YES];//设置为自动采集页面
//    [MobClick setCrashReportEnabled:YES];
    /********************************* 以上要写在友盟初始化之前 *********************************/
    
    // 初始化友盟所有组件产品
    //提示：每台设备仅记录首次安装激活的渠道，如果该设备再次安装其他渠道包，则数据仍会被记录在初始的安装渠道上。 所以在测试不同的渠道时，请使用不同的设备来分别测试。也可使用集成测试功能进行测试，
    [UMConfigure initWithAppkey:UM_appKey channel:UM_channel];
    
//    [UMConfigure setAnalyticsEnabled:YES];//是否开启统计 默认为YES(开启状态)
    
    // // UMConfigure 通用设置，请参考SDKs集成做统一初始化
    // 初始化U-Share及第三方平台
    // U-Share 平台设置
    [self confitUShareSettings];
    [self configUSharePlatforms];
    
    // UMPush
    // 推送
    [self confitUMPushSettingsWithOptions:launchOptions];
}

// U-Share 设置
- (void)confitUShareSettings {
    // 打开图片水印
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;

    /** 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
         <key>NSAppTransportSecurity</key>
         <dict>
         <key>NSAllowsArbitraryLoads</key>
         <true/>
         </dict>
         */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
    
    // 1. universalLink
     
     // 微信、QQ、微博完整版会校验合法的universalLink，不设置会在初始化平台失败
     //配置微信Universal Link需注意 universalLinkDic的key是rawInt类型，不是枚举类型 ，即为 UMSocialPlatformType.wechatSession.rawInt
     [UMSocialGlobal shareInstance].universalLinkDic = @{
         @(UMSocialPlatformType_WechatSession):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/",
         @(UMSocialPlatformType_QQ):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/qq_conn/101830139",
         @(UMSocialPlatformType_Sina):@"https://umplus-sdk-download.oss-cn-shanghai.aliyuncs.com/"
     };
     
     //extraInitDic，企业微信增加了corpid和agentid，故在UMSocialGlobal的全局配置里面增加extraInitDic来存储额外的初始化参数。extraInitDic的key:corpId和agentId为固定值
     [UMSocialGlobal shareInstance].extraInitDic = @{
         @(UMSocialPlatformType_WechatWork):@{@"corpId":@"wwac6ffb259ff6f66a",
                                              @"agentId":@"1000002"}
     };
    
    //    // 要先注册微信   在设置友盟微信分享
    //    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://user.obawang.com/ouba/",
    //    };
    //    ////微信聊天
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChat_appId appSecret:WeChat_appSecret redirectURL:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.hyh.ouba"];
    //    //QQ聊天页面
    //    //appKey:第三方平台的appKey（QQ平台为appID） appSecret:第三方平台的appSecret（QQ平台为appKey）
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_appId appSecret:QQ_appKey redirectURL:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.hyh.ouba"];
}

/**
 https://developer.umeng.com/docs/128606/detail/193653
 集成完整版的微信、QQ和微博必须要配置Universal link，从 v6.10.3 分享SDK及以后，微博也一定要配置Universal link
 */
// 配置U-Share 分享平台
- (void)configUSharePlatforms {
    // 设置微信的appKey和appSecret
   [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
   /*设置小程序回调app的回调*/
   [[UMSocialManager defaultManager] setLauchFromPlatform:(UMSocialPlatformType_WechatSession) completion:^(id userInfoResponse, NSError *error){
       NSLog(@"setLauchFromPlatform:userInfoResponse:%@",userInfoResponse);
   }];
   /*
        * 移除相应平台的分享，如微信收藏
        */
   //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];

   /* 设置分享到QQ互联的appID，
        * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
       */
   [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1105821097"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];

   /* 设置新浪的appKey和appSecret */
   [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
}
#pragma mark - 友盟分享

/**
 https://developer.umeng.com/docs/128606/detail/129467
 使用微信支付/没有PayReq这个类
    使用UShare微信分享\登录功能情况下如何使用微信支付功能

 问题描述：
    使用UShare微信分享\登录功能情况下如何同时使用微信支付功能？为什么WXApiObject文件里没有PayReq这个类？
 
 问题原因：
    微信原生SDK有包含微信支付和不包含微信支付两个版本，友盟UShare微信分享组件中不包含微信支付模块，所以UShare SDK里的WXApiObject文件里没有PayReq对象
 
 解决方案：
    1、首先在微信开放平台下载带支付功能的SDK并添加至工程中，调用接口同样参照微信官方文档
        iOS开发工具包（直接提供.a静态库文件的形式，2.0.2版本，包含支付功能）。（https://developers.weixin.qq.com/doc/oplatform/Downloads/iOS_Resource.html）
    2、必须集成友盟分享微信完整版。
    3、用微信官方包含支付功能的库libWeChatSDK.a及相关的头文件：WxApiObject.h、WxApi.h和WechatAuthSDK.h替换掉UShare组件中同名的库文件和头文件
      --其他UShare相关库文件仍然需要添加至工程中，
        --linSocialOffcialWechat.a代表了微信完整版，
        --libSocialWeChat.a代表了微信精简版（友盟微信完整版代码依赖精简版代码功能，但是不会出现只集成微信精简版“未验证应用“问题），
        --这两个文件也必须要添加
    ！！！--注意：用微信包含支付的库文件替换方式只能通过上述手动集成方式完成，因为自动集成方式这样替换会校验不通过，因此要想同时使用支付和分享功能，请您采用手动集成方式
 
 */
#pragma mark - 设置系统回调,支持所有iOS系统(此方法在swift4.1(Xcode 9.3)已废弃，Objective-C项目不影响)
// 设置系统回调
// 支持所有iOS系统
// 注：此方法在swift4.1(Xcode 9.3)已废弃，Objective-C项目不影响。 新浪平台外的其他平台可在swift项目中使用下面两种回调方法。
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}
#pragma mark - 仅支持iOS9以上系统, iOS8及以下系统不会回调
//仅支持iOS9以上系统
//iOS8及以下系统不会回调
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id>*)options {
    
    //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if(!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - 支持目前所有iOS系统
//支持目前所有iOS系统
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

#pragma mark - 设置Universal Links系统回调
//设置Universal Links系统回调
//用户可以自行捕获Universal Links系统回调
//注：这里的回调是指分享模块的回调，和智能超链U-Link也有系统回调，那个是Deeplink唤醒的回调，二者回调是互相独立的。假如您同时需要分享功能和deeplink唤起功能，那么二者都需要设置
//微信和QQ完整版都需要开发者配置正确的Universal link和对应的Universal link系统回调，详情可以看文档
-(BOOL)application:(UIApplication*)application continueUserActivity:(NSUserActivity*)userActivity restorationHandler:(void(^)(NSArray* __nullable restorableObjects))restorationHandler {
    
    //step1 判断支付
       //支付会包含微信的appid和pay字段
       //例如:
       //https://xxx/wx60d36f0847db422c/pay/?returnKey=&ret=0
//       NSString *webpageStr = userActivity.webpageURL.absoluteString;
//       if ([webpageStr containsString:@"wx60d36f0847db422c"] && [webpageStr containsString:@"pay"]) {
//           BOOL isok =  [WXApi handleOpenUniversalLink:userActivity delegate:self];
//           if (isok) {
//               return YES;
//           }
//       }

       //step2 分享，授权回调
    if (![[UMSocialManager defaultManager] handleUniversalLink:userActivity options:nil]) {
        // 其他SDK的回调
    }
    return YES;
}

/// 分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）,到对应平台
/// 分享图片 到对应平台(UMSocialPlatformType)
- (void)shareImageObjectToPlatformWithPlatForm:(NSInteger)platform shareImage:(id)shareImage thumImage:(id)thumImage {
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建图片内容对象
    UMShareImageObject *shareObject = [UMShareImageObject shareObjectWithTitle:@"" descr:@"" thumImage:thumImage]; //大图底部的小图标
    
    if ([(NSString *)shareImage containsString:@"http:"]) {
        //当前网络请求是否用https
        [UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    }
    //分享单个图片（支持UIImage，NSdata以及图片链接Url NSString类对象集合）
    shareObject.shareImage = shareImage;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************分享失败，错误信息(Share fail with error) ：%@*********",error);
        } else {
            NSLog(@"response data is %@",data);
        }
    }];
}

///分享
/// 标题，描述，缩略图
- (void)shareWithLink:(NSString *)link title:(NSString *)title descr:(NSString *)descr thumImage:(id)thumImage platform:(NSInteger)platform {
    
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    //创建网页内容对象
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:descr thumImage:thumImage];
    //设置网页地址，不能为空且长度不能超过10K
    shareObject.webpageUrl = link;
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platform messageObject:messageObject currentViewController:nil completion:^(id data, NSError *error) {
        if (error) {
            NSLog(@"************分享失败，错误信息(Share fail with error)： %@*********",error);
        } else {
            NSLog(@"response data is %@",data);
        }
    }];
}


#pragma mark - 消息推送
//为了保证项目开屏的美观，请务必添加完整的LaunchImage启动图，或者一个添加一张750 * 1334的名为Launchplaceholder的图片（否则会显示一个黑屏状态或其他异常情况）。
//如果要适配iOS7，请务必添加完整的LaunchImage启动图，或者在LaunchImage添加一张640*1136的图片。
//说明 注意：不支持横屏
#pragma mark -
// https://developer.umeng.com/docs/67966/detail/66734

/// 普通推送详细集成
- (void)confitUMPushSettingsWithOptions:(NSDictionary *)launchOptions {
    // Push组件基本功能配置
    UMessageRegisterEntity *entity =[[UMessageRegisterEntity alloc] init];
    //type是对推送的几个参数的选择，可以选择一个或者多个。默认是三个全部打开，即：声音，弹窗，角标
        entity.types = UMessageAuthorizationOptionBadge | UMessageAuthorizationOptionSound | UMessageAuthorizationOptionAlert;
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
    
    // launchOptions：存储程序启动的原因
    // entity：Push注册配置类
    // completionHandler：iOS10以上的通知认证回调
    [UMessage registerForRemoteNotificationsWithLaunchOptions:launchOptions Entity:entity completionHandler:^(BOOL granted, NSError *_Nullable error) {
        if (granted) {
            
        } else {
            
        }
    }];
}

#pragma mark -  设置UNUserNotificationCenterDelegate回调函数
/**
 PushSDK目前有撤销功能，里面用到静默推送的功能，PushSDK内部处理了撤销功能，并调用了completionHandler(UIBackgroundFetchResultNewData)，
 如果客户需要用到撤销功能，在重载时，不需要再调用completionHandler(UIBackgroundFetchResultNewData)，否则会引起崩溃。
 如果需要调用completionHandler(UIBackgroundFetchResultNewData)，需要过滤PushSDK的撤销功能
 */
/// //iOS10以下使用这两个方法接收通知
/// 1.
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void(^)(UIBackgroundFetchResult))completionHandler {
    //....TODO
    
    [UMessage setAutoAlert:NO];
    if([[[UIDevice currentDevice] systemVersion]intValue] < 10) {
        [UMessage didReceiveRemoteNotification:userInfo];
    }
    
    //过滤掉Push的撤销功能，因为PushSDK内部已经调用的completionHandler(UIBackgroundFetchResultNewData)，
    //防止两次调用completionHandler引起崩溃
    if (![userInfo valueForKeyPath:@"aps.recall"]) {
          completionHandler(UIBackgroundFetchResultNewData);
     }
}

// 2.
//iOS10新增：处理前台收到通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void(^)(UNNotificationPresentationOptions))completionHandler {
    
    NSDictionary *userInfo = notification.request.content.userInfo;
    
    if ([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [UMessage setAutoAlert:NO];
        //应用处于前台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
        
    } else {
        //应用处于前台时的本地推送接受
    }
    completionHandler(UNNotificationPresentationOptionSound | UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionAlert);
}

//iOS10新增：处理后台点击通知的代理方法
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
    
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    
    if ([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //应用处于后台时的远程推送接受
        //必须加这句代码
        [UMessage didReceiveRemoteNotification:userInfo];
    } else {
        //应用处于后台时的本地推送接受
    }
}










@end

/** iOS开发 友盟推送环境和打包类型 https://www.jianshu.com/p/138e551d6361

 打包时可以选择 appstore、adhoc、development三种模式
 上面三种模式决定了安装包的推送环境
 一般导出类型为adhoc、appstore包对应着生产环境的推送；
          而development对应着开发环境的推送。
 
这里切记 :
    测试友盟推送：测试(开发)环境打包选择development
              正式(生产)环境打包选择adhoc
 否则可能导致 deviceToken 错误( bad deviceToken) ,导致推送不成功

*/
