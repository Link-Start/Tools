////
////  BaiDuMapTools.h
////  ShuangFengYun
////
////  Created by Xcode on 17/1/18.
////  Copyright © 2017年 Link-Start. All rights reserved.
////  百度地图 API
//
//#import <Foundation/Foundation.h>
///********百度地图*******/
//#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
//#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
//#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
//#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
//#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
//#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件
//#import <BaiduMapAPI_Map/BMKMapView.h>//只引入所需的单个头文件
//
//@interface BaiDuMapTools : NSObject<BMKMapViewDelegate, BMKLocationServiceDelegate, BMKGeoCodeSearchDelegate>
//
/////百度地图
//@property (nonatomic, strong) BMKMapView *baidu_mapView;
/////地理编码主类，用来查询、返回结果信息
//@property (nonatomic, strong) BMKGeoCodeSearch *baidu_geoCodeSearch;
/////定位功能
//@property (nonatomic, strong) BMKLocationService *baidu_locationService;
//
/////当前位置的经纬度 longitude:经度 latitude：维度
//@property (nonatomic, copy) void (^BaiDu_currentLatitudeLongitude)(CLLocationDegrees baidu_longitude, CLLocationDegrees baidu_latitude);
/////当前位置 (result:搜索结果, addressDetail:层次化地址信息, 地址信息)
//@property (nonatomic, copy) void(^BaiDu_currentLocation)(BMKReverseGeoCodeResult *result, BMKAddressComponent *addressDetail,NSString *address);
//
/////定位失败 Code=0说明没有位置信息 Code=1说明是系统授权问题  
//@property (nonatomic, copy) void(^BaiDu_locationFail)(NSError *error);
//
/////设置frame
//- (void)initWithFrame:(CGRect)frame parentview:(UIView *)parentview;
//
/////开始定位(一定要写在ViewDidLoad里面)
//- (void)baidu_startLocation;
/////停止定位
//- (void)baidu_stopLocation;
/////设置精度圈 是否显示
//- (void)baidu_showPersonalLocationIcon;
/////显示定位图层
//- (void)baidu_showsUserLocation;
//
/////设置代理
//- (void)setDelegate;
/////制空代理
//- (void)setDelegateForNil;
//
//
/////点击定位按钮开始定位（发送反编码请求）
//- (void)sendBMKReverseGeoCodeOptionRequest;
//
//
//
//
//@end
