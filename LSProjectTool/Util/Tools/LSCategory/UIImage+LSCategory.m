//
//  UIImage+LSCategory.m
//  LSProjectTool
//
//  Created by Xcode on 16/11/3.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

/*
 iPhone上的情况
 
 作为智能手机的重要组成部分，形形色色的传感器自然必不可少。在iOS的设备中也是包含了这样的方向传感器，它也采用了同样的方式来保存照片的方向信息到EXIF中。但是它默认的照片方向并不是竖着拿手机时的情况，而是横向，即Home键在右侧
 如果竖着拿手机拍摄时，就相当于对手机顺时针旋转了90度，也即上面相机图片中的最后一幅，那么它的Orientation值为6。
 */

#import "UIImage+LSCategory.h"

#import <Accelerate/Accelerate.h> //高斯模糊

@implementation UIImage (LSCategory)

///截取图片方式（性能较好，基本不掉帧）
- (UIImage *)drawRectWithRoundedCorner {
    CGRect rect = CGRectMake(0.f, 0.f, 150.f, 150.f);
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:rect.size.width * 0.5];
    
    UIImage *output;
    if (@available(iOS 17.0, *)) { // iOS17.UIGraphicsBeginImageContext被deprecated了
        UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
        format.opaque = false;
        format.scale = [UIScreen mainScreen].scale;
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:rect.size format:format];
        output = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
            CGContextRef context = rendererContext.CGContext;
            CGContextAddPath(context, bezierPath.CGPath);
            CGContextClip(context);
            [self drawInRect:rect];
            CGContextDrawPath(context, kCGPathFillStroke);
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(rect.size, false, [UIScreen mainScreen].scale);
        CGContextAddPath(UIGraphicsGetCurrentContext(), bezierPath.CGPath);
        CGContextClip(UIGraphicsGetCurrentContext());
        [self drawInRect:rect];
        
        CGContextDrawPath(UIGraphicsGetCurrentContext(), kCGPathFillStroke);
        output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return output;
}

#pragma mark - //修正图片的方向
//修正图片的方向 -- 方法1
- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//修正图片的方向 -- 方法2
//这里是利用了UIImage中的drawInRect方法，它会将图像绘制到画布上，并且已经考虑好了图像的方向，
- (UIImage *)normalizedImage {
    
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    UIImage *normalizedImage;
    if (@available(iOS 17.0, *)) { // iOS17.UIGraphicsBeginImageContext被deprecated了
        UIGraphicsImageRendererFormat *format = [[UIGraphicsImageRendererFormat alloc] init];
        format.opaque = NO;
        format.scale = self.scale;
        UIGraphicsImageRenderer *renderer = [[UIGraphicsImageRenderer alloc] initWithSize:self.size format:format];
        normalizedImage = [renderer imageWithActions:^(UIGraphicsImageRendererContext * _Nonnull rendererContext) {
//            CGContextRef context = rendererContext.CGContext;
            [self drawInRect:(CGRect){0, 0, self.size}];
        }];
    } else {
        UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
        [self drawInRect:(CGRect){0, 0, self.size}];
        normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return normalizedImage;
}

#pragma mark - 二维码
#pragma mark - 1.生成指定大小的黑白二维码
/// 生成指定大小的黑白二维码
/// 1.创建CIFilter对象，设置相关属性
/// 2.根据CIFilter对象,生成CIImage
/// 3.放大并绘制二维码
/// 4.翻转图片
- (UIImage *)createQRCodeImageWithString:(NSString *)string size:(CGSize)size {
    
//这里简单介绍下CIFilter用来表示CoreImage提供的各种滤镜，\
    滤镜使用键-值来设置输入值，这些值设置好之后，CIFilter就可以用来生成新的CIImage输出图像。\
    这里的输出的图像不会进行实际的图像渲染。(系统默认已经默认导入CoreImage框架)`
    // 1.创建CIFilter对象([二维码滤镜实例])，设置相关属性
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 恢复滤镜默认设置
    [qrFilter setDefaults];
    // 给滤镜添加数据
    NSData *stringData = [string dataUsingEncoding:NSUTF8StringEncoding];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    
    // 2.根据CIFilter对象生成CIImage([二维码])
    CIImage *qrImage = qrFilter.outputImage;
    
    // 3.放大并绘制二维码(上面生成的二维码很小,需要放大)[size 要大于等于 视图显示的尺寸]
    CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
    // 开启图形上下文
    UIGraphicsBeginImageContext(size);
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(contextRef, kCGInterpolationNone);
    
    // 4.翻转一下图片 不然生成的QRCode(二维码)就是上下颠倒的
    CGContextScaleCTM(contextRef, 1.0, -1.0);
    CGContextDrawImage(contextRef, CGContextGetClipBoundingBox(contextRef), cgImage);
    // 获取绘制好的图片
    UIImage *codeImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭图像上下文
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    
    return codeImage;//生成最终的二维码
}

#pragma mark - 2 彩色二维码
/// 彩色二维码,为二维码改变颜色[设置CIFilter的属性，改变其颜色]
- (UIImage *)changeColorForQRImage:(UIImage *)image backColor:(UIColor *)backColor frontColor:(UIColor *)frontColor {
    
    CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor" keysAndValues:
                             @"inputImage",[CIImage imageWithCGImage:image.CGImage],
                             @"inputColor0",[CIColor colorWithCGColor:frontColor.CGColor],
                             @"inputColor1",[CIColor colorWithCGColor:backColor.CGColor],
                             nil];
    return [UIImage imageWithCIImage:colorFilter.outputImage];
}

#pragma mark - 3.带logo的二维码
/// 带logo的二维码 [就是在二维码上面添加一个图片]
- (UIImage *)createQRCodeWithString:(NSString *)targetString logoImage:(UIImage *)logoImage {
    
    // 1.创建一个二维码滤镜实例
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    // 2.给滤镜添加数据
    NSString *targetStr = targetString;
    NSData *targetData = [targetStr dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:targetData forKey:@"inputMessage"];
    
    // 3.生成二维码
    CIImage *ciImage = [filter outputImage];
    
    // 4.高清处理：size 要大于等于视图显示的尺寸
    UIImage *image = [self createNonInterpolatedUIImageFromCIImage:ciImage size:[UIScreen mainScreen].bounds.size.width];
    
    // 5.嵌入logo
    // 开启图形上下文
    UIGraphicsBeginImageContext(image.size);
    // 将二维码的logo画入
    [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
    
    UIImage *temImg = logoImage;
    CGFloat centerW = image.size.width*0.25;
    CGFloat centerH = centerW;
    CGFloat centerX = (image.size.width-centerW)*0.5;
    CGFloat centerY = (image.size.height-centerH)*0.5;
    [temImg drawInRect:CGRectMake(centerX, centerY, centerW, centerH)];
    // 获取绘制好的图片
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    // 最终的二维码
    return finalImage;
}

- (UIImage *)createNonInterpolatedUIImageFromCIImage:(CIImage *)ciImage size:(CGFloat)size {
    
    CGRect rect = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(rect), size/CGRectGetHeight(rect));
    
    // 1.创建bitmap
    size_t width = CGRectGetWidth(rect)*scale;
    size_t height = CGRectGetHeight(rect)*scale;
    
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:rect];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, rect, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaleImage = CGBitmapContextCreateImage(bitmapRef);
    UIImage *image = [UIImage imageWithCGImage:scaleImage];
    
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGImageRelease(scaleImage);
    
    return image;
}



//创建高斯模糊效果图片(不会卡)
- (UIImage *)gsImage:(UIImage *)image withGsNumber:(CGFloat)blur {
    if (blur < 0.f || blur > 1.f) {
        blur = 0.5f;
    }
    int boxSize = (int)(blur * 40);
    boxSize = boxSize - (boxSize % 2) + 1;
    CGImageRef img = image.CGImage;
    vImage_Buffer inBuffer, outBuffer;
    vImage_Error error;
    void *pixelBuffer;
    //从CGImage中获取数据
    CGDataProviderRef inProvider = CGImageGetDataProvider(img);
    CFDataRef inBitmapData = CGDataProviderCopyData(inProvider);
    //设置从CGImage获取对象的属性
    inBuffer.width = CGImageGetWidth(img);
    inBuffer.height = CGImageGetHeight(img);
    inBuffer.rowBytes = CGImageGetBytesPerRow(img);
    inBuffer.data = (void*)CFDataGetBytePtr(inBitmapData);
    pixelBuffer = malloc(CGImageGetBytesPerRow(img) * CGImageGetHeight(img));
    if(pixelBuffer == NULL)
        NSLog(@"No pixelbuffer");
    outBuffer.data = pixelBuffer;
    outBuffer.width = CGImageGetWidth(img);
    outBuffer.height = CGImageGetHeight(img);
    outBuffer.rowBytes = CGImageGetBytesPerRow(img);
    error = vImageBoxConvolve_ARGB8888(&inBuffer, &outBuffer, NULL, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
    if (error) {
        NSLog(@"error from convolution %ld", error);
    }
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate( outBuffer.data, outBuffer.width, outBuffer.height, 8, outBuffer.rowBytes, colorSpace, kCGImageAlphaNoneSkipLast);
    CGImageRef imageRef = CGBitmapContextCreateImage (ctx);
    UIImage *returnImage = [UIImage imageWithCGImage:imageRef];
    //clean up
    CGContextRelease(ctx);
    CGColorSpaceRelease(colorSpace);
    free(pixelBuffer);
    CFRelease(inBitmapData);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return returnImage;
}


@end
