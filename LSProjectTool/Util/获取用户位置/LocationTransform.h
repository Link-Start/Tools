//
//  LocationTransform.h
//  RuiTuEBusiness
//
//  Created by macbook v5 on 2018/8/30.
//  Copyright © 2018年 Naive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationTransform : NSObject

@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

- (id)initWithLatitude:(double)latitude andLongitude:(double)longitude;

/*
 坐标系： WGS-84世界标准坐标、GCJ-02中国国测局(火星坐标)、BD-09百度坐标系
 WGS-84：是国际标准，GPS坐标（Google Earth使用、或者GPS模块）
 GCJ-02：中国坐标偏移标准，Google Map、高德、腾讯使用
 BD-09 ：百度坐标偏移标准，Baidu Map使用
 */

#pragma mark - 从GPS坐标转化到高德坐标
///从GPS坐标转化到高德坐标      WGS-84 -----> GCJ-02
- (id)transformFromGPSToGD;
#pragma mark - 从高德坐标到GPS坐标
///从高德坐标到GPS坐标              GCJ-02 -----> WGS-84
- (id)transformFromGDToGPS;

#pragma mark - 从高德坐标转化到百度坐标
///从高德坐标转化到百度坐标       GCJ-02 -----> BD-09
- (id)transformFromGDToBD;
#pragma mark - 从百度坐标到高德坐标
///从百度坐标到高德坐标                BD-09 -----> GCJ-02
- (id)transformFromBDToGD;

#pragma mark - 从百度坐标到GPS坐标
///从百度坐标到GPS坐标             BD-09 -----> WGS-84
- (id)transformFromBDToGPS;
#pragma mark - 从GPS坐标到百度坐标
///从GPS坐标到百度坐标             WGS-84  -----> BD-09
- (id)transformFromGPSToBD;



/********************************************************************************************************************************************/

/// 只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
/// @param location 世界标准地理坐标(WGS-84)
/// @return 中国国测局地理坐标（GCJ-02）<火星坐标>
+ (CLLocationCoordinate2D)WGS84ToGCJ02:(CLLocationCoordinate2D)location;


/// 中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
/// 此接口有1－2米左右的误差，需要精确定位情景慎用
/// @param location 中国国测局地理坐标（GCJ-02）
/// @return 世界标准地理坐标（WGS-84）
+ (CLLocationCoordinate2D)GCJ02ToWGS84:(CLLocationCoordinate2D)location;


/// 世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
/// @param location 世界标准地理坐标(WGS-84)
/// @return 百度地理坐标（BD-09)
+ (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)location;


/// 中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
/// @param location 中国国测局地理坐标（GCJ-02）<火星坐标>
/// @return 百度地理坐标（BD-09)
+ (CLLocationCoordinate2D)GCJ02ToBD09:(CLLocationCoordinate2D)location;


/// 百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
/// @param location 百度地理坐标（BD-09)
/// @return 中国国测局地理坐标（GCJ-02）<火星坐标>
+ (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)location;


/// 百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
/// 此接口有1－2米左右的误差，需要精确定位情景慎用
/// @param location 百度地理坐标（BD-09)
/// @return 世界标准地理坐标（WGS-84）
+ (CLLocationCoordinate2D)BD09ToWGS84:(CLLocationCoordinate2D)location;

@end
