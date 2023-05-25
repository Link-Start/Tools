//
//  JumpThirdPartyMapTools.h
//  NiuCheCheUserSide
//
//  Created by macbook v5 on 2018/7/17.
//  Copyright © 2018年 LinkStart. All rights reserved.
//  跳转到第三方地图
//  要注意坐标系的转换

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol JumpThirdPartyMapToolsDelegate<NSObject>

- (void)presentVC:(UIAlertController *)alert;

@end

@interface JumpThirdPartyMapTools : NSObject

@property (nonatomic, weak) id<JumpThirdPartyMapToolsDelegate> delegate;



/// 自动判断手机安装的地图应用并弹出弹窗
/// @param endLocation 目的地经纬度
/// @param endAddress 目的地地址字符串
-(void)navThirdMapWithLocation:(CLLocationCoordinate2D)endLocation endAddressStr:(NSString *)endAddress;


/********************************************************************************************************************/
/********************************************************************************************************************/
/********************************************************************************************************************/

/// latitude:纬度    longitude:经度      map_title:     amap:高德地图     baidu:百度地图     其他:苹果自带地图
+ (void)jumpMapNaviWithLatitude:(double)latitude longitude:(double)longitude andWithMapTitle:(NSString *)map_title andEndAddress:(NSString *)endAddress;
/// 唤醒苹果自带导航
+ (void)appleNaiWithCoordinate:(CLLocationCoordinate2D)coordinate endAddress:(NSString *)endAddress;
/// 高德导航
+ (void)aNaviWithCoordinate:(CLLocationCoordinate2D)coordinate endAddress:(NSString *)endAddress;
/// 百度地图
+ (void)baiduNaviWithCoordinate:(CLLocationCoordinate2D)coordinate endAddress:(NSString *)endAddress;


@end
