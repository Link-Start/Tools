//
//  AppDelegate+configuration.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2019/1/30.
//  Copyright © 2019年 Link-Start. All rights reserved.
//

#import "AppDelegate+configuration.h"
#import "XHLaunchAd.h"
#import "MacroDefinition.h"


@interface AppDelegate ()<XHLaunchAdDelegate>

@end

@implementation AppDelegate (configuration)

///初始化 配置
- (void)initBasicConfiguration {
    
    /****************** 基本设置 ******************/
    //状态栏的字体为白色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //在启动之后显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //设置UIView、UIImageView、UILabel。button等 接收手势的互斥性为YES，防止多个响应区域被“同时”点击，“同时”响应
    [[UIButton appearance] setExclusiveTouch:YES];
    

    /****************** 添加图片开屏广告 ******************/
    [self getLaunchImage];
}

//获取启动页
- (void)getLaunchImage {
    
    
    
//    LS_WeakSelf(self);
//    LS_StrongSelf(self);
    
    //1.使用默认配置初始化
    //设置你工程的启动页使用的是:LaunchImage 还是 LaunchScreen.storyboard(不设置默认:LaunchImage)
    [XHLaunchAd setLaunchSourceType:SourceTypeLaunchScreen];
    
    //防止启动的时候会先进入根控制器后,再显示广告页面
    [XHLaunchAd setWaitDataDuration:3];//设置数据等待时间
    //配置广告数据
    XHLaunchImageAdConfiguration *imageAdconfiguration = [XHLaunchImageAdConfiguration defaultConfiguration];
    imageAdconfiguration.contentMode = UIViewContentModeScaleAspectFill;//用一张广告图,适配所有机型
    //广告图片URLString/或本地图片名(.jpg/.gif请带上后缀)
    imageAdconfiguration.imageNameOrURLString = @"启动图.png";
    //广告点击打开页面参数(openModel可为NSString,模型,字典等任意类型)
    imageAdconfiguration.openModel = @"http://www.it7090.com";
    //显示图片开屏广告
    [XHLaunchAd imageAdWithImageAdConfiguration:imageAdconfiguration delegate:self];
    
}

- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(nonnull id)openModel clickPoint:(CGPoint)clickPoint {
    
    NSString *urlStr = (NSString *)openModel;
    if (urlStr.length > 0) {
       
    }
}




@end
