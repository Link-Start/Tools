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



/// 生成指定大小的黑白二维码
- (UIImage *)createQRCodeImageWithString:(NSString *)string size:(CGSize)size;
/// 彩色二维码,为二维码改变颜色[设置CIFilter的属性，改变其颜色]
- (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor;
///

@end
