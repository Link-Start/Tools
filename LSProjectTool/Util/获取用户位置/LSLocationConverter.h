//
//  LSLocationConverter.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/20.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>


NS_ASSUME_NONNULL_BEGIN

///WGS-84世界标准坐标、GCJ-02中国国测局(火星坐标)、BD-09百度坐标
@interface LSLocationConverter : NSObject

/// WGS-84  -> GCJ-02 此接口当输入坐标为中国大陆以外时，仍旧返回WGS-84坐标
/// 世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
/// 只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
/// @param location 世界标准地理坐标(WGS-84)
/// @return 中国国测局地理坐标（GCJ-02）<火星坐标>
+ (CLLocationCoordinate2D)WGS84ToGCJ02:(CLLocationCoordinate2D)location;

/// GCJ-02  -> WGS-84    此接口有1－2米左右的误差，需要精确定位情景慎用
/// 中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
/// @param location 中国国测局地理坐标（GCJ-02）
/// @return 世界标准地理坐标（WGS-84）
+ (CLLocationCoordinate2D)GCJ02ToWGS84:(CLLocationCoordinate2D)location;

/// WGS-84  -> BD-09
/// 世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
/// @param location 世界标准地理坐标(WGS-84)
/// @return 百度地理坐标（BD-09)
+ (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)location;

/// GCJ-02   -> BD-09
/// 中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
/// @param location 中国国测局地理坐标（GCJ-02）<火星坐标>
/// @return 百度地理坐标（BD-09)
+ (CLLocationCoordinate2D)GCJ02ToBD09:(CLLocationCoordinate2D)location;

/// BD-09     -> GCJ-02
/// 百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
/// @param location 百度地理坐标（BD-09)
/// @return 中国国测局地理坐标（GCJ-02）<火星坐标>
+ (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)location;

/// BD-09     -> WGS-84     此接口有1－2米左右的误差，需要精确定位情景慎用
/// 百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
/// @param location 百度地理坐标（BD-09)
/// @return 世界标准地理坐标（WGS-84）
+ (CLLocationCoordinate2D)BD09ToWGS84:(CLLocationCoordinate2D)location;


@end

NS_ASSUME_NONNULL_END
