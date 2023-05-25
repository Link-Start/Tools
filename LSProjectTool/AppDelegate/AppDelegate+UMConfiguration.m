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
