//
//  GaoDeMapLocationService.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/10/19.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//  高德地图，获取定位信息
//
//  高德地图开放平台隐私权政策：https://lbs.amap.com/pages/privacy/
//  开发指南:https://lbs.amap.com/api/ios-sdk/guide/create-project/manual-configuration
//
//
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>



NS_ASSUME_NONNULL_BEGIN

@interface GaoDeMapLocationService : NSObject

@property (nonatomic ,strong) CLLocation *currentLocation;
/// 逆地理信息
@property (nonatomic, strong) AMapLocationReGeocode *regeocode;

+ (GaoDeMapLocationService *)shareInstanse;
/// 开始定位
- (void)startLocationServiceWithComplete:(void(^)(BOOL isSuccess))complete;
/// 开始定位, 没有定位权限就弹窗提示
- (void)startLocationServiceNoPermissionPopupTipsWithComplete:(void(^)(BOOL isSuccess))complete;
- (NSNumber *)getCurrentLocationLatitude;
- (NSNumber *)getCurrentLocationLongtitude;


@end

NS_ASSUME_NONNULL_END

/**
 
 https://www.cnblogs.com/fei-sky-001-o/articles/4953075.html：高德地图和iOS自带的地图--》MAMApkit与MKMapKit
 https://news.68idc.cn/buildlang/ask/20150314273096.html：地图（定位、POI、地理编码……）
 https://blog.csdn.net/SuYuMingXiangGuan/article/details/53666805：地图相关 MapKit框架
 https://www.jianshu.com/p/78df81817a05：MKMapKit学习总结（一）简单使用（地图点击）
 https://www.jianshu.com/p/5a960436f44e：MKMapKit学习总结（二）增加地图缩放功能
 https://juejin.cn/post/6844903839712149518：计算MKMapView的zoomLevel(地图缩放等级)
 
 高德地图【MAMApkit】和iOS自带的地图【MKMapKit】
 
1. 苹果自带的原生地图SDK：MKMapKit，但是它在中国使用时，内部还是使用的是高德地图。（高德为苹果在中国的地图合作方）
  -- LBS: 基于位置的服务(Location Based Service)
  -- 定位方式：1.GPS定位      2.基站定位      3.WIFI定位
    -- 基站：省电、定位不精准（大概位置）
    -- 和基站差不多，比基站更费电、定位不精准（大概位置）
    -- A-GPS：苹果改良了直接使用GPS，先使用基站和WIFI获得大概位置，然后苹果自动推荐当前区域的离你位置最近的GPS卫星，这样就不用再搜索卫星了，直接就可以使用了。费电、定位精准。
  -- 使用苹果自带的地图MKMapKit，需要导入框架：MapKit.frameworks、CoreLocation.framework
    -- MapKit:地图框架，显示地图
      -- 导入头文件 #import <MapKit/MapKit.h>
      -- MapKit框架中所有数据类型的前缀都是MK
      -- MapKit有一个比较重要的UI控件 ：MKMapView，专门用于地图显示
    -- CoreLocation:定位框架，没有地图时也可以使用定位.

  -- !!!!!!!! 苹果自带的mkmapkit可以叠加很多的地图资源，包括谷歌的等等。!!!!!!!![https://www.jianshu.com/p/78df81817a05]
    
 
2. 高德地图官方SDK：MAMApkit
    -- !!!!!!!! iOS的高德地图的sdk，不支持图层叠加谷歌的资源（安卓就可以，可以哭一会儿）!!!!!!!![https://www.jianshu.com/p/78df81817a05]
 
 
 
 
 
 
 
 
 
 
 
 
 */
