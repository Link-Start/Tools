//
//  UIView+LSExtension.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/20.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "UIView+LSExtension.h"

@implementation UIView (LSExtension)


//这样就能切出一个只有下半部圆角的View，更厉害的是，切去的部分不响应用户点击！
- (void)dwMakeBottomRoundCornerWithRadius:(CGFloat)radius {
    
    CGSize size = self.frame.size;
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setFillColor:[[UIColor whiteColor] CGColor]];
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, size.width - radius, size.height);
    CGPathAddArc(path, NULL, size.width-radius, size.height-radius, radius, M_PI/2, 0.0, YES);
    CGPathAddLineToPoint(path, NULL, size.width, 0.0);
    CGPathAddLineToPoint(path, NULL, 0.0, 0.0);
    CGPathAddLineToPoint(path, NULL, 0.0, size.height - radius);
    CGPathAddArc(path, NULL, radius, size.height - radius, radius, M_PI, M_PI/2, YES);
    CGPathCloseSubpath(path);
    [shapeLayer setPath:path];
    CFRelease(path);
    self.layer.mask = shapeLayer;
    //layer的mask，顾名思义，是种位掩蔽，在shapeLayer的填充区域中，alpha值不为零的部分，self会被绘制；alpha值为零的部分，self不会被绘制，甚至不会响应touch
    
}

/**
 使用masonry设置view后发现，设置任意角的圆角不起作用。
 解决方法：
 当设置完控件的约束，需要调用layoutIfNeeded 函数进行布局，然后所约束的控件才会按照约束条件，生成当前布局相应的frame和bounds。这样就可以利用这两个属性来进行图片圆角剪裁
 [self layoutIfNeeded];//这句代码很重要，不能忘了
 [self setRoundedCorners:UIRectCornerTopLeft radius:6];
 */
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}




@end
