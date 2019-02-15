//
//  LSGetCurrentLocation.m
//  JKL
//
//  Created by Xcode on 16/8/27.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "LSGetCurrentLocation.h"

#import <CoreLocation/CoreLocation.h>

@interface LSGetCurrentLocation ()<CLLocationManagerDelegate>

///定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;


@property (nonatomic, copy) void(^didUpdateLocationClosure)(CLLocationCoordinate2D);

@end

@implementation LSGetCurrentLocation


- (instancetype)init {
    self = [super init];
    
    if (self) {
        //设置
        [self config];
      }
    return self;
}

 //设置
- (void)config {
    // 初始化定位管理器
    self.locationManager = [[CLLocationManager alloc] init];
    // 设置代理
    self.locationManager.delegate = self;
    // 设置定位精确
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    //取得定位权限
    [self.locationManager requestWhenInUseAuthorization];
    // 开始定位
    [self.locationManager startUpdatingLocation];
}

/******** 开始定位 ************/
- (void)startUpdateLocation {
    //开始定位
    [self.locationManager startUpdatingLocation];
}

/*********** 根据经纬度获取地址 *****************/
- (void)getAddressFromLocation:(CLLocationCoordinate2D)locationCoordinate {
    
    
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:locationCoordinate.latitude longitude:locationCoordinate.longitude];
    
    //根据经纬度反向地理编译出地址信息
    [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        NSString *address = @"";
        
        if (error == nil) {
            //取得第一个地标，地标中存储了详细的地址信息，注意：一个地名可能搜索出多个地址
            
            CLPlacemark *placemark = [placemarks firstObject];
            
            NSString *street = [[placemarks firstObject] thoroughfare];
            NSString *subStreet = [[placemarks firstObject] subThoroughfare];
            address = [NSString stringWithFormat:@"%@%@", street, subStreet];
            
            //        CLLocation *location=placemark.location;//位置
            //        CLRegion *region=placemark.region;//区域
            //        NSString *name=placemark.name;//地名
            //        NSString *thoroughfare=placemark.thoroughfare;//街道
            //        NSString *subThoroughfare=placemark.subThoroughfare; //街道相关信息，例如门牌等
            //        NSString *locality=placemark.locality; // 城市
            //        NSString *subLocality=placemark.subLocality; // 城市相关信息，例如标志性建筑
            //        NSString *administrativeArea=placemark.administrativeArea; // 州
            //        NSString *subAdministrativeArea=placemark.subAdministrativeArea; //其他行政区域信息
            //        NSString *postalCode=placemark.postalCode; //邮编
            //        NSString *ISOcountryCode=placemark.ISOcountryCode; //国家编码
            //        NSString *country=placemark.country; //国家
            //        NSString *inlandWater=placemark.inlandWater; //水源、湖泊
            //        NSString *ocean=placemark.ocean; // 海洋
            //        NSArray *areasOfInterest=placemark.areasOfInterest; //关联的或利益相关的地标
            
             if (self.getCurrentLocation) {
                 
                 self.getCurrentLocation(street, placemark);
            }
        } else {
            NSLog(@"定位解析出错");
        }
        
    }];
    
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
}

/**
 *  定位回调函数
 *
 *  @param manager 定位 LocationManager 类。
 *  @param location 定位结果。
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *location = [locations firstObject];//取出第一个位置
    CLLocationCoordinate2D coordinate = location.coordinate;//位置坐标
   //如果不需要实时定位，使用完即使关闭定位服务
    [self.locationManager stopUpdatingLocation];
    
    if (self.didUpdateLocationClosure) {
        self.didUpdateLocationClosure(coordinate);
    } else {
        //根据经纬度获取地址
        [self getAddressFromLocation:coordinate];
    }
}

@end
