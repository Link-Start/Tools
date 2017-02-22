//
//  LSCustomCamera.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/3.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LSCustomCamera : NSObject
///父视图弱引用
@property (nonatomic, weak) UIView *parentView;

///单利
+ (LSCustomCamera *)shareCustomCamera;

///初始化方法
- (instancetype)takePhotoComplete:(UIView *)view takePhotoFrame:(CGRect)takePhotoFrame completion:(void (^)(UIImage *image))completion;

///拍照方法
- (void)takePhotoBtnAction;

///切换前后摄像头
- (void)switchCamera;
/// 设备开始取景
- (void)startRun;
///清空绘制图层
- (void)clearDrawLayer;

@end
