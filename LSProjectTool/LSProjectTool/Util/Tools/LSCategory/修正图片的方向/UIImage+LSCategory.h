//
//  UIImage+LSCategory.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/3.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (LSCategory)

#pragma mark - //修正图片的方向
/// 修正图片的方向 -- 方法1
- (UIImage *)fixOrientation;
/// 修正图片的方向 -- 方法2
- (UIImage *)normalizedImage;


@end
