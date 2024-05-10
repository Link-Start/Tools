//
//  LSMKMapViewZoomLevel.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/3/20.
//  Copyright © 2024 Link-Start. All rights reserved.
//
//  计算苹果自带原生地图MKMapView的zoomLevel(地图缩放等级)

#import <MapKit/MapKit.h>
#import <MapKit/MKMapView.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSMKMapViewZoomLevel : MKMapView

/// 缩放级别 【3 ~ 20】
@property (nonatomic, assign) NSInteger zoomLevel;
/// 缩放级别 【3 ~ 20】
@property (nonatomic, assign) double zoomLevel_d;

/// 缩放级别【3 ~ 20】
- (void)setZoomLevel:(NSInteger)zoomLevel animated:(BOOL)animated;
/// 缩放级别【3 ~ 20】
- (void)setZoomLevel_d:(double)zoomLevel_d animated:(BOOL)animated;


@end

NS_ASSUME_NONNULL_END
