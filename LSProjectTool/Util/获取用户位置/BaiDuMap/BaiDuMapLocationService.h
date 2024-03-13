//
//  BaiDuMapLocationService.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2022/3/24.
//  Copyright © 2022 Link-Start. All rights reserved.
//  百度地图，获取定位信息

#import <Foundation/Foundation.h>
#import <BMKLocationKit/BMKLocationManager.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaiDuMapLocationService : NSObject
/// 当前的 定位数据
@property (nonatomic, strong) BMKLocation *currentLocation;

+ (BaiDuMapLocationService *)shareInstance;
/// 开始定位
- (void)startLocationServiceWithComplete:(void(^)(BOOL isSuccess))complete;
/// 开始定位, 没有定位权限就弹窗提示
- (void)startLocationServiceNoPermissionPopupTipsWithComplete:(void(^)(BOOL isSuccess))complete;

- (NSNumber *)getCurrentLocationLatitude;
- (NSNumber *)getCurrentLocationLongtitude;

@end

NS_ASSUME_NONNULL_END
