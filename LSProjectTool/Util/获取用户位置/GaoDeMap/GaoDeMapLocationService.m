//
//  GaoDeMapLocationService.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/10/19.
//  Copyright © 2023 Link-Start. All rights reserved.
//
// https://www.cnblogs.com/fei-sky-001-o/articles/4953075.html
// 苹果自带原生地图：
//      <MapKit>:地图框架，显示地图
//      <CoreLocation>:定位框架，没有地图时也可以使用定位.
//
//      #import <MapKit/MapKit.h>
//      #import <MapKit/MKMapView.h>
//
// 高德地图官方SDK：
//      MAMapKit.framework:高德地图的库文件，<MAMapKit>
//      AMapSearchKit.framework:搜索库文件，<AMapSearchKit>
//
//      #import <MAMapKit/MAMapKit.h>
//      #import <MAMapKit/MAMapView.h>
//
//      2D地图：显示出来地图字体莫名奇妙的大，地图还不能360°旋转




#import "GaoDeMapLocationService.h"


@interface GaoDeMapLocationService ()<AMapLocationManagerDelegate>

@property (nonatomic, strong) AMapLocationManager *locationManager;

@end


@implementation GaoDeMapLocationService

+ (GaoDeMapLocationService *)shareInstanse{
    static GaoDeMapLocationService *_instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc]init];
    });
    return _instance;
}

- (AMapLocationManager *)locationManager {
    if (!_locationManager) {
        // 初始化
        _locationManager = [[AMapLocationManager alloc] init];
        // 设置代理
        _locationManager.delegate = self;
        
        // 设置期望定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        // 设置定位的最小更新距离
        _locationManager.distanceFilter = 50;
        // 设置不允许系统暂停定位
        _locationManager.pausesLocationUpdatesAutomatically = NO;
        // 设置允许在后台定位
//        _locationManager.allowsBackgroundLocationUpdates = YES;
        
        // 设置定位超时时间
        _locationManager.locationTimeout = 10;
        //设置逆地理超时时间
        _locationManager.reGeocodeTimeout = 10;
         
        // 设置开启虚拟定位风险监测，可以根据需要开启
//        _locationManager.detectRiskOfFakeLocation = NO;
        /////连续定位是否返回逆地理信息，默认NO。
        //[_locationManager setLocatingWithReGeocode:YES];
    }
    return _locationManager;
}

// 定位
- (void)startLocationServiceWithComplete:(void (^)(BOOL))complete {
    // 单次定位。如果当前正在连续定位，调用此方法将会失败，返回NO
    // withReGeocode：是否带有逆地理信息(获取逆地理信息需要联网)
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            
            if (error.code == AMapLocationErrorLocateFailed) {                   // 2, <定位错误
                //定位错误：此时location和regeocode没有返回值，不进行annotation的添加
                NSLog(@"定位错误:{%ld - %@};", (long)error.code, error.userInfo);
            } else if ((error.code == AMapLocationErrorReGeocodeFailed            // 3, <逆地理错误
                         || error.code == AMapLocationErrorTimeOut              // 4, <超时
                         || error.code == AMapLocationErrorCannotFindHost        // 6, <找不到主机
                         || error.code == AMapLocationErrorBadURL               // 7, <URL异常
                         || error.code == AMapLocationErrorNotConnectedToInternet // 8, <连接异常
                         || error.code == AMapLocationErrorCannotConnectToHost))  // 9, <服务器连接失败
            {
                //逆地理错误：在带逆地理的单次定位中，逆地理过程可能发生错误，此时location有返回值，regeocode无返回值，进行annotation的添加
                NSLog(@"逆地理错误:{%ld - %@};", (long)error.code, error.userInfo);
                
            } else if (error.code == AMapLocationErrorRiskOfFakeLocation)         // 11, <存在虚拟定位风险
            {
                //存在虚拟定位的风险：此时location和regeocode没有返回值，不进行annotation的添加
                NSLog(@"存在虚拟定位的风险:{%ld - %@};", (long)error.code, error.userInfo);
                
                //存在虚拟定位的风险的定位结果
                __unused CLLocation *riskyLocateResult = [error.userInfo objectForKey:@"AMapLocationRiskyLocateResult"];
                //存在外接的辅助定位设备
                __unused NSDictionary *externalAccressory = [error.userInfo objectForKey:@"AMapLocationAccessoryInfo"];
            }
            
            if (complete) {
                complete(NO);
            }
            return;
        }
        if (!error) {
            self.currentLocation = location;
            self.regeocode = regeocode;//逆地理信息
            NSLog(@"经度longitude:%f, 纬度latitude:%f,", location.coordinate.longitude, location.coordinate.latitude);
            if (complete) {
                complete(YES);
            }
        }
    }];
}

// 定位, 没有定位权限就弹窗提示
- (void)startLocationServiceNoPermissionPopupTipsWithComplete:(void (^)(BOOL))complete {
    
    // 单次定位。如果当前正在连续定位，调用此方法将会失败，返回NO
    // withReGeocode：是否带有逆地理信息(获取逆地理信息需要联网)
    [self.locationManager requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
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
            self.regeocode = regeocode;//逆地理信息
            NSLog(@"经度longitude:%f, 纬度latitude:%f,", location.coordinate.longitude, location.coordinate.latitude);
            if (complete) {
                complete(YES);
            }
        }
    }];
}

#pragma mark - 必须实现此方法，不然运行项目的时候不会弹出 授权定位的提示弹窗
/// 要在iOS 8 及以上版本使用后台定位服务，需要实现 amapLocationManager:doRequireLocationAuth:代理方法，否则没有定位授权弹窗
/// @brief 当plist配置NSLocationAlwaysUsageDescription或者NSLocationAlwaysAndWhenInUseUsageDescription，
/// 并且[CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined，会调用代理的此方法。
/// 此方法实现调用申请后台权限API即可：[locationManager requestAlwaysAuthorization] (必须调用,不然无法正常获取定位权限)
///
- (void)amapLocationManager:(AMapLocationManager *)manager doRequireLocationAuth:(CLLocationManager *)locationManager {
    [locationManager requestWhenInUseAuthorization];// 使用期间使用位置信息, 可以更换
//    [locationManager requestAlwaysAuthorization];// 始终使用位置信息，
}

/// 定位权限状态改变时回调函数。注意：iOS13及之前版本回调
- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    NSLog(@"定位权限状态改变时回调函数。注意：iOS13及之前版本回调");
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationAuthStatusChangeNotification object:nil  userInfo:@{@"authStatus":@(status)}];
    }
}

/// 定位权限状态改变时回调函数。注意：iOS14及之后版本回调
- (void)amapLocationManager:(AMapLocationManager *)manager locationManagerDidChangeAuthorization:(CLLocationManager *)locationManager {
    NSLog(@"定位权限状态改变时回调函数。注意：iOS14及之后版本回调");
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse ||
        [CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:OPLocationAuthStatusChangeNotification object:nil  userInfo:@{@"authStatus":@([CLLocationManager authorizationStatus])}];
        
        // int status = (int)(notif.userInfo[@"authStatus"]);
        //
    }
}


///// 连续定位回调函数.注意：本方法已被废弃，如果实现了amapLocationManager:didUpdateLocation:reGeocode:方法，则本方法将不会回调。
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location {
//    NSLog(@"连续定位回调函数.注意：本方法已被废弃，如果实现了amapLocationManager:didUpdateLocation:reGeocode:方法，则本方法将不会回调。");
//}
///// 连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
//    NSLog(@"连续定位回调函数.注意：如果实现了本方法，则定位信息不会通过amapLocationManager:didUpdateLocation:方法回调。");
//}
//
///// 是否显示设备朝向校准
//- (BOOL)amapLocationManagerShouldDisplayHeadingCalibration:(AMapLocationManager *)manager {
//    return YES;
//}
//
///// 设备方向改变时回调函数
//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateHeading:(CLHeading *)newHeading {
//    NSLog(@"设备方向改变时回调函数");
//}





/// 获取当前用户纬度
- (NSNumber *)getCurrentLocationLatitude {
//    return self.currentLocation?@(self.currentLocation.coordinate.latitude):nil;
    return self.currentLocation?[NSNumber numberWithDouble:self.currentLocation.coordinate.latitude]:nil;
}

/// 获取当前用户经度
- (NSNumber *)getCurrentLocationLongtitude {
//    return self.currentLocation?@(self.currentLocation.coordinate.longitude):nil;
    return self.currentLocation?[NSNumber numberWithDouble:self.currentLocation.coordinate.longitude]:nil;
}


@end
