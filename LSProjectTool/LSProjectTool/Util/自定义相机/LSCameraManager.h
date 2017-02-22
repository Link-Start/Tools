//
//  LSCameraManager.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/8.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface LSCameraManager : NSObject

///单利
+ (LSCameraManager *)shareCameraManager;

///初始化方法
- (instancetype)takePhotoComplete:(UIView *)view takePhotoFrame:(CGRect)takePhotoFrame completion:(void (^)(UIImage *image))completion;

//拍照方法
- (void)takePhotoBtnAction;

///清空绘制图层
- (void)clearDrawLayer;

@end
