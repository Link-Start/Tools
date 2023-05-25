//
//  LocationTransform.m
//  RuiTuEBusiness
//
//  Created by macbook v5 on 2018/8/30.
//  Copyright © 2018年 Naive. All rights reserved.
//



#import "LocationTransform.h"
#import <CoreLocation/CoreLocation.h>

static const double a = 6378245.0;
static const double ee = 0.00669342162296594323;
static const double pi = M_PI;
static const double xPi = M_PI  * 3000.0 / 180.0;


@implementation LocationTransform

- (id)initWithLatitude:(double)latitude andLongitude:(double)longitude {
    if (self = [super init]) {
        self.latitude = latitude;
        self.longitude = longitude;
    }
    return self;
}
#pragma mark - GPS坐标<------>高德坐标
//从GPS坐标转化到高德坐标      WGS-84 -----> GCJ-02
- (id)transformFromGPSToGD {
    CLLocationCoordinate2D coor = [LocationTransform transformFromWGSToGCJ:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    return [[LocationTransform alloc] initWithLatitude:coor.latitude andLongitude:coor.longitude];
}
//从高德坐标到GPS坐标              GCJ-02 -----> WGS-84
- (id)transformFromGDToGPS {
    CLLocationCoordinate2D coor = [LocationTransform transformFromGCJToWGS:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    return [[LocationTransform alloc] initWithLatitude:coor.latitude andLongitude:coor.longitude];
}
#pragma mark - 高德坐标<------>百度坐标
//从高德坐标转化到百度坐标       GCJ-02 -----> BD-09
- (id)transformFromGDToBD {
    CLLocationCoordinate2D coor = [LocationTransform transformFromGCJToBaidu:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    return [[LocationTransform alloc] initWithLatitude:coor.latitude andLongitude:coor.longitude];
}
//从百度坐标到高德坐标                BD-09 -----> GCJ-02
- (id)transformFromBDToGD {
    CLLocationCoordinate2D coor = [LocationTransform transformFromBaiduToGCJ:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    return [[LocationTransform alloc] initWithLatitude:coor.latitude andLongitude:coor.longitude];
}

#pragma mark - 百度坐标<------>GPS坐标
// 从百度坐标到GPS坐标             BD-09 -----> GCJ-02 -----> WGS-84
- (id)transformFromBDToGPS {
    //先把百度转化为高德
    CLLocationCoordinate2D start_coor = [LocationTransform transformFromBaiduToGCJ:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    // 然后把 高德(gcj) 转换为 GPS(wgs)
    CLLocationCoordinate2D end_coor = [LocationTransform transformFromGCJToWGS:CLLocationCoordinate2DMake(start_coor.latitude, start_coor.longitude)];
    return [[LocationTransform alloc] initWithLatitude:end_coor.latitude andLongitude:end_coor.longitude];
}

// 从GPS坐标到百度坐标             WGS-84 -----> GCJ-02 -----> BD-09
- (id)transformFromGPSToBD {
    // 先把GPS坐标 转换为 高德坐标 [WGS-84 -> GCJ-02]
    CLLocationCoordinate2D gcj_coor = [LocationTransform transformFromWGSToGCJ:CLLocationCoordinate2DMake(self.latitude, self.longitude)];
    // 再把高德坐标 转换为 百度坐标 [GCJ-02 -> BD-09]
    CLLocationCoordinate2D bd_coor = [LocationTransform transformFromGCJToBaidu:CLLocationCoordinate2DMake(gcj_coor.latitude, gcj_coor.longitude)];
    return [[LocationTransform alloc] initWithLatitude:bd_coor.latitude andLongitude:bd_coor.longitude];;
}

// WGS-84 -----> GCJ-02
+ (CLLocationCoordinate2D)transformFromWGSToGCJ:(CLLocationCoordinate2D)wgsLoc {
    CLLocationCoordinate2D adjustLoc;
    // 判断是不是在中国
    if([self isLocationOutOfChina:wgsLoc]) {
        adjustLoc = wgsLoc;
    }
    else {
        double adjustLat = [self transformLatWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        double adjustLon = [self transformLonWithX:wgsLoc.longitude - 105.0 withY:wgsLoc.latitude - 35.0];
        long double radLat = wgsLoc.latitude / 180.0 * pi;
        long double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        long double sqrtMagic = sqrt(magic);
        adjustLat = (adjustLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * pi);
        adjustLon = (adjustLon * 180.0) / (a / sqrtMagic * cos(radLat) * pi);
        adjustLoc.latitude = wgsLoc.latitude + adjustLat;
        adjustLoc.longitude = wgsLoc.longitude + adjustLon;
    }
    return adjustLoc;
}

+ (double)transformLatWithX:(double)x withY:(double)y {
    double lat = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x));
    
    lat += (20.0 * sin(6.0 * x * pi) + 20.0 *sin(2.0 * x * pi)) * 2.0 / 3.0;
    lat += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    lat += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return lat;
}

+ (double)transformLonWithX:(double)x withY:(double)y {
    double lon = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    lon += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    lon += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    lon += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return lon;
}

/// 高德坐标转百度坐标                    GCJ02--------------->BD09
+ (CLLocationCoordinate2D)transformFromGCJToBaidu:(CLLocationCoordinate2D)p {
//    long double z = sqrt(p.longitude * p.longitude + p.latitude * p.latitude) + 0.00002 * sqrt(p.latitude * pi);
//    long double theta = atan2(p.latitude, p.longitude) + 0.000003 * cos(p.longitude * pi);
    
    double x = p.longitude;
    double y = p.latitude;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * pi); 
    double theta = atan2(y, x) + 0.000003 * cos(x * pi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude  = (z * sin(theta) + 0.006);
    geoPoint.longitude = (z * cos(theta) + 0.0065);
    return geoPoint;
}
/// 百度坐标转高德坐标                       BD09-------------->GCJ02
+ (CLLocationCoordinate2D)transformFromBaiduToGCJ:(CLLocationCoordinate2D)p {
    double x = p.longitude - 0.0065;
    double y = p.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    CLLocationCoordinate2D geoPoint;
    geoPoint.latitude  = z * sin(theta);
    geoPoint.longitude = z * cos(theta);
    return geoPoint;
}
//高德 --> GPS                   GCJ----->GPS
+ (CLLocationCoordinate2D)transformFromGCJToWGS:(CLLocationCoordinate2D)p {
    double threshold = 0.00001;
    
    // The boundary
    double minLat = p.latitude - 0.5;
    double maxLat = p.latitude + 0.5;
    double minLng = p.longitude - 0.5;
    double maxLng = p.longitude + 0.5;
    
    double delta = 1;
    int maxIteration = 30;
    // Binary search
    while(true) {
        CLLocationCoordinate2D leftBottom  = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = minLng}];
        CLLocationCoordinate2D rightBottom = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = minLat,.longitude = maxLng}];
        CLLocationCoordinate2D leftUp      = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = maxLat,.longitude = minLng}];
        CLLocationCoordinate2D midPoint    = [[self class] transformFromWGSToGCJ:(CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)}];
        delta = fabs(midPoint.latitude - p.latitude) + fabs(midPoint.longitude - p.longitude);
        
        if(maxIteration-- <= 0 || delta <= threshold) {
            return (CLLocationCoordinate2D){.latitude = ((minLat + maxLat) / 2),.longitude = ((minLng + maxLng) / 2)};
        }
        
        if(isContains(p, leftBottom, midPoint)) {
            maxLat = (minLat + maxLat) / 2;
            maxLng = (minLng + maxLng) / 2;
        } else if(isContains(p, rightBottom, midPoint)) {
            maxLat = (minLat + maxLat) / 2;
            minLng = (minLng + maxLng) / 2;
        } else if(isContains(p, leftUp, midPoint)) {
            minLat = (minLat + maxLat) / 2;
            maxLng = (minLng + maxLng) / 2;
        } else {
            minLat = (minLat + maxLat) / 2;
            minLng = (minLng + maxLng) / 2;
        }
    }
    
}

#pragma mark - 判断某个点point是否在p1和p2之间
static bool isContains(CLLocationCoordinate2D point, CLLocationCoordinate2D p1, CLLocationCoordinate2D p2) {
    return (point.latitude >= MIN(p1.latitude, p2.latitude) && point.latitude <= MAX(p1.latitude, p2.latitude)) && (point.longitude >= MIN(p1.longitude,p2.longitude) && point.longitude <= MAX(p1.longitude, p2.longitude));
}

#pragma mark - 判断是不是在中国
/// 判断是不是在中国
+ (BOOL)isLocationOutOfChina:(CLLocationCoordinate2D)location {
    if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271)
        return YES;
    return NO;
}

/// 计算地球上任意两点(经纬度)之间的距离 单位：米(m)
+ (double)calculateDistanceBetweenAnyTwoPointsOnTheEarthWithlat1:(double)lat1 lng1:(double)lng1 lat2:(double)lat2 lng2:(double)lng2 {
    
//    double a, b, R;
//    R = 6378137; // 地球半径
//    lat1 = lat1 * M_PI / 180.0;
//    lat2 = lat2 * M_PI / 180.0;
//    a = lat1 - lat2;
//    b = (lng1 - lng2) * M_PI / 180.0;
//
//    double d;
//    double sa2, sb2;
//    sa2 = sin(a / 2.0);
//    sb2 = sin(b / 2.0);
//    d = 2 * R * asin(sqrt(sa2 * sa2 + cos(lat1) * cos(lat2) * sb2 * sb2));
//    NSLog(@"两地之间的距离是：%.2fm", d);
//    NSLog(@"两地之间的距离是：%.2fkm", d/1000.0f);


    double d = calculateDistance(lat1, lng1, lat2, lng2);
    
    return d;
}
/// 计算地球上任意两点(经纬度)之间的距离 (单位：米(m))
static double calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    double a, b, R;
    R = 6378137; // 地球半径
    a = (lat1 - lat2) * M_PI / 180.0;
    b = (lng1 - lng2) * M_PI / 180.0;
    
    double d;
    double sa2, sb2;
    sa2 = sin(a / 2.0);
    sb2 = sin(b / 2.0);
    d = 2 * R * asin(sqrt(sa2 * sa2 + cos(lat1) * cos(lat2) * sb2 * sb2));
    NSLog(@"两地之间的距离是：%.2fm", d);
    NSLog(@"两地之间的距离是：%.2fkm", d/1000.0f);
    
    return d;
}

///********************************************************************************************************************************************/
///********************************************************************************************************************************************/
///********************************************************************************************************************************************/
///************************************* 上面的方法和下面的方法 转换过程中略有不同，具体哪个更精确 不晓得 *************************************/
///********************************************************************************************************************************************/
///********************************************************************************************************************************************/
///********************************************************************************************************************************************/

// https://github.com/JackZhouCn/JZLocationConverter

#define LAT_OFFSET_0(x,y) -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(fabs(x))
#define LAT_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_2 (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0
#define LAT_OFFSET_3 (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0

#define LON_OFFSET_0(x,y) 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x))
#define LON_OFFSET_1 (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_2 (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0
#define LON_OFFSET_3 (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0

#define RANGE_LON_MAX 137.8347
#define RANGE_LON_MIN 72.004
#define RANGE_LAT_MAX 55.8271
#define RANGE_LAT_MIN 0.8293
// jzA = 6378245.0, 1/f = 298.3
// b = a * (1 - f)
// ee = (a^2 - b^2) / a^2;
#define jzA 6378245.0
#define jzEE 0.00669342162296594323


/// 从GPS坐标转化到高德坐标      WGS-84 -----> GCJ-02
/// 此接口当输入坐标为中国大陆以外时，仍旧返回WGS-84坐标
+ (CLLocationCoordinate2D)WGS84ToGCJ02:(CLLocationCoordinate2D)location {
    return [self gcj02Encrypt:location.latitude bdLon:location.longitude];
}

/// 从高德坐标到GPS坐标              GCJ-02 -----> WGS-84
+ (CLLocationCoordinate2D)GCJ02ToWGS84:(CLLocationCoordinate2D)location {
    return [self gcj02Decrypt:location.latitude gjLon:location.longitude];
}

/// 从高德坐标转化到百度坐标       GCJ-02 -----> BD-09
+ (CLLocationCoordinate2D)GCJ02ToBD09:(CLLocationCoordinate2D)location {
    return  [self bd09Encrypt:location.latitude bdLon:location.longitude];
}

/// 从百度坐标到高德坐标                BD-09 -----> GCJ-02
+ (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)location {
    return [self bd09Decrypt:location.latitude bdLon:location.longitude];
}

/// 从百度坐标到GPS坐标             BD-09 -----> GCJ-02 -----> WGS-84
+ (CLLocationCoordinate2D)BD09ToWGS84:(CLLocationCoordinate2D)location {
    CLLocationCoordinate2D gcj02 = [self BD09ToGCJ02:location];
    return [self gcj02Decrypt:gcj02.latitude gjLon:gcj02.longitude];
}

/// 从GPS坐标到百度坐标             WGS-84 -----> GCJ-02 -----> BD-09
+ (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)location {
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:location.latitude bdLon:location.longitude];
    return [self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude] ;
}

// gcj02 加密
+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    // 判断是不是在中国
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double dLon = [self transformLon:(ggLon - 105.0) bdLon:(ggLat - 35.0)];
    double radLat = ggLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - jzEE * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((jzA * (1 - jzEE)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (jzA / sqrtMagic * cos(radLat) * M_PI);
    mgLat = ggLat + dLat;
    mgLon = ggLon + dLon;
    
    resPoint.latitude = mgLat;
    resPoint.longitude = mgLon;
    return resPoint;
}

// gcj02 解密
+ (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon {
    CLLocationCoordinate2D  gPt = [self gcj02Encrypt:gjLat bdLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}

// 判断是不是在中国
+ (BOOL)outOfChina:(double)lat bdLon:(double)lon {
    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
        return true;
    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
        return true;
    return false;
}

+ (double)transformLat:(double)x bdLon:(double)y {
    double ret = LAT_OFFSET_0(x, y);
    ret += LAT_OFFSET_1;
    ret += LAT_OFFSET_2;
    ret += LAT_OFFSET_3;
    return ret;
}

+ (double)transformLon:(double)x bdLon:(double)y {
    double ret = LON_OFFSET_0(x, y);
    ret += LON_OFFSET_1;
    ret += LON_OFFSET_2;
    ret += LON_OFFSET_3;
    return ret;
}

///--------------------------------------------------------------------------------------------------------------------------------------------
// github 上的方法
// GCJ02--------------->BD09
// bd09 加密
+(CLLocationCoordinate2D)bd09Encrypt:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D bdPt;
    double x = ggLon;
    double y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.latitude = z * sin(theta) + 0.006;
    bdPt.longitude = z * cos(theta) + 0.0065;
    return bdPt;
}

// BD09-------------->GCJ02
+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon {
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065;
    double y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.latitude = z * sin(theta);
    gcjPt.longitude = z * cos(theta);

    return gcjPt;
}
///--------------------------------------------------------------------------------------------------------------------------------------------
// 网上搜索的方法，两个方法有区别，不知道哪个更精确
// GCJ02--------------->BD09
+(CLLocationCoordinate2D)bd09Encrypt_02:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D bdPt;
    double x = ggLon;
    double y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) + 0.000003 * cos(x * xPi);
    bdPt.latitude = z * sin(theta) + 0.006;
    bdPt.longitude = z * cos(theta) + 0.0065;

    return bdPt;
}
// BD09-------------->GCJ02
+ (CLLocationCoordinate2D)bd09Decrypt_02:(double)bdLat bdLon:(double)bdLon {
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065;
    double y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * xPi);
    double theta = atan2(y, x) - 0.000003 * cos(x * xPi);
    gcjPt.latitude = z * sin(theta);
    gcjPt.longitude = z * cos(theta);

    return gcjPt;
}
///--------------------------------------------------------------------------------------------------------------------------------------------


@end


/**
 国内涉及到的地图坐标系的转换: https://blog.csdn.net/wei_zhenwei/article/details/80284287
 一.相关的坐标系
 1）GPS以及iOS系统定位获得的坐标是地理坐标系WGS1984；
 2）Web地图一般用的坐标细是投影坐标系WGS 1984 Web Mercator；
 3）国内出于相关法律法规要求，对国内所有GPS设备及地图数据都进行了加密偏移处理，代号GCJ-02，这样GPS定位获得的坐标与地图上的位置刚好对应上；
 4）特殊的是百度地图在这基础上又进行一次偏移，通称Bd-09;
 所以以在处理系统定位坐标及相关地图SDK坐标时需要转换处理下，根据网络资源，目前有一些公开的转换算法。

 二.iOS地图开发
 1.坐标的转换逻辑
 1）<CoreLocation/CoreLocation.h>中提供的CLLocationManager类获取的坐标是WGS1984坐标，这种坐标显示在原生地图
 (国内iOS原生地图也是用的高德)、谷歌地图或高德地图需要进行WGS1984转GCJ-02计算，苹果地图及谷歌地图用的都是高德地图的数据，所以这三种情况坐标处理方法一样，即将WGS1984坐标转换成偏移后的GCJ-02才可以在地图上正确显示位置。

 2）在高德地图中获取的坐标是已经转换成GCJ-02的坐标，这时候的坐标无需转换可以直接显示到地图上的正确位置。

 注意点：若此时要对获取的坐标使用CLGeocoder类提供的方法- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler转码成中文地理位置，就得先将GCJ-02的坐标转换成WGS1984坐标，然后再进行中文地址转码，因为CLGeocoder也是CoreLocation中的类，同样使用的是WGS1984坐标。

 3）同理，百度地图显示需要先将坐标转换为Bd-09坐标。
 */
