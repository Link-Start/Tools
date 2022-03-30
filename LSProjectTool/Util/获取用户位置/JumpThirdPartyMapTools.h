//
//  JumpThirdPartyMapTools.h
//  NiuCheCheUserSide
//
//  Created by macbook v5 on 2018/7/17.
//  Copyright © 2018年 LinkStart. All rights reserved.
//  跳转到第三方地图

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol JumpThirdPartyMapToolsDelegate<NSObject>

- (void)presentVC:(UIAlertController *)alert;

@end

@interface JumpThirdPartyMapTools : NSObject

@property (nonatomic, weak) id<JumpThirdPartyMapToolsDelegate> delegate;


-(void)navThirdMapWithLocation:(CLLocationCoordinate2D)endLocation endAddressStr:(NSString *)endAddress;

@end
