//
//  UIButton+EnlargeTouchArea.m
//  DianDianXiYi
//
//  Created by Xcode on 16/8/3.
//  Copyright © 2016年 mycard. All rights reserved.
//

#import "UIButton+EnlargeTouchArea.h"
#import <objc/runtime.h>

@implementation UIButton (EnlargeTouchArea)

#pragma mark - 自定义button的响应区域
static char topEdgeKey;
static char rightEdgeKey;
static char bottomEdgeKey;
static char leftEdgeKey;

#pragma mark - 自定义button的响应区域
//合成存取方法
- (void)setEnlargedEdge:(CGFloat)enlargedEdge {
    
    [self setEnlargeEdgeWithTop:enlargedEdge right:enlargedEdge bottom:enlargedEdge left:enlargedEdge];
}

- (CGFloat)enlargedEdge {
    return [(NSNumber *)objc_getAssociatedObject(self, &topEdgeKey) floatValue];
}

///设置扩充边界
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left {
    
    objc_setAssociatedObject(self, &topEdgeKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightEdgeKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomEdgeKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftEdgeKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    
}

///获得当前的响应rect
- (CGRect)enlargedRect {
    
    NSNumber *topEdge = objc_getAssociatedObject(self, &topEdgeKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightEdgeKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomEdgeKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftEdgeKey);
    
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    } else {
        
        return self.bounds;
    }
}
//
/////系统方法重载
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *) event {
//
//    if (self.alpha <= 0.01 || !self.userInteractionEnabled || self.hidden) {
//        return nil;
//    }
//
//    CGRect rect = [self enlargedRect];
//
//    if (CGRectEqualToRect(rect, self.bounds)) {
//        return [super hitTest:point withEvent:event];
//    }
//    return CGRectContainsPoint(rect, point) ? self : nil;
//}

//######################## button不设置高度此处 会有问题
/////自定义按钮点击的有效区域
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
//    
//    
//    //首先调用父类的方法确定点击的区域确实在按钮的区域中
//    BOOL res = [super pointInside:point withEvent:event];
//
////    if (res) {
////        //绘制一个圆形path
////        //判断一个点是否在一个不是矩形的区域中 - (BOOL)containsPoint:(CGPoint)point;
////        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
////        if ([path containsPoint:point]) {
////            //如果在path区域内，返回YES
////            return YES;
////        }
////        return NO;
////    }
//    
//    return YES;
//}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    
    //    CGRect bounds = self.bounds;
    //    //若原热区小于44x44，则放大热区，否则保持原大小不变
    //    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    //    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    //    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    //    return CGRectContainsPoint(bounds, point);
    
    CGRect rect = [self enlargedRect];
    
    if (self.tag == 413) {
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        CGFloat widthDelta = MAX(self.enlargedEdge, self.bounds.size.width);
        CGFloat heightDelta = MAX(self.enlargedEdge, self.bounds.size.height);
        rect = CGRectInset(rect, widthDelta, heightDelta);
    } else {
        //若原热区小于44x44，则放大热区，否则保持原大小不变
        CGFloat widthDelta = MAX(44.0 - rect.size.width, 0);
        CGFloat heightDelta = MAX(44.0 - rect.size.height, 0);
        rect = CGRectInset(rect, -0.5 * widthDelta, -0.5 * heightDelta);
    }
    return CGRectContainsPoint(rect, point);
}

@end
