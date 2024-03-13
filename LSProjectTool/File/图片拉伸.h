//
//  图片拉伸.h
//  LSProjectTool
//
//  Created by Xcode on 16/10/25.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef _____h
#define _____h

// https://www.jianshu.com/p/e8c38c44b15b
// UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
// UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片

// - (UIImage *)resizableImageWithCapInsets:(UIEdgeInsets)capInsets resizingMode:(UIImageResizingMode)resizingMode

//该方法返回的是UIImage类型的对象,即返回经该方法拉伸后的图像
//传入的第一个参数capInsets是UIEdgeInsets类型的数据,即原始图像要被保护的区域
//这个参数是一个结构体,定义如下
//typedef struct { CGFloat top, left , bottom, right ; } UIEdgeInsets;
//该参数的意思是被保护的区域到原始图像外轮廓的上部,左部,底部,右部的直线距离
//传入的第二个参数resizingMode是UIImageResizingMode类似的数据,即图像拉伸时选用的拉伸模式,
//这个参数是一个枚举类型,有以下两种方式
//UIImageResizingModeTile,     平铺
//UIImageResizingModeStretch,  拉伸


// 如果采用UIImageResizingModeStretch（拉伸模式），那么拉伸区域保存一个像素长或者宽最好，这样性能最优。至于平铺模式，则没有说明。


//_centerBgImgV = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"message_customIM_cell_center_gradientBgView"] resizableImageWithCapInsets:UIEdgeInsetsFromString(@"{20,10,20,10}") resizingMode:UIImageResizingModeStretch]];









//------------------------------------------------------------------------------------------------------------------/


UIImage *image = [UIImage imageNamed:@"error"];

// 左端盖宽度
NSInteger leftCapWidth = image.size.width * 0.5f;
// 顶端盖高度
NSInteger topCapHeight = image.size.height * 0.5f;

//这个方法只会拉伸图片中间 的区域，并不会影响到边缘和角落 iOS 5.0之前 这个方法只能拉伸1x1的区域
image = [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
//iOS 5.0
//    CGFloat top = 25; // 顶端盖高度
//    CGFloat bottom = 25 ; // 底端盖高度
//    CGFloat left = 10; // 左端盖宽度
//    CGFloat right = 10; // 右端盖宽度
//    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
//    // 伸缩后重新赋值
//    image = [image resizableImageWithCapInsets:insets];


//iOS 6.0
CGFloat top = 25; // 顶端盖高度
CGFloat bottom = 25 ; // 底端盖高度
CGFloat left = 10; // 左端盖宽度
CGFloat right = 10; // 右端盖宽度
UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);

//    UIImageResizingMode参数，用来指定拉伸的模式：
//    UIImageResizingModeStretch：拉伸模式，通过拉伸UIEdgeInsets指定的矩形区域来填充图片
//    UIImageResizingModeTile：平铺模式，通过重复显示UIEdgeInsets指定的矩形区域来填充图片
// 指定为拉伸模式，伸缩后重新赋值
image = [image resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];


#endif /* _____h */


// 将像素point由point所在视图转换到目标视图view中，返回在目标视图view中的像素值
- (CGPoint)convertPoint:(CGPoint)point toView:(UIView *)view;
// 将像素point从view中转换到当前视图中，返回在当前视图中的像素值
- (CGPoint)convertPoint:(CGPoint)point fromView:(UIView *)view;

// 将rect由rect所在视图转换到目标视图view中，返回在目标视图view中的rect
- (CGRect)convertRect:(CGRect)rect toView:(UIView *)view;
// 将rect从view中转换到当前视图中，返回在当前视图中的rect
- (CGRect)convertRect:(CGRect)rect fromView:(UIView *)view;

或当已知btn时：
CGRect rc = [btn.superview convertRect:btn.frame toView:self.view];
或
CGRect rc = [self.view convertRect:btn.frame fromView:btn.superview];




iOS裁剪图片方式
//返回裁剪区域图片

-(UIImage*)clicpViewWithRect:(CGRect)aRect { //arect 想要截图的区域
    CGFloat scale = [UIScreen mainScreen].scale;
    aRect.origin.x*= scale;
    aRect.origin.y*= scale;
    aRect.size.width*= scale;
    aRect.size.height*= scale;
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.width, self.view.height), YES, scale);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRefimageRef = viewImage.CGImage;
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, aRect);
    UIImage*sendImage = [[UIImagealloc]initWithCGImage:imageRefRect];
    returnsendImage;
}

第一种方法

// CIImage实现

    CIImage*ciimage = [CIImageimageWithCGImage:newImage.CGImage];
    ciimage = [ciimageimageByCroppingToRect:cropRect];
    CIContext*context = [CIContextcontext];
    CGImageRefimageRef = [contextcreateCGImage:ciimagefromRect:cropRect];
    newImage = [UIImageimageWithCGImage:imageRef];
第二种方法

// quartz 2d 实现
    UIGraphicsBeginImageContext(cropRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGImageRefimageRef = newImage.CGImage;
    CGImageRefsubImageRef =CGImageCreateWithImageInRect(imageRef, cropRect);
    CGContextDrawImage(ctx, cropRect, subImageRef);
    newImage = [UIImageimageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
第三种方法

// CGImage
    newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([newImage CGImage], cropRect)];



按大小裁剪为指定的尺寸并解决图片裁剪之后显示不正确的问题
+ (UIImage *)cutCenterImageSize:(CGSize)size iMg:(UIImage *)img {
    CGFloat scale = [UIScreen mainScreen].scale;
    size.width = size.width*scale;
    size.height = size.height *scale;
    CGSize imageSize = img.size;
    CGRect rect;
    //根据图片的大小计算出图片中间矩形区域的位置与大小
    if (imageSize.width > imageSize.height) {
        float leftMargin = (imageSize.width - imageSize.height) *0.5;
        rect = CGRectMake(leftMargin,0, imageSize.height, imageSize.height);
    }else{
        float topMargin = (imageSize.height - imageSize.width) *0.5;
        rect = CGRectMake(0, topMargin, imageSize.width, imageSize.width);
    }
//记录旋转方向
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (img.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width, img.size.height);
            transform = CGAffineTransformRotate(transform,M_PI);
            break;
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, img.size.width,0);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            break;
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform,0, img.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    CGImageRef imageRef = img.CGImage;
    //截取中间区域矩形图片
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *tmp = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    UIGraphicsBeginImageContext(size);
    CGRect rectDraw =CGRectMake(0,0, size.width, size.height);
    [tmp drawInRect:rectDraw];
    // 从当前context中创建一个改变大小后的图片
    tmp = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 旋转为正确的方向
    CGContextRef ctx = CGBitmapContextCreate(NULL, tmp.size.width, tmp.size.height,
                                                 CGImageGetBitsPerComponent(tmp.CGImage),0,
                                                 CGImageGetColorSpace(tmp.CGImage),
                                                 CGImageGetBitmapInfo(tmp.CGImage));
    CGContextConcatCTM(ctx, transform);
    return tmp;
}





