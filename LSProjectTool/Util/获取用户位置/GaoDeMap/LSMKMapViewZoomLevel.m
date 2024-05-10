//
//  LSMKMapViewZoomLevel.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/3/20.
//  Copyright © 2024 Link-Start. All rights reserved.
//  
//  计算MKMapView的zoomLevel(地图缩放等级)
//  https://www.jianshu.com/p/5a960436f44e
//  https://juejin.cn/post/6844903839712149518

#import "LSMKMapViewZoomLevel.h"




@implementation LSMKMapViewZoomLevel

#pragma mark - NSInteger类型 缩放级别【3 ~ 20】
- (void)setZoomLevel:(NSInteger)zoomLevel {
    [self setZoomLevel:zoomLevel animated:NO];
}
- (NSInteger)zoomLevel {
    // Round函数返回一个数值,该数值是按照指定的小数位进行四舍五入运算的结果
    return round(log2(360 * (((double)self.frame.size.width/256) / self.region.span.longitudeDelta)));
}
- (void)setZoomLevel:(NSInteger)zoomLevel animated:(BOOL)animated {
    /**
     typedef struct {
        CLLocationDegrees latitudeDelta; // 纬度跨度
        CLLocationDegrees longitudeDelta; // 经度跨度
     } MKCoordinateSpan;
     */
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360 / pow(2, (double)zoomLevel) * (double)self.frame.size.width / 256);
    
    /***
     MKCoordinateRegion region ， - 是一个用来表示区域的结构体，定义如下:
     typedef struct {
        CLLocationCoordinate2D center; // 区域的中心点位置
        MKCoordinateSpan span; // 区域的跨度
     } MKCoordinateRegion;
     */
    // setRegion：MKCoordinateRegion
    //   MKCoordinateRegionMake第一个参数：CLLocationCoordinate2D center; // 区域的中心点位置
    //   MKCoordinateRegionMake第二个参数：MKCoordinateSpan span; // 区域的跨度
    [self setRegion:(MKCoordinateRegionMake(self.centerCoordinate, span)) animated:animated];//设置地图显示区域
    
    // 使用 setRegion:animated: ,会更改地图的缩放等级
    // 如不想更改缩放等级 可以用setCenterCoordinate:animated
}

#pragma mark - double类型 缩放级别【3 ~ 20】
- (void)setZoomLevel_d:(double)zoomLevel_d {
    [self setZoomLevel_d:zoomLevel_d animated:NO];
}
- (double)zoomLevel_d {
    return log2(360 * (((double)self.frame.size.width/256.0)/self.region.span.longitudeDelta));
}

- (void)setZoomLevel_d:(double)zoomLevel_d animated:(BOOL)animated {
    // 设置 经纬度跨度
    MKCoordinateSpan span = MKCoordinateSpanMake(0, 360/pow(2, (double)zoomLevel_d)*(double)self.frame.size.width/256.0);
    // 设置地图显示区域，这里会更改地图的缩放等级
    [self setRegion:MKCoordinateRegionMake(self.centerCoordinate, span) animated:YES];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 https://www.jianshu.com/p/a9db4eb84d30
 MKMapKit学习总结（三）替换瓦片地址
 
 资源地址
 首先要搞到资源地址，这在网上可以找到很多。我之前找到了，在这里贴出来，可以直接使用。
 NSString * const mapGoogleStandard = @“http://mt0.google.cn/vt/lyrs=m&hl=zh-CN&gl=cn&x={x}&y={y}&z={z}”;
 NSString * const mapGoogleSatellite = @"http://mt0.google.cn/vt/lyrs=s&hl=zh-CN&gl=cn&x={x}&y={y}&z={z}";
 NSString * const mapGoogleTerrain = @“http://mt0.google.cn/vt/lyrs=p&hl=zh-CN&gl=cn&x={x}&y={y}&z={z}”;
 NSString * const mapOpencyclemap = @"http://b.tile.opencyclemap.org/cycle/{z}/{x}/{y}.png";
 NSString * const mapOpenstreetmap = @"http://tile.openstreetmap.org/{z}/{x}/{y}.png";
 NSString * const mapLandscape = @"http://a.tile.opencyclemap.org/landscape/{z}/{x}/{y}.png";
 NSString * const mapGaodeMap = @“http://wprd02.is.autonavi.com/appmaptile?lang=zh_cn&size=1&style=7&x={x}&y={y}&z={z}&scl=1”;
 基本上这些也就够了，有谷歌的，必应的，高德的等等。这些复制到类名之前就可以了。

 这里就是要给map加一层渲染层，要使用到的方法是：
 * 添加
 - (void)addOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 4_0);
 * 移除
 - (void)removeOverlay:(id <MKOverlay>)overlay NS_AVAILABLE(10_9, 4_0);


 现在把，写好两个方法，配置好，高德的矢量图地址和谷歌的卫星图地址。
 - (MKTileOverlay *)googleTileOverlay
 {
     if (!_googleTileOverlay) {
         _googleTileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:mapGoogleSatellite];
         _googleTileOverlay.canReplaceMapContent = YES;
     }
     return _googleTileOverlay;
 }
 - (MKTileOverlay *)gaodeTileOverlay
 {
     if (!_gaodeTileOverlay) {
         _gaodeTileOverlay = [[MKTileOverlay alloc] initWithURLTemplate:mapGaodeMap];
         _gaodeTileOverlay.canReplaceMapContent = YES;
     }
     return _gaodeTileOverlay;
 }

 ::关键的来了::
 接下来就只是调用一下就可以了😁
 [_mapView addOverlay:self.gaodeTileOverlay];
 
 这里写了一个简单的可以切换的方法，可以写一个开关进行适量图高德和卫星图谷歌进行切换：

 - (void)changeTileOverlay:(BOOL)isStandard
 {
     if (isStandard) {
         [_mapView removeOverlay:self.googleTileOverlay];
         [_mapView addOverlay:self.gaodeTileOverlay];
     }
     else {
         [_mapView removeOverlay:self.gaodeTileOverlay];
         [_mapView addOverlay:self.googleTileOverlay];
     }
 }

 作者：生锈的浪花
 链接：https://www.jianshu.com/p/a9db4eb84d30
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 
 */

@end
