//
//  AppDelegate+UMConfiguration.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/21.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "AppDelegate+UMConfiguration.h"
//友盟
#import <UMCommon/UMCommon.h>
#import <UMCommon/MobClick.h>
#import <UMCommonLog/UMCommonLogHeaders.h>//日志
#import <UMShare/UMShare.h>//分享
#import "LSConstAppKey.h"


@interface AppDelegate ()

@end

@implementation AppDelegate (UMConfiguration)

//初始化 UMeng
-(void)initUMengConfiguration {

#if DEBUG
    //开发者需要显式的调用此函数，日志系统才能工作
    [UMCommonLogManager setUpUMCommonLogManager];
    [UMConfigure setLogEnabled:YES];//此处在初始化函数前面是为了打印初始化的日志
#endif
    [MobClick setAutoPageEnabled:YES];//设置为自动采集页面
//    [MobClick setCrashReportEnabled:YES];
    /********************************* 以上要写在友盟初始化之前 *********************************/
    
//提示：每台设备仅记录首次安装激活的渠道，如果该设备再次安装其他渠道包，则数据仍会被记录在初始的安装渠道上。 所以在测试不同的渠道时，请使用不同的设备来分别测试。
    [UMConfigure initWithAppkey:UM_appKey channel:UM_channel];
//    [UMConfigure setAnalyticsEnabled:YES];//是否开启统计 默认为YES(开启状态)
    
    
    // 要先注册微信   在设置友盟微信分享
    [UMSocialGlobal shareInstance].universalLinkDic = @{@(UMSocialPlatformType_WechatSession):@"https://user.obawang.com/ouba/",
    };
    ////微信聊天
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeChat_appId appSecret:WeChat_appSecret redirectURL:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.hyh.ouba"];
    //QQ聊天页面
    //appKey:第三方平台的appKey（QQ平台为appID） appSecret:第三方平台的appSecret（QQ平台为appKey）
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQ_appId appSecret:QQ_appKey redirectURL:@"https://a.app.qq.com/o/simple.jsp?pkgname=com.hyh.ouba"];
}

@end