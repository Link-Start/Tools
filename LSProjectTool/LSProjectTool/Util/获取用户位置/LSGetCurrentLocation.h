//
//  LSGetCurrentLocation.h
//  JKL
//
//  Created by Xcode on 16/8/27.
//  Copyright © 2016年 Link-Start. All rights reserved.
//  苹果系统自带的库

#import <Foundation/Foundation.h>

@interface LSGetCurrentLocation : NSObject

@property (nonatomic, copy) void(^getCurrentLocation)(NSString *);

/******** 开始定位 ************/
- (void)startUpdateLocation;
@end
