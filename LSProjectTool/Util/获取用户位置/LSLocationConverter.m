//
//  LSLocationConverter.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/20.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "LSLocationConverter.h"
#import <CoreLocation/CoreLocation.h>
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

static const double x_pi = M_PI  * 3000.0 / 180.0;


@implementation LSLocationConverter

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

//判断是不是在中国
+ (BOOL)outOfChina:(double)lat bdLon:(double)lon {
    if (lon < RANGE_LON_MIN || lon > RANGE_LON_MAX)
        return true;
    if (lat < RANGE_LAT_MIN || lat > RANGE_LAT_MAX)
        return true;
    return false;
}

// WGS-84 -----> GCJ-02
+ (CLLocationCoordinate2D)gcj02Encrypt:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D resPoint;
    double mgLat;
    double mgLon;
    if ([self outOfChina:ggLat bdLon:ggLon]) {
        resPoint.latitude = ggLat;
        resPoint.longitude = ggLon;
        return resPoint;
    }
    double dLat = [self transformLat:(ggLon - 105.0)bdLon:(ggLat - 35.0)];
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

//GCJ-02 -----> WGS-84
+ (CLLocationCoordinate2D)gcj02Decrypt:(double)gjLat gjLon:(double)gjLon {
    CLLocationCoordinate2D  gPt = [self gcj02Encrypt:gjLat bdLon:gjLon];
    double dLon = gPt.longitude - gjLon;
    double dLat = gPt.latitude - gjLat;
    CLLocationCoordinate2D pt;
    pt.latitude = gjLat - dLat;
    pt.longitude = gjLon - dLon;
    return pt;
}

///--------------------------------------------------------------------------------------------------------------------------------------------
// github 上的方法
// GCJ02--------------->BD09
+(CLLocationCoordinate2D)bd09Encrypt:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D bdPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) + 0.000003 * cos(x * M_PI);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}
// BD-09 -----> GCJ-02
+ (CLLocationCoordinate2D)bd09Decrypt:(double)bdLat bdLon:(double)bdLon {
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065;
    double y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * M_PI);
    double theta = atan2(y, x) - 0.000003 * cos(x * M_PI);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}
///--------------------------------------------------------------------------------------------------------------------------------------------
// 网上搜索的方法，两个方法有区别，不知道哪个更精确
// GCJ02--------------->BD09
+(CLLocationCoordinate2D)bd09Encrypt_02:(double)ggLat bdLon:(double)ggLon {
    CLLocationCoordinate2D bdPt;
    double x = ggLon, y = ggLat;
    double z = sqrt(x * x + y * y) + 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) + 0.000003 * cos(x * x_pi);
    bdPt.longitude = z * cos(theta) + 0.0065;
    bdPt.latitude = z * sin(theta) + 0.006;
    return bdPt;
}
// BD-09 -----> GCJ-02
+ (CLLocationCoordinate2D)bd09Decrypt_02:(double)bdLat bdLon:(double)bdLon {
    CLLocationCoordinate2D gcjPt;
    double x = bdLon - 0.0065;
    double y = bdLat - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta = atan2(y, x) - 0.000003 * cos(x * x_pi);
    gcjPt.longitude = z * cos(theta);
    gcjPt.latitude = z * sin(theta);
    return gcjPt;
}
///--------------------------------------------------------------------------------------------------------------------------------------------


+ (CLLocationCoordinate2D)WGS84ToGCJ02:(CLLocationCoordinate2D)location {
    return [self gcj02Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)GCJ02ToWGS84:(CLLocationCoordinate2D)location {
    return [self gcj02Decrypt:location.latitude gjLon:location.longitude];
}

+ (CLLocationCoordinate2D)WGS84ToBD09:(CLLocationCoordinate2D)location {
    CLLocationCoordinate2D gcj02Pt = [self gcj02Encrypt:location.latitude bdLon:location.longitude];
    return [self bd09Encrypt:gcj02Pt.latitude bdLon:gcj02Pt.longitude] ;
}

+ (CLLocationCoordinate2D)GCJ02ToBD09:(CLLocationCoordinate2D)location {
    return  [self bd09Encrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)BD09ToGCJ02:(CLLocationCoordinate2D)location {
    return [self bd09Decrypt:location.latitude bdLon:location.longitude];
}

+ (CLLocationCoordinate2D)BD09ToWGS84:(CLLocationCoordinate2D)location {
    CLLocationCoordinate2D gcj02 = [self BD09ToGCJ02:location];
    return [self gcj02Decrypt:gcj02.latitude gjLon:gcj02.longitude];
} 

@end


/**
 国内涉及到的地图坐标系的转换: https://blog.csdn.net/wei_zhenwei/article/details/80284287
 一.相关的坐标系
 1）GPS以及iOS系统定位获得的坐标是地理坐标系WGS1984；
 2）Web地图一般用的坐标细是投影坐标系WGS 1984 Web Mercator；
 3）国内出于相关法律法规要求，对国内所有GPS设备及地图数据都进行了加密偏移处理，代号GCJ-02，这样GPS定位获得的坐标与地图上的位置刚好对应上；
 4）特殊的是百度地图在这基础上又进行一次偏移，通称Bd-09;
 所以在处理系统定位坐标及相关地图SDK坐标时需要转换处理下，根据网络资源，目前有一些公开的转换算法。

 二.iOS地图开发
 1.坐标的转换逻辑
 1）<CoreLocation/CoreLocation.h>中提供的CLLocationManager类获取的坐标是WGS1984坐标，这种坐标显示在原生地图
 (国内iOS原生地图也是用的高德)、谷歌地图或高德地图需要进行WGS1984转GCJ-02计算，苹果地图及谷歌地图用的都是高德地图的数据，所以这三种情况坐标处理方法一样，即将WGS1984坐标转换成偏移后的GCJ-02才可以在地图上正确显示位置。

 2）在高德地图中获取的坐标是已经转换成GCJ-02的坐标，这时候的坐标无需转换可以直接显示到地图上的正确位置。

 注意点：若此时要对获取的坐标使用CLGeocoder类提供的方法- (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(CLGeocodeCompletionHandler)completionHandler转码成中文地理位置，就得先将GCJ-02的坐标转换成WGS1984坐标，然后再进行中文地址转码，因为CLGeocoder也是CoreLocation中的类，同样使用的是WGS1984坐标。

 3）同理，百度地图显示需要先将坐标转换为Bd-09坐标。
 
 
 
 
 
 // 一些公司（比如高德，百度，腾讯）是先经度，再纬度，即Point(lng, lat)。但谷歌坐标的顺序恰好相反，是(lat, lng)。
 
 
 */
