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
//
//
//
//

#import <Foundation/Foundation.h>
#import <AMapLocationKit/AMapLocationKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface GaoDeMapLocationService : NSObject

@property (nonatomic ,strong) CLLocation *currentLocation;


+ (GaoDeMapLocationService *)shareInstanse;
- (void)startLocationServiceWithComplete:(void(^)(BOOL isSuccess))complete;
/// 定位, 没有定位权限就弹窗提示
- (void)startLocationServiceNoPermissionPopupTipsWithComplete:(void(^)(BOOL isSuccess))complete;
- (NSNumber *)getCurrentLocationLatitude;
- (NSNumber *)getCurrentLocationLongtitude;


@end

NS_ASSUME_NONNULL_END
