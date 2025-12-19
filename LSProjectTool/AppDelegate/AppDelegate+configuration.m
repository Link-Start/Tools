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
#import <IQKeyboardManager/IQKeyboardManager.h>

// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
// 网络权限状态
#import <CoreTelephony/CTCellularData.h>
// 推送，通知
#import <UserNotifications/UNUserNotificationCenter.h>
#import <UserNotifications/UNNotificationSettings.h>

#import "AFNetworking.h"


/*********************** 地图 ***********************/

// 百度地图
#define HasBaiDuMapLocationSDK (__has_include(<BMKLocationkit/BMKLocationComponent.h>) || \
__has_include("BMKLocationComponent.h")) // 百度地图定位 location
#define HasBaiDuMapViewSDK (__has_include(<BaiduMapAPI_Map/BMKMapComponent.h>) || \
__has_include("BMKMapComponent.h")) //百度地图 mapView

// 高德地图
#define HasGaoDeMapSDK (__has_include(<AMapLocationKit/AMapLocationKit.h>) || \
__has_include("AMapLocationKit/AMapLocationKit.h"))


// 百度地图
#if __has_include(<BMKLocationkit/BMKLocationComponent.h>) // 百度地图 定位功能 location
#import <BMKLocationkit/BMKLocationComponent.h>
#import <BMKLocationKit/BMKLocationManager.h>
#elif __has_include("BMKLocationComponent.h")
#import "BMKLocationManager.h"
#import "BMKLocationComponent.h"
#endif

#if __has_include(<BaiduMapAPI_Map/BMKMapComponent.h>) // 百度地图 mapView
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#elif __has_include("BMKMapComponent.h")
#import "BMKBaseComponent.h"
#import "BMKMapComponent.h"
#endif

// 高德地图
#if __has_include(<AMapLocationKit/AMapLocationKit.h>)
#import <AMapLocationKit/AMapLocationKit.h>
#import "AMapPrivacyUtility.h" //隐私合规
#elif __has_include("AMapLocationKit/AMapLocationKit.h")
#import "AMapLocationKit.h"
#import "AMapPrivacyUtility.h" //隐私合规
#endif

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


#define kBaiduMapAgreedPrivacyFlag @"kBaiduMapAgreedPrivacyFlag"

@interface AppDelegate ()<XHLaunchAdDelegate
#if HasBaiDuMapLocationSDK  // 百度地图 定位sdk
, BMKLocationAuthDelegate
#elif HasBaiDuMapViewSDK    // 百度地图 mapView
, BMKGeneralDelegate
#endif
>

#if HasBaiDuMapViewSDK
/// 百度地图
@property (nonatomic,strong) BMKMapManager *mapManager;

#endif

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
    
    if ([NSProcessInfo.processInfo.environment[@"ActivePrewarm"] isEqualToString:@"1"]) {
        NSLog(@"本次启动为预热启动");
    } else {
        NSLog(@"本次启动为非预热启动");
    }
    
    
    //监听当前网络权限状态
    [self monitorCurrentNetworkPermissionStatus];
    // 查询当前网络权限状态
    [self checkCurrentNetworkPermissionStatus];
//    if (![kUserDefaults boolForKey:kFirstAuthorizeOpenNetworkPermission]) {
        //获取网络权限状态，根据权限执行相互的交互
        [self monitorNetworkStatus];//监听网络状态
//    }
}

/// 各个版本的一些适配
- (void)adaptationOfEachVersion {
    
    //在启动之后显示状态栏   9.0之前
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(setStatusBarHidden:animated:)]) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO animated:NO];
    }
    //
    if (@available(iOS 11.0, *)){
        //防止系统自动调整 UIScrollView 的内容边距（contentInset），避免因安全区域（如状态栏、导航栏、底部虚拟Home键）导致的布局错位或内容被遮挡。
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
        
        UITableView.appearance.tableHeaderView.frame = CGRectMake(0, 0, kLS_ScreenWidth, CGFLOAT_MIN);
        UITableView.appearance.tableFooterView.frame = CGRectMake(0, 0, kLS_ScreenWidth, CGFLOAT_MIN);
        UITableView.appearance.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        UITableView.appearance.backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        UICollectionView.appearance.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        UICollectionView.appearance.backgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
    
    if (@available(iOS 15.0, *)) {
        UITableView.appearance.sectionHeaderTopPadding = 0;
    }
    
    
    //关闭程序中的暗黑模式
#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
    if(@available(iOS 13.0,*)){
        self.window.overrideUserInterfaceStyle = UIUserInterfaceStyleLight;
        [UIScrollView appearance].automaticallyAdjustsScrollIndicatorInsets = NO;
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
    
    
//    
////    // 启用 IQKeyboardManager
//    IQKeyboardManager.shared.isEnabled = YES;
//    // 启用工具栏（显示 Done 按钮）
//    IQKeyboardManager.shared.enableAutoToolbar = YES;
//    // 其他配置可选
//    IQKeyboardManager.shared.resignOnTouchOutside = YES;
//    IQKeyboardManager.shared.toolbarConfiguration.tintColor = UIColor_00CBE0;
////    // 防止键盘弹起时scrollView位置偏移
////    IQKeyboardManager.shared.layoutIfNeededOnUpdate = YES;
//
////    // 修复键盘收起后位置偏移问题
//////    IQKeyboardManager.shared.shouldResignOnTouchOutside = YES;
////    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = @"完成"
////    IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = @"";
////    IQKeyboardManager.shared.toolbarDoneBarButtonItem?.setTitleColor(.white, for: .normal) // 设置Done按钮文字颜色
////    IQKeyboardManager.shared.toolbarDoneBarButtonItem?.backgroundColor = .blue // 设置Done按钮背景色
//    // 键盘收起后恢复原始滚动位置
//    [UIScrollView appearance].iq_ignoreContentInsetAdjustment = YES;// 保持原始内边距，不随键盘变化
////    [UIScrollView appearance].iq_ignoreScrollingAdjustment = YES;// 在控制器中禁用特定滚动视图的自动滚动
//    [UIScrollView appearance].iq_restoreContentOffset = YES; // 键盘收起后恢复原始滚动位置
//    
    // 设置键盘在 拖拽时 自动收起
    [UIScrollView appearance].keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
    
//    [[IQKeyboardManager sharedManager] setEnable:YES];
//    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
//    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
//    [IQKeyboardManager sharedManager].toolbarTintColor = UIColor_00CBE0;
//    [IQKeyboardManager sharedManager].layoutIfNeededOnUpdate = YES;
//
//    // 在控制器中禁用特定滚动视图的自动滚动
//    self.scrollView.shouldIgnoreScrollingAdjustment = true
//    [UIScrollView appearance].shouldIgnoreScrollingAdjustment = YES;
//    // 保持原始内边距，不随键盘变化
//    self.scrollView.shouldIgnoreContentInsetAdjustment = true
    [UIScrollView appearance].shouldIgnoreContentInsetAdjustment = YES;
    // 键盘收起后恢复原始滚动位置
//    self.scrollView.shouldRestoreScrollViewContentOffset = true
    [UIScrollView appearance].shouldRestoreScrollViewContentOffset = YES;
    
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

//https://blog.csdn.net/sodaslay/article/details/73559072
//在iOS 10下 ，首次进入应用时，会有询问是否允许网络连接权限的的弹窗，
//为更好进行用户交互，需要在打开应用时获取应用禁用网络权限状态（状态分为：未知、限制网络、未限制网络），客户端根据不同的权限状态定制相应的人机交互。
//针对请求应用网络权限可能存在的几种情形，操作与对应的状态都是笔者测试得到的，具体如下所示：
//可能操作  关闭          无线局域网       无线局域网&蜂窝    不进行操作   锁屏       解锁          按Home键
//权限状态  Restricted  NotRestricted   NotRestricted   Unknown   Unknown   恢复原始状态     保持原有状态
//使用CoreTelephony.framework框架下的CTCellularData类中的方法和属性进行解决
//当联网权限的状态发生改变时，会在上述方法中捕捉到改变后的状态，可根据更新后的状态执行相应的操作。


//https://www.freesion.com/article/5514747996/
//iOS网络情况分类：
//通过App应用设置网络使用权限（关闭、WLAN、WLAN与蜂窝移动网）
//直接设置手机网络情况（飞行模式、无线局域网络、蜂窝移动网络）
//根据CTCellularData类获取网络权限状态以及监听状态改变回调（推荐)
//添加CoreTelephony系统库，在AppDelegate.m里#import<CoreTelephony/CTCellularData.h>
//CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
// 获取网络权限状态，根据权限执行相互的交互
/// 监听当前网络权限状态
- (void)monitorCurrentNetworkPermissionStatus {
    // 根据权限执行相应的交互
    
    CTCellularData *cellularData = [[CTCellularData alloc] init];
    // 此函数会在网络权限改变时再次调用
    cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        //状态改变时进行相关操作
        switch (state) {
            case kCTCellularDataRestrictedStateUnknown: {
                //未知，第一次请求
                NSLog(@"网络权限未知 Unknown，未知");
                //还没有遇到推测是有网络但是连接不正常的情况下
            }
                break;
            case kCTCellularDataRestricted: {
                NSLog(@"网络权限被关闭 Restricrted，限制网络");
                //权限关闭的情况下 再次请求网络数据 弹出设置网络提示

            }
                break;
            case kCTCellularDataNotRestricted: {
                NSLog(@"网络权限开启 NotRestricted，未限制网络");
                //已经开启网络权限 监听网络状态
            }
                break;
            default:
                break;
        }
    };
}

/// 当查询应用联网权限时可以使用下面的方法：
/// 查询当前网络权限状态
- (void)checkCurrentNetworkPermissionStatus {
    
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    switch (state) {
        case kCTCellularDataRestrictedStateUnknown:
            NSLog(@"Unknown，未知");
            //还没有遇到推测是有网络但是连接不正常的情况下
            break;
        case kCTCellularDataRestricted:
            NSLog(@"Restricrted，限制网络");
            //权限关闭的情况下 再次请求网络数据 弹出设置网络提示
            break;
        case kCTCellularDataNotRestricted:
            NSLog(@"Not Restricted，未限制网络");
            //已经开启网络权限 监听网络状态
            break;
        default:
            break;
    }
}

#pragma mark - 网络状态
/// 实时检查当前的网络状态
- (void)addReachabilityManager {
    AFNetworkReachabilityManager *afNetworkReachabilityManager = [AFNetworkReachabilityManager sharedManager];
    
    //这个可以放在需要侦听的页面
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(afNetworkStatusChanged:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    [afNetworkReachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"网络不通：%@",@(status) );
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"网络通过WIFI连接：%@",@(status));
                
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"网络通过无线连接：%@",@(status) );
                
                break;
            }
            case AFNetworkReachabilityStatusUnknown: {
                NSLog(@"网络未知：%@",@(status) );
                break;
            }
                
            default:
                break;
        }
    }];
    
    [afNetworkReachabilityManager startMonitoring];  //开启网络监视器；
    
}

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
/// CTCellularData在iOS9之前是私有类，权限设置是iOS10开始的，所以App Store审核没有问题
/// 获取网络权限状态，根据权限执行相互的交互
/// 监听网络状态
- (void)monitorNetworkStatus {
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
                
//                if (![kUserDefaults boolForKey:kFirstAuthorizeOpenNetworkPermission]) {
//                    dispatch_async(dispatch_get_main_queue(), ^{
//                        [kUserDefaults setBool:YES forKey:kFirstAuthorizeOpenNetworkPermission];
//                        [[NSNotificationCenter defaultCenter] postNotificationName:Notification_firstAuthorizeOpenNetworkPermission object:nil];
//                    });
//                }
            }
                break;
            default:
                NSLog(@"网络权限");
                break;
        }
    };
}




#pragma mark - 通知推送功能是否打开
//iOS10以上的通知相关API发生了较大变化，我们需要针对不同的系统版本使用不同的API来判断
- (BOOL)isOpenNotificationSetting {
    __block BOOL isOpen = NO;
    
    if (@available(iOS 10.0, *)) { // iOS10及10以上系统
        dispatch_semaphore_t semaphore;
        semaphore = dispatch_semaphore_create(0);
        // 异步方法，使用信号量的方式加锁保护能够同步拿到返回值
        [[UNUserNotificationCenter currentNotificationCenter] getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            // NotDetermined    用户尚未允许或拒绝应用发布通知的权限。
            // Denied           用户已拒绝应用发布通知的权限。
            // Authorized       用户已允许应用发布通知。
            // Provisional      用户已允许临时非关键通知。
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

/**
 
 信号量dispatch_semaphore，功能类似于iOS开发中的锁（比如NSLock，@synchronize等），它是一种基于计数器的多线程同步机制。
 1.使用dispatch_semaphore_create创建信号量semaphore，此时信号量的值是0。
 2.异步跳过block块代码，执行dispatch_semaphore_wait，信号量的值减1。此时当前线程处于阻塞状态，等待信号量加1才能继续执行。
 3.block块代码异步执行，dispatch_semaphore_signal执行后发送一个信号，信号量的值加1，线程被唤醒，继续执行，给isOpen赋值，然后return，保证了每次能够正确取到当前的push开关状态。
 */

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

//别的app利用URL Scheme打开自己的app的动作该怎么扑捉呢？在app被URL Scheme打开的时候会触发如下代理方法，使用的版本要求也都在下面了。(建议把对URL Scheme的处理封装出来，减少AppDelegate的代码量)
// 需要把你想要打开的app的schemes添加到白名单,否则跳不过去
// 这3个回调是有优先级的。3>2>1。
// 也就是说，如果你3个回调都实现了，那么程序只会执行 3 回调。其他回调是不会执行的。（当然，iOS9以下只会执行2回调）
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    //    NS_DEPRECATED_IOS(2_0, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;
    // 1、iOS2.0的时候推出的，参数只有url
    NSLog(@"%@", url);
    return YES;
}
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation {
    //    NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;
    // 2、 iOS4.2的时候推出的，参数有url sourceApplication annotation.
    NSLog(@"%@", sourceApplication);
    return YES;
}
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options {
    // NS_AVAILABLE_IOS(9_0) ;
    // no equiv. notification. return NO if the application can't open for some reason
    // 3、iOS9.0的时候推出的，参数有url options。options有下面几个key
    NSLog(@"%@", options);
    return YES;
}





#pragma mark - 剪切板、粘贴板
//https://blog.csdn.net/weixin_39517520/article/details/111509934


//    //获取或设置剪切板中的字符串数据：string;
//    //获取或设置剪切板中的字符串数组：strings;
//    //获取或设置剪切板中的URL数据：URL;
//    //获取或设置剪切板中的URL数组：URLs;
//    //获取或设置剪切板中的图片数据：image;
//    //获取或设置剪切板中的图片数组：images;
//    //获取或设置剪切板中的颜色数据：color;
//    //获取或设置剪切板中的颜色数组：colors;
//
//    //所有字符串类型数据的类型定义字符串数组：UIPasteboardTypeListString;
//    //所有URL类型数据的类型定义字符串数组：UIPasteboardTypeListURL;
//    //所有图片数据的类型定义字符串数据：UIPasteboardTypeListImage;
//    //所有颜色数据的类型定义字符串数组：UIPasteboardTypeListColor;

// https://www.6hu.cc/archives/120215.html
// 在iOS14中，假设APP读取剪切版的内容时，手时机弹出提示，提示哪个APP在获取剪切板内容。
// 读取UIPasteboard的string、strings、URL、URLs、image、images、color、colors的时分会触发体系提示。
// 运用hasStrings、hasURLs、hasImages、hasColors等方法的时分不会触发体系提示。
// 先判别剪切板内容的各式，假设符合规则才读取剪切板
// 弹出提示的兼容计划：尽可能少的去调用会触发体系提示的方法
// 弹出提示的原因:运用 UIPasteboard 访问用户数据
// 计划一：先判别剪切板内容的格式，假设符合规则采纳读取。
// 计划二：运用changeCount来记载剪切板的数据是否发生变化
// 1.1 先判别剪切板内容的各式，假设符合规则才读取剪切板(例如淘宝的淘口令)
//      假设运用只是访问只访问URL格式的剪切板内容，或许特定规则的内容，比如淘口令，就能够运用API先判别，确实是符合规则的时分再去读取
//      判别是否为URL格式: UIPasteboardDetectionPatternAPI（iOS14）
//      UIPasteboardDetectionPatternconst、UIPasteboardDetectionPatternProbableWebURL（iOS14）
//      UIPasteboardDetectionPatternconst、UIPasteboardDetectionPatternProbableWebSearch（iOS14）
//      UIPasteboardDetectionPatternconst、UIPasteboardDetectionPatternNumber（iOS14）
//
// 1.2 运用changeCount来记载剪切板的数据是否发生变化
//      记载一下真实读取剪切板时的changeCount，假设下次读取的时分没有发生变化则不读取。 这样一来效果就好多了，运用运转生命周期内，基本上只会弹出一次提示
/// 读取并识别 粘贴板 内容
- (void)readAndRecognizePastedboardContent {
    UIPasteboard *pastedboard = [UIPasteboard generalPasteboard];
    
    //changeCount：此剪切板的改变次数 系统级别的剪切板只有当设备重新启动时 这个值才会清零
    NSLog(@"粘贴板 pastedboard.changeCount：%ld", pastedboard.changeCount);
    
    NSLog(@"粘贴板 最新数据的类型：%@", pastedboard.pasteboardTypes);
    
    if ([pastedboard hasStrings]) {//有字符串
        NSLog(@"粘贴板有 Strings");
        NSLog(@"粘贴板有 pastedboard.string：%@", pastedboard.string);
        NSLog(@"粘贴板有 pastedboard.strings：%@", pastedboard.strings);
    }
    if ([pastedboard hasURLs]) {
        NSLog(@"粘贴板有 URLs");
        NSLog(@"粘贴板有 pastedboard.URL：%@", pastedboard.URL);
        NSLog(@"粘贴板有 pastedboard.URLs：%@", pastedboard.URLs);
    }
    if ([pastedboard hasColors]) {
        NSLog(@"粘贴板有 Colors");
        NSLog(@"粘贴板有 pastedboard.color：%@", pastedboard.color);
        NSLog(@"粘贴板有 pastedboard.colors：%@", pastedboard.colors);
    }
    if ([pastedboard hasImages]) {
        NSLog(@"粘贴板有 Images");
        NSLog(@"粘贴板有 pastedboard.image：%@", pastedboard.image);
        NSLog(@"粘贴板有 pastedboard.images：%@", pastedboard.images);
    }
    
    if (pastedboard.string.length <= 0) {
        return;
    }
    
    
    
    
    
    // 给粘贴板赋值，防止重复读取相同的字符串
    [UIPasteboard generalPasteboard].string = @"";
}

#pragma mark - 地图
#pragma mark - 百度地图
#if HasBaiDuMapLocationSDK           // 有百度地图 api
/// 配置百度地图定位
- (void)configBaiDuMap {
    
    [[BMKLocationAuth sharedInstance] checkPermisionWithKey:BaiduMaps_appKey authDelegate:self];
    
#if HasBaiDuMapViewSDK
    // 要使用百度地图，请先启动BaiduMapManager
    self.mapManager = [[BMKMapManager alloc] init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    
    BOOL ret = [self.mapManager start:BM_APPKey generalDelegate:self];
    if (!ret) {
        NSLog(@"参数错误或引擎内部异常则返回NO!");
    }
    
    //     // ‼️重要：设置用户是否同意SDK隐私协议
    //     if (![[NSUserDefaults standardUserDefaults] boolForKey:kBaiduMapAgreedPrivacyFlag]) {
    //         [self showAgreePrivacyAlert];
    //     } else {
    // 定位SDK隐私权限授权
    [[BMKLocationAuth sharedInstance] setAgreePrivacy:YES];
    // 地图SDK隐私权限授权
    [BMKMapManager setAgreePrivacy:YES];
    //     }
    
#endif
}

#if HasBaiDuMapViewSDK
- (void)showAgreePrivacyAlert {
    // ‼️重要：设置用户是否同意SDK隐私协议，必须SDK初始化前按用户意愿设置
    // 隐私政策官网链接：https://lbsyun.baidu.com/index.php?title=openprivacy
    NSString *message = @"\n欢迎您使用百度地图开放平台产品和服务,为响应工信部针对进一步加强用户隐私安全保障措施的号召，以便更好地为广大用户提供更合规、更安全、更稳定的服务体验，平台全面更新了《百度地图开放平台产品和服务隐私政策》,请认真阅读并同意隐私服务政策";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *conform = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kBaiduMapAgreedPrivacyFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 定位SDK隐私权限授权
        [[BMKLocationAuth sharedInstance] setAgreePrivacy:YES];
        // 地图SDK隐私权限授权
        [BMKMapManager setAgreePrivacy:YES];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kBaiduMapAgreedPrivacyFlag];
        [[NSUserDefaults standardUserDefaults] synchronize];
        // 定位SDK隐私权限授权
        [[BMKLocationAuth sharedInstance] setAgreePrivacy:NO];
        // 地图SDK隐私权限授权
        [BMKMapManager setAgreePrivacy:NO];
    }];
    
    [alert addAction:conform];
    [alert addAction:cancel];
    [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
}
#endif
/**
 联网结果回调
 
 @param iError 联网结果错误码信息，0代表联网成功
 */
- (void)onGetNetworkState:(int)iError {
    if (0 == iError) {
        NSLog(@"联网成功");
    } else {
        NSLog(@"联网失败：%d", iError);
    }
}

/**
 鉴权结果回调
 
 @param iError 鉴权结果错误码信息，0代表鉴权成功
 */
- (void)onGetPermissionState:(int)iError {
    if (0 == iError) {
        NSLog(@"百度地图授权成功");
        /// 第一次授权定位权限
        if (![UserDefaults boolForKey:kBaiDuMapFirstAuthent]) {
            [[NSNotificationCenter defaultCenter] postNotificationName:OPBaiDuMapLocationFirstAuthSuccessNotification object:nil];
        }
    } else {
        NSLog(@"百度地图授权失败：%d", iError);
    }
}

#endif

#pragma mark - 高德地图
#if HasGaoDeMapSDK
/// 配置高德地图定位
- (void)configGaoDeMap {
    // 开启 HTTPS 功能，您只需在配置高德 Key 前，添加开启 HTTPS 功能的代码，如下：
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    // 设置高德地图 apiKey
    [AMapServices sharedServices].apiKey = GaoDeMaps_appKey;
    // 调用隐私合规处理方法
    [AMapPrivacyUtility handlePrivacyAgreeStatus];
}
#endif

@end


#pragma mark - 百度和高德地图根据经纬度调用静态图片缩略图的接口
//百度和高德地图根据经纬度调用静态图片缩略图的接口
//https://lbsyun.baidu.com/index.php?title=static
//https://api.map.baidu.com/staticimage/v2?ak=E4805d16520de693a3fe707cdc962045&mcode=666666&center=116.403874,39.914888&width=300&height=200&zoom=11
//
////http://www.5imoban.net/jiaocheng/hbuilder/2019/1227/3675.html
////聊天发送位置可以用融云提供的sendLocationMessage方法。经纬度也好获取，但是，apicloud官方提供的截图工具，不能截取地图、视频。还好，百度和高德地图都提供了根据经纬度调用静态缩略图的接口，
///百度地址如下：
////http://api.map.baidu.com/staticimage?center=获取的经度,获取的纬度&width=300&height=180&zoom=15&copyright=1
///https://api.map.baidu.com/staticimage/v2?ak=FU6PO4GTN9lpAZpckaMG4jRxNgCN5opf&mcode=666666&center=120.5750660400261,31.296921317623855&width=300&height=180&zoom=15&copyright=1
/// 至于其他参数，
/// 百度可参考：http://lbsyun.baidu.com/index.php?title=static
//
//参数名         必选  默认值           描述
//ak             是    无      用户的访问密钥。支持浏览器端和服务端ak，网页应用推荐使用 服务端ak(sn校验方式）
//mcode          否    无      安全码。若为Android/IOS SDK的ak, 该参数必需。
//width          否    400     图片宽度。取值范围：(0, 1024]。Scale=2,取值范围：(0, 512]。
//height         否    300     图片高度。取值范围：(0, 1024]。Scale=2,取值范围：(0, 512]。
//center         否    北京     地图中心点位置，参数可以为经纬度坐标或名称。坐标格式：lng<经度>，lat<纬度>，例如116.43213,38.76623。
//zoom           否    11      地图级别。高清图范围[3, 18]；低清图范围[3,19]
//copyright      否    pl      静态图版权样式，0表示log+文字描述样式，1表示纯文字描述样式，默认为0。
//dpiType        否    pl      手机屏幕类型。取值范围:{ph：高分屏，pl：低分屏(默认)}，高分屏即调用高清地图，低分屏为普通地图。
//coordtype      否    bd09ll  静态图的坐标类型。\
                               支持wgs84ll（wgs84坐标）/gcj02ll（国测局坐标）/bd09ll（百度经纬度）/bd09mc（百度墨卡托）。默认bd09ll（百度经纬度）
//scale          否    null    返回图片大小会根据此标志调整。取值范围为1或2：\
                               1表示返回的图片大小为size= width * height;\
                               2表示返回图片为(width*2)*(height *2)，且zoom加1\
                               注：如果zoom为最大级别，则返回图片为（width*2）*（height*2），zoom不变。
//bbox           否    null    地图视野范围。格式：minX,minY;maxX,maxY。
//markers        否    null    标注，可通过经纬度或地址/地名描述；多个标注之间用竖线分隔。
//markerStyles   否    null    与markers有对应关系。markerStyles可设置默认图标样式和自定义图标样式。\
                               其中设置默认图标样式时，可指定的属性包括size,label和color；\
                               设置自定义图标时，可指定的属性包括url，注意，设置自定义图标时需要先传-1以此区分默认图标。\
//labels         否    null    标签，可通过经纬度或地址/地名描述；多个标签之间用竖线分隔。坐标格式：lng<经度>，lat<纬度>，例如116.43213,38.76623。
//labelStyles    否    null    标签样式 content, fontWeight,fontSize,fontColor,bgColor, border。与labels一一对应。
//paths          否    null    折线，可通过经纬度或地址/地名描述；多个折线用竖线"|"分隔；每条折线的点用分号";"分隔；\
                               点坐标用逗号","分隔。坐标格式：lng<经度>，lat<纬度>，例如116.43213,38.76623。
//pathStyles     否    null    折线样式 color,weight,opacity[,fillColor]。






////高德地图带ICON的静态图示例：
////https://restapi.amap.com/v3/staticmap?markers=-1,http://www.5imoban.net/view/demoimg/jrzb_position_icon.png,0:116.37359,39.92437&key=ee95e52bf08006f63fd29bcfbcf21df0
///http://restapi.amap.com/v3/staticmap?location=获取的经度,获取的纬度&zoom=17&scale=2&size=150*150&key=ee95e52bf08006f63fd29bcfbcf21df0
///https://restapi.amap.com/v3/staticmap?location=116.481485,39.990464&zoom=10&size=750*300&markers=mid,,A:116.481485,39.990464&key=<用户的key>
///
/// 在使用时，只要将图片的src地址改成上面的地址，并且将上面的经纬度替换成您获取的经纬度即可，非常方便。
///
/// 至于其他参数，
/// 百度可参考：http://lbsyun.baidu.com/index.php?title=static
/// 高德可参考：https://lbs.amap.com/api/webservice/guide/api/staticmaps/

// 服务地址
// URL：https://restapi.amap.com/v3/staticmap?parameters
// 请求方式：GET
// parameters代表请求参数，所有参数均使用和号字符(&)进行分隔。下面的列表枚举了这些参数及使用规则。

// 请求参数

//参数名称          含义              规则说明                                                  是否必填             默认值

//key           用户唯一标识       用户在高德地图官网申请                                            必填               无
//location      地图中心点         中心点坐标。规则：经度和纬度用","分隔\                            部分条件必填           无
//                               经纬度小数点后不得超过6位。
//zoom          地图级别           地图缩放级别:[1,17]                                             必填               无
//size          地图大小           图片宽度*图片高度。最大值为1024*1024                               可选             400*400
//scale         普通/高清          1:返回普通图；2:调用高清图，图片高度和宽度都增加一倍，\                可选                1
//                                zoom也增加一倍（当zoom为最大值时，zoom不再改变）。
//markers       标注              使用规则见markers详细说明，标注最大数10个                           可选                无
//labels        标签              使用规则见labels详细说明，标签最大数10个                            可选                无
//paths         折线              使用规则见paths详细说明，折线和多边形最大数4个                        可选                无
//traffic       交通路况标识        底图是否展现实时路况。 可选值： 0，不展现；1，展现。                   可选                0
//sig           数字签名            数字签名认证用户必填                                             可选                无

// 注：如果有标注/标签/折线等覆盖物，则中心点（location）和地图级别（zoom）可选填。
//    当请求中无location值时，地图区域以包含请求中所有的标注/标签/折线的几何中心为中心点；
//    如请求中无zoom，地图区域以包含请求中所有的标注/标签/折线为准，系统计算出zoom值。

//
// markers
// 格式：
// markers=markersStyle1:location1;location2..|markersStyle2:location3;location4..|markersStyleN:locationN;locationM..
// location为经纬度信息，经纬度之间使用","分隔，不同的点使用";"分隔。 markersStyle可以使用系统提供的样式，也可以使用自定义图片。
// 系统marersStyle：label，font ,bold, fontSize，fontColor，background。

// 参数名称                说明                                                            默认值
// size          可选值： small,mid,large                                                 small
// color         选值范围：[0x000000, 0xffffff]\                                          0xFC6054
//               例如：\
                 0x000000 black,\
                 0x008000 green,\
                 0x800080 purple,\
                 0xFFFF00 yellow,\
                 0x0000FF blue,\
                 0x808080 gray,\
                 0xffa500 orange,\
                 0xFF0000 red,\
                 0xFFFFFF white
// label        [0-9]、[A-Z]、[单个中文字] 当size为small时，图片不展现标注名。                    无


// markers示例：  https://restapi.amap.com/v3/staticmap?markers=mid,0xFF0000,A:116.37359,39.92437;116.47359,39.92437&key=您的key  自定义markersStyle： -1，url，0。
// -1表示为自定义图片，URL为图片的网址。自定义图片只支持PNG格式。
// markers示例：   https://restapi.amap.com/v3/staticmap?markers=-1,https://a.amap.com/jsapi_demos/static/demo-center/icons/poi-marker-default.png,0:116.37359,39.92437&key=您的key





