//
//  CheckoutNetworkState.m
//  Tedddd
//
//  Created by Xcode on 16/8/11.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "LSCheckoutNetworkState.h"

@implementation LSCheckoutNetworkState
#pragma mark - 监测当前网络状态（网络监听）
#pragma mark - 检查网络连接
/**
 *  检查当前网络连接 有网络:yes  无网络:no
 */
- (BOOL)currentNetworkStatus {
    
    //需要在didFinishLaunchingWithOptions中开启网络监听 [GLobalRealReachability startNotifier];
    
    //是否有网络
    __block BOOL canCheckNetwork  = NO;
    //触发实时网络状态查询代
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status) {
            case RealStatusUnknown: {
                NSLog(@"未知网络状态");
                canCheckNetwork  = NO;
                break;
            }
            case RealStatusNotReachable: {
                NSLog(@"网络连接已断开，请检查您的网络");
                canCheckNetwork  = NO;
                break;
            }
            case RealStatusViaWWAN: {
                NSLog(@"蜂窝数据网");
                    //查询当前实际网络连接类型
                    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
                    switch (accessType) {
                        case WWANTypeUnknown: {
                            NSLog(@"未知网络状态,可能是iOS6");
                            break;
                        }
                        case WWANType4G: {
                            NSLog(@"4G网络");
                            break;
                        }
                        case WWANType3G: {
                            NSLog(@"3G网络");
                            break;
                        }
                        case WWANType2G: {
                            NSLog(@"2G网络");
                            break;
                        }
                        default:
                            break;
                    }
                canCheckNetwork = YES;
                break;
            }
            case RealStatusViaWiFi: {
                NSLog(@"WiFi网络");
                canCheckNetwork = YES;
                break;
            }
            default:
                break;
        }
    }];
    return canCheckNetwork;
}

/**
 *  当前网络是否活跃
 *
 *  @return  YES:活跃  NO:不活跃
 */
+ (BOOL)activeNetwork {
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusViaWiFi || status == RealStatusViaWWAN ||  status == RealStatusUnknown) {
        return YES;
    }
    return NO;
}

- (void)monitorNetworkChanges {
    //监听网络变化通知：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kRealReachabilityChangedNotification object:nil];
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    if (status == RealStatusNotReachable) {
        NSLog(@"网络连接已断开，请检查您的网络");
    }
    
    if (status == RealStatusViaWiFi) {
        NSLog(@"WiFi网络");
    }
    
    if (status == RealStatusViaWWAN) {
        NSLog(@"蜂窝数据网");
    }
}
- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 监测当前网络状态（网络监听）
/**
 *  监测当前网络状态（网络监听） 使用通知监听
 */
- (void)checkNetworkStatus:(NSNotification *)notification {
    
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable) {
        NSLog(@"网络连接已断开，请检查您的网络");
    }
    
    if (status == RealStatusViaWiFi) {
        NSLog(@"WiFi网络");
    }
    
    if (status == RealStatusViaWWAN) {
        NSLog(@"蜂窝数据网");
    }
    
    //查询当前实际网络连接类型
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN) {
        
        if (accessType == WWANType2G) {
            NSLog(@"2G网络");
        } else if (accessType == WWANType3G) {
            NSLog(@"3G网络");
        } else if (accessType == WWANType4G) {
            NSLog(@"4G网络");
        } else {
            NSLog(@"未知网络状态,可能是iOS6");
        }
    }
}

#pragma mark - 检查网络连接
/**
 *  检查网络连接  //这个可以测出网络状态
 */
- (BOOL)AFNetworkStatus {
    //是否正在检查网络
    __block BOOL canCheckNetwork  = NO;
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    //网络只有在startMonitoring完成后才可以使用检查网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        canCheckNetwork = YES;
    }];
    
    //只能在监听完善之后才可以调用
    //有网络
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //网络有问题
    if(isOK == NO && canCheckNetwork == YES){
        //NSError *error = [NSError errorWithDomain:@"网络错位" code:100 userInfo:nil];
        NSLog(@"没有网络");
        //提示没有网络
        //        [MBProgressHUD qucickTip:@"没有网络"];
        return NO;
    }
    return YES;
}

@end
