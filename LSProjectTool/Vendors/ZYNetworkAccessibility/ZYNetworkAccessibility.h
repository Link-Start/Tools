//
//  ZYNetworkAccessibility.h
//
//  Created by zie on 16/11/17.
//  Copyright © 2017年 zie. All rights reserved.
//
//  检测 iOS 系统网络权限被关闭:   https://www.jianshu.com/p/81d0b7f06eba
// 如何获取iOS应用网络权限？ https://www.tinymind.net.cn/articles/b1e929a7cb2224
// SCNetworkReachabilityRef获取网络类型的方法越来越不靠谱了，苹果在WWDC2017/2018中也提到了尽量不要用SCNetworkReachabilityRef去判断网络。

#import <Foundation/Foundation.h>

extern NSString * const ZYNetworkAccessibilityChangedNotification;

typedef NS_ENUM(NSUInteger, ZYNetworkAccessibleState) {
    /// 检查
    ZYNetworkChecking  = 0,
    /// 未知
    ZYNetworkUnknown     ,
    /// 可访问
    ZYNetworkAccessible  ,
    /// 受限
    ZYNetworkRestricted  ,
};

typedef void (^NetworkAccessibleStateNotifier)(ZYNetworkAccessibleState state);

@interface ZYNetworkAccessibility : NSObject

/**
 开启 ZYNetworkAccessibility
 */
+ (void)start;

/**
 停止 ZYNetworkAccessibility
 */
+ (void)stop;

/**
 当判断网络状态为 ZYNetworkRestricted 时，提示用户开启网络权限
 */
+ (void)setAlertEnable:(BOOL)setAlertEnable;

/**
  通过 block 方式监控网络权限变化。
 */
+ (void)setStateDidUpdateNotifier:(void (^)(ZYNetworkAccessibleState))block;

/**
 返回的是最近一次的网络状态检查结果，若距离上一次检测结果短时间内网络授权状态发生变化，该值可能会不准确。
 */
+ (ZYNetworkAccessibleState)currentState;

@end


/**
 https://www.tinymind.net.cn/articles/b1e929a7cb2224
 
 一、问题描述

 在iOS 10下 ，首次进入应用时，会有询问是否允许网络连接权限的的弹窗，为更好进行用户交互，需要在打开应用时获取应用禁用网络权限状态（状态分为：未知、限制网络、未限制网络），客户端根据不同的权限状态定制相应的人机交互。

 二、问题调研

 针对请求应用网络权限可能存在的几种情形，操作与对应的状态都是笔者测试得到的，具体如下所示：

 可能操作               关闭              无线局域网               无线局域网&蜂窝                不进行操作               锁屏              解锁              按Home键
 权限状态           Restricted        NotRestricted             NotRestricted                     Unknown             Unknown    恢复原始状态   保持原有状态
 
 当联网权限的状态发生改变时，会在上述方法中捕捉到改变后的状态，可根据更新后的状态执行相应的操作。
 CTCellularData *cellularData = [[CTCellularData alloc]init];
 cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state){
    //状态改变时进行相关操作
 };
 
 当查询应用联网权限时可以使用下面的方法：
 CTCellularData *cellularData = [[CTCellularData alloc]init];
 CTCellularDataRestrictedState state = cellularData.restrictedState;
 switch (state) {
    case kCTCellularDataRestricted:
        NSLog(@"Restricrted");
        break;
    case kCTCellularDataNotRestricted:
        NSLog(@"Not Restricted");
        break;
    case kCTCellularDataRestrictedStateUnknown:
        NSLog(@"Unknown");
        break;
    default:
        break;
 }
 
 补充一下
 CoreTelephony.frameworkiOS7之前还是私有框架，框架内部提供还是私有API,但在iOS7之后该框架就成为公开的框架，大家可以尽情的使用了。
 
 
 
 
 */
