////
////  .m
////  ShuangFengYun
////
////  Created by Xcode on 17/1/18.
////  Copyright © 2017年 Link-Start. All rights reserved.
////
//
//#import "BaiDuMapTools.h"
//
//
//
//@interface BaiDuMapTools ()
//{
//    BMKMapManager *_mapManager;
//}
//
//
//
//
//@end
//
//@implementation BaiDuMapTools
//
//
/////设置frame
//- (void)initWithFrame:(CGRect)frame parentview:(UIView *)parentview {
//    //基础地图
//    self.baidu_mapView = [[BMKMapView alloc] initWithFrame:frame];
//    self.baidu_mapView.mapType = BMKMapTypeStandard;//地图类型,标准地图
//    [parentview addSubview:self.baidu_mapView];
//    // 设置地图级别
//    [self.baidu_mapView setZoomLevel:16];//(地图显示比例)
//    //设定是否总让选中的annotaion置于最前面
//    self.baidu_mapView.isSelectedAnnotationViewFront = YES;
//    self.baidu_mapView.showsUserLocation = YES;//显示定位图层(即我的位置的小圆点）
//}
//
//#pragma mark - 开始定位 2
/////开始定位 (要在调用此方法之后再设置代理)
//- (void)baidu_startLocation { //一定要写在ViewDidLoad里面
//
//    //初始化BMKLocationService
//    self.baidu_locationService = [[BMKLocationService alloc] init];
//    //设定定位精度，越是精确，程序回调就越慢
//    self.baidu_locationService.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    self.baidu_locationService.distanceFilter = 500.0;
//
//
//
//    ////设置是否自动停止位置更新
//    self.baidu_locationService.pausesLocationUpdatesAutomatically = NO;
//    NSLog(@"进入普通定位态");
//    //启动LocationService
//    [self.baidu_locationService startUserLocationService];
//
//    self.baidu_mapView.userTrackingMode = BMKUserTrackingModeNone;//设置定位的状态
//
//
//    self.baidu_geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
//    self.baidu_geoCodeSearch.delegate = self;
//
//}
/////停止定位
//- (void)baidu_stopLocation {
//    [self.baidu_locationService stopUserLocationService];
//}
/////设置精度圈 是否显示
//- (void)baidu_showPersonalLocationIcon {
//    BMKLocationViewDisplayParam *displayParam = [[BMKLocationViewDisplayParam alloc] init];
//    displayParam.isRotateAngleValid = NO;//跟随态旋转角度是否生效，默认YES
//    displayParam.isAccuracyCircleShow = NO;//精度圈是否显示，默认YES
//    displayParam.locationViewOffsetX = 0;//定位偏移量(经度)
//    displayParam.locationViewOffsetY = 0;//定位偏移量（纬度）
//    [self.baidu_mapView updateLocationViewWithParam:displayParam];
//}
/////显示定位图层
//- (void)baidu_showsUserLocation {
//    self.baidu_mapView.showsUserLocation = YES;//显示定位图层
//}
//
//
//#pragma mark - 开始定位 1
/////设置代理(要在调用开始定位方法之后再设置代理)
//- (void)setDelegate {
//    [self.baidu_mapView viewWillAppear];
//    self.baidu_mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _baidu_locationService.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _baidu_geoCodeSearch.delegate = self;
//}
/////制空代理
//- (void)setDelegateForNil {
//    [self.baidu_mapView viewWillDisappear];
//    self.baidu_mapView.delegate = nil; // 此处记得不用的时候需要置nil，否则影响内存的释放
//    _baidu_locationService.delegate = nil;
//    self.baidu_geoCodeSearch.delegate = nil;
//}
//
//
//#pragma mark - 代理方法
//#pragma mark - 实现 定位 相关delegate 处理位置信息更新
/////在地图View将要启动定位时，会调用此函数
//- (void)willStartLocatingUser {
//    NSLog(@"开始定位!!!");
//}
//
//#pragma mark - 开始定位 7
///**
// *用户方向更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
//- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation {
//    [self.baidu_mapView updateLocationData:userLocation];
////    NSLog(@"方向：heading is %@",userLocation.heading);
//}
//
//#pragma mark - 开始定位 3、5
///**
// *用户位置更新后，会调用此函数
// *@param userLocation 新的用户位置
// */
//- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation {
//        NSLog(@"用户位置更新后， didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
//
//
//    [self.baidu_mapView updateLocationData:userLocation];//更新地图上的位置
//    self.baidu_mapView.centerCoordinate = userLocation.location.coordinate; //更新当前位置到地图中间
//
//    //longitude:经度 latitude：维度
//    if (self.BaiDu_currentLatitudeLongitude) {
//        self.BaiDu_currentLatitudeLongitude(userLocation.location.coordinate.longitude, userLocation.location.coordinate.latitude);
//
////        [self.baidu_locationService stopUserLocationService];//停止定位
//    }
//
////    /*******大头针**********/
////    BMKPointAnnotation *annotation = [[BMKPointAnnotation alloc] init];
////    annotation.coordinate = userLocation.location.coordinate;
////    [self.baidu_mapView addAnnotation:annotation];
////
//
////    //地理反编码
////    //发起反向地理编码检索
////    CLLocationCoordinate2D coordinate;
////    coordinate.latitude = userLocation.location.coordinate.latitude;
////    coordinate.longitude = userLocation.location.coordinate.longitude;
////
////    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];
////    reverseGeocodeSearchOption.reverseGeoPoint = coordinate;
////
////    BOOL flag = [self.baidu_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];
////
////    if (flag) {
////        NSLog(@"反geo检索发送成功");
//////        [self.baidu_locationService stopUserLocationService];
////    } else {
////        NSLog(@"反geo检索发送失败");
////    }
//
//    if ((userLocation.location.coordinate.latitude != 0 || userLocation.location.coordinate.longitude != 0)) {
//        //发送反编码请求
//        //[self sendBMKReverseGeoCodeOptionRequest];
//
//        NSString *latitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude];
//        NSString *longitude = [NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude];
//        [self reverseGeoCodeWithLatitude:latitude withLongitude:longitude];
//
//    } else {
//        NSLog(@"位置为空");
//    }
//
//
//}
//
/////大头针
//- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation {
//    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
//        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;// 设置颜色
//        newAnnotationView.animatesDrop = YES;// 设置该标注点动画显示 从天上掉下效果
//        newAnnotationView.draggable = NO;// 设置可拖拽
//        return newAnnotationView;
//    }
//    return nil;
//}
//
//#pragma mark - 反地理编码代理方法
//#pragma mark ----反向地理编码
//- (void)reverseGeoCodeWithLatitude:(NSString *)latitude withLongitude:(NSString *)longitude {
//
//    //发起反向地理编码检索
//    CLLocationCoordinate2D coor;
//    coor.latitude = [latitude doubleValue];
//    coor.longitude = [longitude doubleValue];
//
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
//    reverseGeocodeSearchOption.reverseGeoPoint = coor;
//    BOOL flag = [self.baidu_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];;
//    if (flag) {
//        NSLog(@"反地理编码成功");//可注释
//    } else {
//        NSLog(@"反地理编码失败");//可注释
//    }
//}
//
////点击定位按钮开始定位
//- (void)sendBMKReverseGeoCodeOptionRequest {//发送反编码请求的
//
//    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){0, 0};//初始化
//    if (self.baidu_locationService.userLocation.location.coordinate.longitude != 0
//        && self.baidu_locationService.userLocation.location.coordinate.latitude != 0) {
//        //如果还没有给pt赋值,那就将当前的经纬度赋值给pt
//        pt = (CLLocationCoordinate2D){
//            self.baidu_locationService.userLocation.location.coordinate.latitude,
//            self.baidu_locationService.userLocation.location.coordinate.longitude};
//    }
//
//    BMKReverseGeoCodeOption *reverseGeocodeSearchOption = [[BMKReverseGeoCodeOption alloc]init];//初始化反编码请求
//    reverseGeocodeSearchOption.reverseGeoPoint = pt;//设置反编码的点为pt
//    BOOL flag = [self.baidu_geoCodeSearch reverseGeoCode:reverseGeocodeSearchOption];//发送反编码请求.并返回是否成功
//    if(flag) {
//        NSLog(@"反geo检索发送成功");
//    } else {
//        NSLog(@"反geo检索发送失败");
//    }
//}
//
//#pragma mark - 开始定位 4、6
///**
// *返回反地理编码搜索结果
// *@param searcher 搜索对象
// *@param result 搜索结果
// *@param error 错误号，@see BMKSearchErrorCode
// */
//- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error {
//    if (self.BaiDu_currentLocation) {
//        self.BaiDu_currentLocation(result, result.addressDetail, result.address);
////        [self.baidu_locationService stopUserLocationService];
//    }
//    NSLog(@"地址信息：address:%@----%@",result.addressDetail,result.address);
//    //addressDetail:     层次化地址信息
//    //address:    地址名称
//    //businessCircle:  商圈名称
//    //location:  地址坐标
//    //poiList:   地址周边POI信息，成员类型为BMKPoiInfo
//
//    NSLog(@"返回反地理编码搜索结果错误：%d", error);
//    if (error == BMK_OPEN_PERMISSION_UNFINISHED) {///还未完成鉴权，请在鉴权通过后重试
//
//        _mapManager = [[BMKMapManager alloc] init];
//        // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
//        BOOL ret = [_mapManager start:BaiduAppKey  generalDelegate:nil];
//        if (!ret) {
//            NSLog(@"百度地图启动失败");
//        } else {
//            NSLog(@"百度地图启动成功");
//        }
//    }
//}
//
//
/////定位失败后，会调用此函数
//- (void)didFailToLocateUserWithError:(NSError *)error {
//    NSLog(@"定位失败!!%@", error);
//    if (self.BaiDu_locationFail) {
//        self.BaiDu_locationFail(error);
//    }
//}
//
//#pragma mark - 懒加载
////编码服务的初始化(就是获取经纬度,或者获取地理位置服务)
//- (BMKGeoCodeSearch *)baidu_geoCodeSearch {
//    if (!_baidu_geoCodeSearch) {
//        self.baidu_geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
//        self.baidu_geoCodeSearch.delegate = self;
//    }
//    return _baidu_geoCodeSearch;
//}
//
//- (void)dealloc {
//    if (_baidu_mapView) {
//        _baidu_mapView.delegate = nil;
//    }
//    if (_baidu_locationService) {
//        _baidu_locationService.delegate = nil;
//    }
//}
//
//@end
