//
//  AppDelegate+UMConfiguration.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/21.
//  Copyright © 2021 Link-Start. All rights reserved.
//



#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (UMConfiguration)

/// 初始化友盟 UMeng
-(void)initUMengConfigurationWithOptions:(NSDictionary *)launchOptions;

@end

NS_ASSUME_NONNULL_END

/**
 --------------
 重要：iOS 15限制了配置的URL Scheme不可以超过50个
 --------------
 白名单：LSApplicationQueriesSchemes
 https://developer.umeng.com/docs/128606/detail/129507
 
 配置SSO白名单：https://developer.umeng.com/docs/66632/detail/66825#h3--sso-
 U-Share集成文档：https://developer.umeng.com/docs/66632/detail/66825#h3--sso-
 
 ------------------------------------------
集成测试
 集成测试必备配置
    1.需集成7.3.0及以上版本的iOS SDK
    2.配置URL Schemes
        a.新版集成测试需要配置App的URL Scheme，URL Scheme 位于项目设置 target -> 选项卡 Info - > URL Types，填入的URL Schemes：um.该app的appkey。
        b.在AppDelegate中调用函数[MobClick handleUrl:] 来接收 URL
        //iOS9以上使用以下方法
        - (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
                if ([MobClick handleUrl:url]) {
                    return YES;
                }
                //其它第三方处理
                return YES;
            }

        //iOS9及以下使用以下方法
        - (BOOL)application:(UIApplication *)application openURL:(nonnull NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation {
            if ([MobClick handleUrl:url]) {
                return YES;
            }
            //其它第三方处理
            return YES;
        }
 --------------------------------------------------------
 集成测试结果查看
 产品入口：https://mobile.umeng.com/platform/config/check/realtimelog
 操作指南：https://developer.umeng.com/docs/119267/detail/119463#h1-7t3-mtg-py
 ----------------------------------------------------------------------
 */
