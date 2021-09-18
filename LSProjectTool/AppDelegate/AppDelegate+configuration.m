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
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

#import <IQKeyboardManager/IQKeyboardManager.h>


@interface AppDelegate ()<XHLaunchAdDelegate>

@end

@implementation AppDelegate (configuration)

#pragma mark ————— 初始化window —————
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];

    if (@available(iOS 11.0, *)){
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
}


///初始化 配置
- (void)initBasicConfiguration {
    
    /****************** 基本设置 ******************/
    //状态栏的字体   黑色：UIStatusBarStyleDefault  白色：UIStatusBarStyleLightContent
    //状态栏的字体
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //在启动之后显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    //设置UIView、UIImageView、UILabel。button等 接收手势的互斥性为YES，防止多个响应区域被“同时”点击，“同时”响应
    [[UIButton appearance] setExclusiveTouch:YES];
    
    //关闭程序中的暗黑模式
#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if(@available(iOS 13.0,*)){
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
    
    
    /****************** IQKeyboardManager设置 ******************/
    // 1.
    [self configIQKeyboardManager];
    
    
    
    
    /****************** 添加图片开屏广告 ******************/
    [self getLaunchImage];
    
    [self obtainIDFA];//获取IDFA权限
}

#pragma mark - IQKeyboardManager设置
- (void)configIQKeyboardManager {
    // 1.修改 IQKeyBoardManager 的右边的 Done 按钮
//    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemText = @"完成";
//    // 或者
//    [IQKeyboardManager sharedManager].toolbarDoneBarButtonItemImage = [UIImage imageNamed:@"IQKeyboardManagerScreenshot"];

    // 2.修改 IQKeyBoardManager 的 Toolbar颜色等
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = NO;
    [IQKeyboardManager sharedManager].toolbarTintColor = [UIColor redColor];
//
//    // 3.是否显示响应者的水印和字号
//    [IQKeyboardManager sharedManager].shouldShowToolbarPlaceholder = YES;
//    [IQKeyboardManager sharedManager].placeholderFont = [UIFont systemFontOfSize:14.0];
//    // 4. 设置键盘textField的距离。不能小于零。默认是10.0。<触发条件是textField需要改变y时 >
//    [IQKeyboardManager sharedManager].keyboardDistanceFromTextField = 10.0f;
    
    // 5.全局禁用 键盘toolBar左侧的 跳转其他输入框的箭头(上一个/下一个输入框)
//    [IQKeyboardManager sharedManager].previousNextDisplayMode = IQPreviousNextDisplayModeAlwaysHide;

    // 6.为textField/textView设置与键盘的自定义距离。不能小于零
//    self.verifyCodeTF.keyboardDistanceFromTextField = 50;


//    // 6.  IQKeyBoardManager 的右边的 Done 按钮的响应事件doneAction 事件未公开API,不过可以通过代理
//    - (void)textFieldDidEndEditing:(UITextField *)textField
}

#pragma mark - 开屏广告
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

#pragma mark - 获取IDFA 权限
//IDFA & IDFV
//IDFA - Identifier For Advertising（广告标识符）
//      同一手机获取该值都相同
//      重装应用, 不会改变
//      用户可手动重置这个值. 重置广告 id: 设置 -> 隐私 -> 广告 -> 重置广告 id (中国区的可能看不到这个, 模拟器可以看到)
//IDFV - Identifier For Vendor（应用开发商标识符）
///// https://blog.csdn.net/yangxuan0261/article/details/113801704

//获取IDFA 权限
- (void)obtainIDFA {
     // iOS14方式访问 IDFA
     if (@available(iOS 14, *)) {
          
          //进行权限判断，根据不同权限进行判断
          ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
          switch (status) {
               case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"用户拒绝");
//                    [self applyIDFAAuthority];//申请权限
//                  finishBlock();
                    break;
               case ATTrackingManagerAuthorizationStatusAuthorized:
                    NSLog(@"用户允许");
//                  finishBlock();
                    break;
               case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"用户为做选择或未弹窗");
                    [self applyIDFAAuthority];//申请权限
                    break;
               default:
//                    [self applyIDFAAuthority];//申请IDFA权限
                    break;
          }
          
     } else {
          // 使用原方式访问 IDFA
          if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
               NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
               NSLog(@"idfaStr - %@", idfaStr);
          } else {
               NSLog(@"iOS13  用户开启了限制广告追踪");
          }
     }
}

- (void)applyIDFAAuthority { //申请IDFA权限
     if (@available(iOS 14, *)) {
          //申请权限
         //请求弹出用户授权框，只会在程序运行是弹框1次，除非卸载app重装，通地图、相机等权限弹框一样
          [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
               if (status == ATTrackingManagerAuthorizationStatusAuthorized) { //用户同意授权
                    NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                    NSLog(@"iOS14 idfaStr - %@", idfaStr);
               } else {
                    NSLog(@"iOS14 用户开启了限制广告追踪");
               }
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  finishBlock();
//              });
          }];
     }
}

#pragma mark - 指定页面禁止使用第三方键盘
//指定页面禁止使用第三方键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier{
    NSArray *vcClass = @[
                         ];
    for (Class a in vcClass) {
        if ([self.window.rootViewController isKindOfClass:a]) {
            return NO;
        }
    }
    return YES;
}

#pragma mark - 微信初始化相关     微信需要注册
- (void)initWeiXin {
//    //在register之前打开log, 后续可以根据log排查问题
////    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
////        NSLog(@"WeChatSDK: %@", log);
////    }];
//
//    if([WXApi registerApp:WX_APP_ID universalLink:WX_Universal_Links]){
//        NSLog(@"初始化成功");
////        //自检函数
////        [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
////            NSLog(@"微信自检：%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
////        }];
//    }
}
#pragma mark - 支付宝初始化相关      支付宝不需要注册

@end
