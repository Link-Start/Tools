//
//  LSLocationConverter.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/20.
//  Copyright © 2021 Link-Start. All rights reserved.
//  坐标 转换
//
// https://github.com/JackZhouCn/JZLocationConverter
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

/*
 坐标系： WGS-84世界标准坐标、GCJ-02中国国测局(火星坐标)、BD-09百度坐标系
 WGS-84：表示GPS获取的坐标
        是国际标准，（Google Earth使用、或者GPS模块）
 GCJ-02：是由中国国家测绘局制订的地理信息系统的坐标系统。由WGS84坐标系经加密后的坐标系。
        中国坐标偏移标准,(Google Map、高德、腾讯使用)
 BD-09 ：为百度坐标系，在GCJ02坐标系基础上再次加密。其中bd09ll表示百度经纬度坐标，bd09mc表示百度墨卡托米制坐标；
        百度地图SDK在国内（包括港澳台）使用的是BD09坐标；在海外地区，统一使用WGS84坐标。开发者在使用百度地图相关服务时，请注意选择。
        百度坐标偏移标准，(Baidu Map使用 (BMK09LL、BMK09MC))
 */

///WGS-84世界标准坐标、GCJ-02中国国测局(火星坐标)、BD-09百度坐标
@interface LSLocationConverter : NSObject

/// 从GPS坐标转化到高德坐标      WGS-84 -----> GCJ-02
/// 此接口当输入坐标为中国大陆以外时，仍旧返回WGS-84坐标
/// 世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
/// 只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
/// @param location 世界标准地理坐标(WGS-84)
/// @return 中国国测局地理坐标（GCJ-02）<火星坐标>
+ (CLLocationCoordinate2D)WGS84ToGCJ02:(CLLocationCoordinate2D)location;

/// 从高德坐标到GPS坐标              GCJ-02 -----> WGS-84
/// 此接口有1－2米左右的误差，需要精确定位情景慎用
/// 中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
/// @param location 中国国测局地理坐标（GCJ-02）
/// @return 世界标准地理坐标（WGS-84）
+ (CLLocationCoordinate2D)GCJ02ToWGS84:(CLLocationCoordinate2D)location;

/// 从GPS坐标到百度坐标             WGS-84  -----> BD-09
/// 世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
/// @param location 世界标准地理坐标(WGS-84)
/// @return 百度地理坐标（BD-09)
+ (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)location;

/// 从高德坐标转化到百度坐标       GCJ-02 -----> BD-09
/// 中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
/// @param location 中国国测局地理坐标（GCJ-02）<火星坐标>
/// @return 百度地理坐标（BD-09)
+ (CLLocationCoordinate2D)GCJ02ToBD09:(CLLocationCoordinate2D)location;

/// 从百度坐标到高德坐标                BD-09 -----> GCJ-02
/// 百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
/// @param location 百度地理坐标（BD-09)
/// @return 中国国测局地理坐标（GCJ-02）<火星坐标>
+ (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)location;

/// 从百度坐标到GPS坐标             BD-09 -----> WGS-84
/// 此接口有1－2米左右的误差，需要精确定位情景慎用
/// 百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
/// @param location 百度地理坐标（BD-09)
/// @return 世界标准地理坐标（WGS-84）
+ (CLLocationCoordinate2D)BD09ToWGS84:(CLLocationCoordinate2D)location;


@end

NS_ASSUME_NONNULL_END
