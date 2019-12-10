//
//  ShoppingCartTool.m
//  ShoppingCartAnimation
//
//  Created by 蔡强 on 2017/7/17.
//  Copyright © 2017年 kuaijiankang. All rights reserved.
//

#import "ShoppingCartTool.h"

@implementation ShoppingCartTool

/**
 加入购物车的动画效果
 
 @param goodsImage 商品图片
 @param startPoint 动画起点
 @param endPoint   动画终点
 @param completion 动画执行完成后的回调
 */
+ (void)addToShoppingCartWithGoodsImage:(UIImage *)goodsImage startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint completion:(void (^)(BOOL))completion{
    
    //------- 创建shapeLayer -------//
    CAShapeLayer *animationLayer = [[CAShapeLayer alloc] init];
    animationLayer.frame = CGRectMake(startPoint.x - 40, startPoint.y - 40, 80, 80);
    animationLayer.contents = (id)goodsImage.CGImage;
    animationLayer.cornerRadius = 40;
    animationLayer.masksToBounds = YES;
    // 获取window的最顶层视图控制器
    UIViewController *rootVC = [[UIApplication sharedApplication].delegate window].rootViewController;
    UIViewController *parentVC = rootVC;
    while ((parentVC = rootVC.presentedViewController) != nil ) {
        rootVC = parentVC;
    }
    while ([rootVC isKindOfClass:[UINavigationController class]]) {
        rootVC = [(UINavigationController *)rootVC topViewController];
    }
    
    // 添加layer到顶层视图控制器上
    [rootVC.view.layer addSublayer:animationLayer];
    
//    //创建缩放动画
//
    CFTimeInterval durationScaleAnimation = 0.5;
    CFTimeInterval durationGuiji = 0.8;
    CFTimeInterval durationTime = durationScaleAnimation + durationGuiji;
    CABasicAnimation *scaleAnimation0 = [CASpringAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation0.duration = durationScaleAnimation;
    scaleAnimation0.fromValue = @(5.0);
    scaleAnimation0.toValue = @(1.0);

    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.duration = durationScaleAnimation;
    opacityAnimation.keyTimes = @[@0,@(durationScaleAnimation)];
    opacityAnimation.values = @[@0, @1];

    CAAnimationGroup *animation = [[CAAnimationGroup alloc] init];

    animation.animations = @[scaleAnimation0, opacityAnimation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = durationScaleAnimation;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    [animationLayer addAnimation:animation forKey:nil];

    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(durationScaleAnimation * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //------- 创建移动轨迹 -------//
        UIBezierPath *movePath = [UIBezierPath bezierPath];
        [movePath moveToPoint:startPoint];
//        [movePath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(15,kLS_relative_Height(300))];
        [movePath addQuadCurveToPoint:endPoint controlPoint:CGPointMake(kLS_ScreenWidth/2, startPoint.y-80)];

        // 轨迹动画
        CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        pathAnimation.duration = durationGuiji;
        pathAnimation.removedOnCompletion = NO;
        pathAnimation.fillMode = kCAFillModeForwards;
        pathAnimation.path = movePath.CGPath;
        
        /// 旋转动画
        CABasicAnimation *rotateAnimation   = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
        rotateAnimation.removedOnCompletion = YES;
        rotateAnimation.fromValue = [NSNumber numberWithFloat:0];
        rotateAnimation.toValue   = [NSNumber numberWithFloat:12];
        rotateAnimation.duration = durationGuiji;
        rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        rotateAnimation.fillMode = kCAFillModeForwards;

        
        //------- 创建缩小动画 -------//
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0.5];
        scaleAnimation.duration = durationGuiji;
        scaleAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        scaleAnimation.removedOnCompletion = NO;
        scaleAnimation.fillMode = kCAFillModeForwards;
        
        CAKeyframeAnimation *opacityAnimation1 = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation1.duration = durationGuiji;
        opacityAnimation1.keyTimes = @[@0,@(durationGuiji)];
        opacityAnimation1.values = @[@1, @0.5];
        opacityAnimation1.removedOnCompletion = NO;
        opacityAnimation1.fillMode = kCAFillModeForwards;
        
        // 添加轨迹动画
        [animationLayer addAnimation:pathAnimation forKey:nil];
        [animationLayer addAnimation:rotateAnimation forKey:nil];
        // 添加缩小动画
        [animationLayer addAnimation:scaleAnimation forKey:nil];
        [animationLayer addAnimation:opacityAnimation1 forKey:nil];
    });
   
    //------- 动画结束后执行 -------//
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((durationTime) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [animationLayer removeFromSuperlayer];
        completion(YES);
    });
}

+ (void)shakeAnimation:(UIView *)shakeView
{
    CABasicAnimation *shakeAnimation = [CABasicAnimation animationWithKeyPath:@"transform.translation.y"];
    shakeAnimation.duration = 0.25f;
    shakeAnimation.fromValue = [NSNumber numberWithFloat:-5];
    shakeAnimation.toValue = [NSNumber numberWithFloat:5];
    shakeAnimation.autoreverses = YES;
    [shakeView.layer addAnimation:shakeAnimation forKey:nil];
}

@end
