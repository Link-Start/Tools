//
//  AppDelegate.m
//  LSProjectTool
//
//  Created by Xcode on 16/7/14.
//  Copyright © 2016年 Link-Start. All rights reserved.
//   支付宝 ：，移动支付接口文档您可以参考：https://doc.open.alipay.com/doc2/detail?treeId=59&articleId=103563&docType=1
// JZNavigationExtension 导航条

#import "AppDelegate.h"
#import "AppDelegate+configuration.h"
#import "AppDelegate+UMConfiguration.h"
#import "RealReachability.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
//#import <UserNotifications/UNUserNotificationCenter.h>

#import "ViewController.h"
#import "LSNavigationController.h"
#import "LSConstAppKey.h"
#import "LSTabBarController.h"

//#include <cstddef>     使用这个的m文件后缀改为.mm


@interface AppDelegate ()

@end

@implementation AppDelegate
//一款优雅好用的类似QQ和微信消息页面的右上角微型菜单弹窗, 最低支持iOS6
//pod 'Popover.OC'


// app 已经启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
//    ViewController *vc = [[ViewController alloc] init];
//    LSNavigationController *nav = [[LSNavigationController alloc] initWithRootViewController:vc];
    LSTabBarController *tabBarController = [[LSTabBarController alloc] init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    /****************** 网络检测 ******************/
    [GLobalRealReachability startNotifier];
    
    /****************** 基本设置 ******************/
    [self initBasicConfiguration];//配置
    
    //    //点击背景收回键盘
    //    [IQKeyboardManager sharedManager].shouldResignOnTouchOutside = YES;
    
    
    /****************** 高德地图 ******************/
    [AMapServices sharedServices].apiKey = GaoDeMaps_appKey;
    
    /****************** 初始化友盟 ******************/
    [self initUMengConfigurationWithOptions:launchOptions];
    
    return YES;
}

/// app 挂起状态
/// 当应用程序将要入非活动状态执行，在此期间，应用程序不接收消息或事件，比如来电话了
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

/// app 进入活跃状态
/// 当应用程序入活动状态执行，App处于活跃状态
/// 当 App 刚刚启动 和 app 从后台回到前台的时候，此方法都会走.
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // 当 App 刚刚启动 和 app 从后台回到前台的时候，此方法都会走.
    /******************  ******************/
    
    // iOS14，剪切板

    // 读取剪切板数据
    UIPasteboard *passboard = [UIPasteboard generalPasteboard];
    NSLog(@"剪切板数据：%@", passboard.string); //
    
    
    // 在h5页面，读取并识别粘贴板屏幕变白一下，目前猜测是因为内存消耗过大导致的
    [self readAndRecognizePastedboardContent];//读取并识别 粘贴板 内容
}

/// app 进入后台
/// 当程序被推送到后台的时候调用。所以要设置后台继续运行，则在这个函数里面设置即可
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    if (@available(iOS 17.0, *)) {
        //iOS17.0，applicationIconBadgeNumber属性被废弃，
        // 建议使用[UNUserNotificationCenter setBadgeCount:withCompletionHandler:]
//
    } else {
        
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

/// app 将重新回到前台
/// 当程序从后台将要重新回到前台时候调用，app从后台进入前台
/// 当 App 刚刚启动，而不是从后台取出的时候，此方法不走
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //当 App 刚刚启动，而不是从后台取出的时候，此方法不走
    if (@available(iOS 17.0, *)) {
        //iOS17.0，applicationIconBadgeNumber属性被废弃，
        // 建议使用[UNUserNotificationCenter setBadgeCount:withCompletionHandler:]
//
    } else {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    
    if (@available(iOS 10.0, *)) {
//        [UNUserNotificationCenter removeAllPendingNotificationRequests]
    } else {
        [application cancelAllLocalNotifications];
    }
}
/**
 对比 applicationWillEnterForeground 和 applicationDidBecomeActive
 这两个方法，前者是指 App从后台进入前台，后者是指 App处于活跃状态，所以前者相对于后者，缺少的部分是，当 App 刚刚启动，而不是从后台取出的时候，它无法识别剪贴板。
 因为你不能要求每次都让用户先把 App 打开，再往剪贴板里面填东西，再跳转回来，所以个人建议把上面的代码放在 applicationDidBecomeActive 方法中，而不是 applicationWillEnterForeground 。
 */

///当程序将要退出时被调用，通常是用来保存数据和一些退出前的清理工作。这个需要要设置UIApplicationExitsOnSuspend的键值。
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    //用户关闭APP时调用
    //  - 监听到 app 被杀死时候的回调....
    
//    sleep(1);//延迟关闭
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    //iPhone设备只有有限的内存，如果为应用程序分配了太多内存操作系统会终止应用程序的运行，在终止前会执行这个方法，通常可以在这里进行内存清理工作防止程序被终止
}

///当系统时间发生改变时执行
- (void)applicationSignificantTimeChange:(UIApplication *)application {
    
}

///当程序载入后执行
- (void)applicationDidFinishLaunching:(UIApplication *)application {
    
}

///当StatusBar框将要变化时执行
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame {
    
}
///当StatusBar框方向将要变化时执行
- (void)application:(UIApplication *)application willChangeStatusBarOrientation:(UIInterfaceOrientation)newStatusBarOrientation duration:(NSTimeInterval)duration {
    
}
///当StatusBar框变化完成后执行
- (void)application:(UIApplication *)application didChangeStatusBarFrame:(CGRect)oldStatusBarFrame {
    
}
///当StatusBar框变化完成后执行
- (void)application:(UIApplication *)application didChangeStatusBarOrientation:(UIInterfaceOrientation)oldStatusBarOrientation {
    
}

///当通过url执行
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return YES;
}


-(UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {//如果设置了allowRotation属性，支持横屏
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}

#pragma mark - 横屏
#pragma mark - ------------------------------------------------------------------------------------------------
- (void)startFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
    if (@available(iOS 16.0, *)) {
        UIWindowScene *windowScene =
            (UIWindowScene *)[UIApplication sharedApplication].connectedScenes.allObjects.firstObject;
        for (UIWindow *windows in windowScene.windows) {
            if ([windows.rootViewController respondsToSelector:NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations")]) {
                [windows.rootViewController performSelector:NSSelectorFromString(@"setNeedsUpdateOfSupportedInterfaceOrientations")];
            }
        }
    } else {
        // Fallback on earlier versions
    }
}

- (void)endFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
 
    
    if (@available(iOS 16.0, *)) {
        @try {
            NSArray *array = [[[UIApplication sharedApplication] connectedScenes] allObjects];
            UIWindowScene *ws = (UIWindowScene *)array[0];
            Class GeometryPreferences = NSClassFromString(@"UIWindowSceneGeometryPreferencesIOS");
            id geometryPreferences = [[GeometryPreferences alloc]init];
            [geometryPreferences setValue:@(UIInterfaceOrientationMaskPortrait) forKey:@"interfaceOrientations"];
            SEL sel_method = NSSelectorFromString(@"requestGeometryUpdateWithPreferences:errorHandler:");
            void (^ErrorBlock)(NSError *err) = ^(NSError *err){};
            if ([ws respondsToSelector:sel_method]) {
                (((void (*)(id, SEL,id,id))[ws methodForSelector:sel_method])(ws, sel_method,geometryPreferences,ErrorBlock));
            }
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    }
    else {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            @try {
                SEL selector = NSSelectorFromString(@"setOrientation:");
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
                [invocation setSelector:selector];
                [invocation setTarget:[UIDevice currentDevice]];
                int val = UIInterfaceOrientationPortrait;
                [invocation setArgument:&val atIndex:2];
                [invocation invoke];
            } @catch (NSException *exception) {
                
            } @finally {
                
            }
        }
    }
}
#pragma mark ------------------------------------------------------------------------------------------------











@end
