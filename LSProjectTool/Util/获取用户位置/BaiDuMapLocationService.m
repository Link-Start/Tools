//
//  BaiDuMapLocationService.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2022/3/24.
//  Copyright © 2022 Link-Start. All rights reserved.
//

#import "BaiDuMapLocationService.h"

@interface BaiDuMapLocationService ()<BMKLocationManagerDelegate>

@property (nonatomic, strong) BMKLocationManager *locationManager;

@end

@implementation BaiDuMapLocationService

+ (BaiDuMapLocationService *)shareInstance {
    static BaiDuMapLocationService *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    
    return _instance;
}

- (BMKLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[BMKLocationManager alloc] init];
        // 设置 delegate
        _locationManager.delegate = self;
        // 设置返回位置的坐标系类型    [设定定位坐标系类型]
        _locationManager.coordinateType = BMKLocationCoordinateTypeBMK09LL;
        // 设置距离过滤参数           [设定定位的最小更新距离]
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        // 设置预期精准参数           [设定定位精度]
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // 设置应用位置类型           [设定定位类型]
        _locationManager.activityType = CLActivityTypeAutomotiveNavigation;
        // 设置是否自动停止位置更新     [指定定位是否会被系统自动暂停]
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        //                         [是否需要最新版本rgc数据]
        _locationManager.isNeedNewVersionReGeocode = YES;
        // 设置是否允许后台定位        [是否允许后台定位]
//        _locationManager.allowsBackgroundLocationUpdates = YES;
        //设置位置获取超时时间         [指定单次定位超时时间]
        _locationManager.locationTimeout = 10.0;
        // 设置获取地址信息超时时间     [指定单次定位逆地理超时时间]
        _locationManager.reGeocodeTimeout = 10.0;
    }
    return _locationManager;
}

/// 定位, 没有定位权限也不提示
- (void)startLocationServiceWithComplete:(void(^)(BOOL isSuccess))complete {
    // 单次定位。如果当前正在连续定位，调用此方法将会失败，返回NO
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) { //定位失败
            if (complete) {
                complete(NO);
            }
            return;
        }
        else { // 定位成功
            self.currentLocation = location;
            if (complete) {
                complete(YES);
            }
        }
    }];
}

/// 定位, 没有定位权限就弹窗提示
- (void)startLocationServiceNoPermissionPopupTipsWithComplete:(void(^)(BOOL isSuccess))complete {
    // 单次定位。如果当前正在连续定位，调用此方法将会失败，返回NO
    [self.locationManager requestLocationWithReGeocode:YES withNetworkState:YES completionBlock:^(BMKLocation * _Nullable location, BMKLocationNetworkState state, NSError * _Nullable error) {
        if (error) { //定位失败
            if (complete) {
                complete(NO);
            }
            
            // 定位权限关闭，提示打开权限弹窗
            UIAlertController *alertContr = [UIAlertController alertControllerWithTitle:@"提示" message:error.userInfo[NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                if ([[UIApplication sharedApplication] canOpenURL:url]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];
                    } else {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                }
            }];
            [alertContr addAction:action];
            UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
            [rootVC presentViewController:alertContr animated:YES completion:^{}];
            
            return;
        }
        else { // 定位成功
            self.currentLocation = location;
            if (complete) {
                complete(YES);
            }
        }
    }];
}



/// 定位权限状态改变时回调函数
- (void)BMKLocationManager:(BMKLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse
        || [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
        NSLog(@"定位权限状态改变(老方法)");
//        return;
    }
}

/// 定位权限状态改变时回调函数
/// authorizationStatus或者accuracyAuthorization有变化时回调函数
- (void)BMKLocationManagerDidChangeAuthorization:(BMKLocationManager *)manager {
    NSLog(@"定位权限状态改变(新方法)");
}

/// 获取当前用户纬度
- (NSNumber *)getCurrentLocationLatitude {
    return self.currentLocation?@(self.currentLocation.location.coordinate.latitude):nil;
}

/// 获取当前用户经度
- (NSNumber *)getCurrentLocationLongtitude {
    return self.currentLocation?@(self.currentLocation.location.coordinate.longitude):nil;
}





@end

/**
 
1、百度地图SDK使用什么坐标系？
 （1） 百度地图SDK在国内（包括港澳台），输入、输出默认使用BD09坐标；定位SDK默认输出是使用GCJ02坐标。
 自iOSv3.3起，支持一次声明为GCJ02坐标类型，全应用支持输入GCJ02坐标，返回GCJ02坐标。
 （2） 海外地区，输入为WGS84坐标。
 
2、 什么是国测局坐标、百度坐标、WGS84坐标？
 三种坐标系说明如下：
 （1）WGS84：表示GPS获取的坐标；
 （2）GCJ02：是由中国国家测绘局制订的地理信息系统的坐标系统。由WGS84坐标系经加密后的坐标系。
 （3）BD09：为百度坐标系，在GCJ02坐标系基础上再次加密。其中bd09ll表示百度经纬度坐标，bd09mc表示百度墨卡托米制坐标；

 百度地图SDK在国内（包括港澳台）使用的是BD09坐标；在海外地区，统一使用WGS84坐标。开发者在使用百度地图相关服务时，请注意选择。
  
 从其他体系的坐标迁移到百度坐标：百度地图开放平台提供了官方的坐标转换接口，请开发者直接选择使用。开发者切勿从非官方渠道获得坐标转换方法。
 *  @brief 转换为百度经纬度的坐标
 *  @param coordinate 待转换的经纬度
 *  @param srctype    待转换坐标系类型
 *  @param destype    目标百度坐标系类型（bd09ll,bd09mc）
 *  @return 目标百度坐标系经纬度
 + (CLLocationCoordinate2D) BMKLocationCoordinateConvert:(CLLocationCoordinate2D) coordinate SrcType:(BMKLocationCoordinateType)srctype DesType:(BMKLocationCoordinateType)destype;
 
 */
