//
//  GetMacAndIPAddress.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/10/20.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//  https://blog.csdn.net/ljc_563812704/article/details/125045440
//  ios获取设备其它信息这里就不说了,主要介绍下ipAddress 和 macAddress的获取方法(WIFI和蜂窝网络状态下).
//  获得手机的mac地址，但是有个限制，是在iOS7以下才可以获得。
//  iOS7以后苹果对于sysctl和ioctl进行了技术处理，MAC地址返回的都是02:00:00:00:00:00。

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GetMacAndIPAddress : NSObject


/// 获取设备当前网络IP地址
- (NSString *)getIPAddress:(BOOL)preferIPv4;

/// 获取设备物理地址
- (nullable NSString *)getMacAddress;


@end


/**
NSString * ip4 = [self getIPAddress:YES];
NSString * ip = [self getIPAddress:NO];
NSString * mac = [self getMacAddress];

NSLog(@"---%@",ip4);
NSLog(@"---%@",ip);
NSLog(@"---%@",mac);
 */

NS_ASSUME_NONNULL_END
