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
// 网络权限状态
#import <CoreTelephony/CTCellularData.h>

/**
 打包测试时：
        Debug: 选择导出 development 包
        Release:选择导出 ad-hoc 包
 
 打包时可以选择appstore、adhoc、development三种模式
 上面三种模式决定了安装包的推送环境
 一般导出类型为adhoc、appstore包对应着生产环境的推送；而development对应着开发环境的推送。

 development:       针对内部测试使用，主要给开发者的设备(具体也为在开发者账户下添加可用设备的udid)。该app包是开发证书编译的
 ad-hoc:                在账号添加的可使用设备上使用（具体为在开发者账户下添加可用设备的udid,最多100个），该app包是发布证书编译的
            [Ad Hoc模式的包，和将来发布到App Store的包在各种功能测试上是一样的，
            只要Ad Hoc模式下测试（推送，内购等）没有问题，发布到App  Store也是没有问题的。]
 
 
 */


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
    
    //设置UIView、UIImageView、UILabel。button等 接收手势的互斥性为YES，防止多个响应区域被“同时”点击，“同时”响应
    [[UIButton appearance] setExclusiveTouch:YES];
    
    /******************  ******************/
    [self adaptationOfEachVersion];//各个版本的一些适配
    /******************  ******************/
    [self configIQKeyboardManager];//IQKeyboardManager设置
    /******************  ******************/
    [self getLaunchImage];//添加图片开屏广告
    /******************  ******************/
//    [self obtainIDFA];//获取IDFA权限
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(obtainIDFA) name:UIApplicationDidBecomeActiveNotification object:nil];

}

/// 各个版本的一些适配
- (void)adaptationOfEachVersion {
    
    //在启动之后显示状态栏   9.0之前
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:animated:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
    }
    //
    if (@available(iOS 11.0, *)){
        //UIScrollViewContentInsetAdjustmentNever:contentInset 不会被调整
        //UIScrollViewContentInsetAdjustmentAlways:contentInset 始终会被scrollView的safeAreaInsets来调整
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        
        //iOS8引入Self-Sizing 之后，我们可以通过实现estimatedRowHeight相关的属性来展示动态的内容
        //Self-Sizing在iOS11下是默认开启的
        //iOS11下不想使用Self-Sizing的话，可以通过以下方式关闭
        //关闭自调整尺寸
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
    }
    
    
    
    //关闭程序中的暗黑模式
#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if(@available(iOS 13.0,*)){
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
    }
#endif
    

    if (@available(iOS 15.0, *)) {
        //从iOS15开始,TableView增加sectionHeaderTopPadding属性,
        //默认情况sectionHeaderTopPadding会有22个像素的高度,及默认情况,TableView section header增加22像素的高度
        UITableView.appearance.sectionHeaderTopPadding = 0;
    } else {
        // Fallback on earlier versions
    }
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
    
    //3. 设置 IQKeyBoardManager 触摸UITextField/View外部时退出键盘，默认为否
    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [IQKeyboardManager sharedManager].resignFirstResponderGesture;
    //初始化时 resignFirstResponderGesture.enabled = shouldResignOnTouchOutside;
    //点击手势，在视图触摸时退出键盘。它是一个只读属性，仅当添加的手势与此手势发生冲突时，才用于添加/删除依赖项
    //如果这个手势被打开,IQ会在View上添加一个手势,会使View上某一个设置[textField resignFirstResponder]方法的textField被强制设置为第一响应者,
    //例:当[IQKeyboardManager sharedManager].shouldResignOnTouchOutside=YES时
    // tableView的cell上有一个textField,并且使用了.rac_textSignal监听,当设置[textField resignFirstResponder]后,会在点击某一处非编辑区域时触发IQKeyboard的tapRecognized:方法,使View上的某一个textField成为第一响应者
    
    
    
    // 4. 自动添加工具栏功能。默认值是YES
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
    
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

// 已过期 方法
//- (void)xhLaunchAd:(XHLaunchAd *)launchAd clickAndOpenModel:(nonnull id)openModel clickPoint:(CGPoint)clickPoint {
//    NSString *urlStr = (NSString *)openModel;
//    if (urlStr.length > 0) {
//
//    }
//}
// 新方法
- (BOOL)xhLaunchAd:(XHLaunchAd *)launchAd clickAtOpenModel:(id)openModel clickPoint:(CGPoint)clickPoint {
    NSString *urlStr = (NSString *)openModel;
    if (urlStr.length > 0) {
       
    }
    
    return YES;
}

#pragma mark - 获取IDFA 权限
/// 用户追踪授权弹窗
//IDFA & IDFV
//IDFA - Identifier For Advertising（广告标识符）
//      同一手机获取该值都相同
//      重装应用, 不会改变
//      用户可手动重置这个值. 重置广告 id: 设置 -> 隐私 -> 广告 -> 重置广告 id (中国区的可能看不到这个, 模拟器可以看到)
//IDFV - Identifier For Vendor（应用开发商标识符）
///// https://blog.csdn.net/yangxuan0261/article/details/113801704
/// 没弹框是因为系统设置里面的[设置-隐私-跟踪-允许App请求跟踪]的状态开关状态没开?(https://www.jianshu.com/p/7a244e92278f)
/// iOS 15.0 以上没弹窗  [着重推荐方法1通知监听，推荐2，不推荐3延迟调用]
/// 1.监听UIApplicationDidBecomeActiveNotification通知，在对应回调内调用获取授权方法     ------>强烈推荐
/// 2.写到 applicationDidBecomeActive 里面才会提示授权弹窗                                                  ------>推荐
/// 3.延迟几秒后调用                                                                                                                     ------>不推荐

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
                    NSLog(@"用户未做选择或未弹窗");
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
     } else {
         // 使用原方式访问 IDFA
         if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
             NSString *advertisingId = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
             NSLog(@"获取IDFA 广告标志符 - %@", advertisingId);
         } else {
             NSLog(@"用户开启了限制广告追踪");
        }
     }
}

// IDFV
//// https://blog.csdn.net/yangxuan0261/article/details/113801704
//// IDFV - Identifier For Vendor（应用开发商标识符）
//    NSString *idfv = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
//    NSLog(@"--- idfv: %@", idfv);


#pragma mark - 网络权限状态，联网权限
//iOS网络情况分类：
//通过App应用设置网络使用权限（关闭、WLAN、WLAN与蜂窝移动网）
//直接设置手机网络情况（飞行模式、无线局域网络、蜂窝移动网络）

//根据CTCellularData类获取网络权限状态以及监听状态改变回调（推荐)
//添加CoreTelephony系统库，在AppDelegate.m里#import<CoreTelephony/CTCellularData.h>
- (void)monitorNetworkPermissionStatus {
   
    if (__IPHONE_10_0) {
      // 监听网络权限状态
        
    } else {
        //
    }
}
//CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
// 获取网络权限状态，根据权限执行相互的交互
- (void)networkStatus:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    
    // 此函数会在网络权限更改时再次调用
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        
        switch (state) {
            case kCTCellularDataRestrictedStateUnknown: {
                //未知，第一次请求
                NSLog(@"网络权限未知 Unknown");
                
            }
                break;
                
            case kCTCellularDataRestricted: {
                NSLog(@"网络权限被关闭 Restricrted");
            }
                break;
                
            case kCTCellularDataNotRestricted: {
                NSLog(@"网络权限开启 NotRestricted");
            }
                break;
                
            default:
                break;
        }
    };
    
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



#pragma mark - URL Schemes
// URL Types ----> URL Schemes
//https://www.jianshu.com/p/ca7357ab4852
//https://www.jianshu.com/p/f367b4a5e871
//https://sspai.com/post/31500
//https://sspai.com/post/44591
// https://st3376519.huoban.com/share/1985010/VGi2N5Vf0C1MVnHCVWiBc8L9g15c9VGJbMGcFrb6/172707/list

// 需要把你想要打开的app的schemes添加到白名单,否则跳不过去

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
//    NS_DEPRECATED_IOS(2_0, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;
    
    NSLog(@"%@", url);
    
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
//    NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;
    
    NSLog(@"%@", sourceApplication);
    
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    // NS_AVAILABLE_IOS(9_0) ;
    // no equiv. notification. return NO if the application can't open for some reason
    
    NSLog(@"%@", options);
    
    return YES;
}

@end
