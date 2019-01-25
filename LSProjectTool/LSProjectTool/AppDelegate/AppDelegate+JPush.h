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
