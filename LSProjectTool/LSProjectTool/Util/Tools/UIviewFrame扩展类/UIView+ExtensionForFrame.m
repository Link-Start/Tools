//
//  UIView+ExtensionForFrame.m
//  Function
//
//  Created by liuxiangyu on 15/12/18.
//  Copyright (c) 2015年 lanou3G.com. All rights reserved.
//
/*
 在声明property属性后，有2种实现选择
 1
 @synthesize
 编译器期间，让编译器自动生成getter/setter方法。
 当有自定义的存或取方法时，自定义会屏蔽自动生成该方法
 
 2
 @dynamic
 告诉编译器，不自动生成getter/setter方法，避免编译期间产生警告
 然后由自己实现存取方法
 或存取方法在运行时动态创建绑定：主要使用在CoreData的实现NSManagedObject子类时使用，由Core Data框架在程序运行的时动态生成子类属性
 */


#import "UIView+ExtensionForFrame.h"

@implementation UIView (ExtensionForFrame)












// lx_x
- (void)setLs_x:(CGFloat)ls_x {
    CGRect frame = self.frame;
    frame.origin.x = ls_x;
    self.frame = frame;
}

- (CGFloat)ls_x
{
    return self.frame.origin.x;
}

// ls_y
- (void)setLs_y:(CGFloat)ls_y {
    CGRect frame = self.frame;
    frame.origin.y = ls_y;
    self.frame = frame;
}

- (CGFloat)ls_y
{
    return self.frame.origin.y;
}

// ls_maxX
- (void)setLs_maxX:(CGFloat)ls_maxX {
    self.ls_x = ls_maxX - self.ls_width;
}

- (CGFloat)ls_maxX
{
    return CGRectGetMaxX(self.frame);
}

// lx_maxY
- (void)setLs_maxY:(CGFloat)ls_maxY {
    self.ls_y = ls_maxY - self.ls_height;
}

- (CGFloat)ls_maxY
{
    return CGRectGetMaxY(self.frame);
}

// ls_centerX
- (void)setLs_centerX:(CGFloat)ls_centerX {
    CGPoint center = self.center;
    center.x = ls_centerX;
    self.center = center;
}

- (CGFloat)ls_centerX
{
    return self.center.x;
}

// ls_centerY
- (void)setLs_centerY:(CGFloat)ls_centerY {
    CGPoint center = self.center;
    center.y = ls_centerY;
    self.center = center;
}

- (CGFloat)ls_centerY
{
    return self.center.y;
}

// ls_width
- (void)setLs_width:(CGFloat)ls_width {
    CGRect frame = self.frame;
    frame.size.width = ls_width;
    self.frame = frame;
}

- (CGFloat)ls_width
{
    return self.frame.size.width;
}

// ls_height
- (void)setLs_height:(CGFloat)ls_height {
    CGRect frame = self.frame;
    frame.size.height = ls_height;
    self.frame = frame;
}

- (CGFloat)ls_height
{
    return self.frame.size.height;
}

// ls_size
- (void)setLs_size:(CGSize)ls_size {
    CGRect frame = self.frame;
    frame.size = ls_size;
    self.frame = frame;
}

- (CGSize)ls_size
{
    return self.frame.size;
}

// ls_origin
- (void)setLs_origin:(CGPoint)ls_origin {
    CGRect frame = self.frame;
    frame.origin = ls_origin;
    self.frame = frame;
}

- (CGPoint)ls_origin
{
    return self.frame.origin;
}

// ls_top
- (void)setLs_top:(CGFloat)ls_top {
    CGRect frame = self.frame;
    frame.origin.y = ls_top;
    self.frame = frame;
}

- (CGFloat)ls_top
{
    return self.ls_origin.y;
}

// ls_left
- (void)setLs_left:(CGFloat)ls_left {
    CGRect frame = self.frame;
    frame.origin.x = ls_left;
    self.frame = frame;
}

- (CGFloat)ls_left
{
    return self.ls_origin.x;
}

// ls_right
- (void)setLs_right:(CGFloat)ls_right {
    CGRect frame = self.frame;
    frame.origin.x = ls_right - frame.size.width;
    self.frame = frame;

}

- (CGFloat)ls_right
{
    return self.ls_left + self.ls_width;
}

// ls_bottom
- (void)setLs_bottom:(CGFloat)ls_bottom {
    CGRect frame = self.frame;
    frame.origin.y = ls_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)ls_bottom
{
    return self.ls_top + self.ls_height;
}

//////////////////////////////////////////////////////////////bounds accessors
// ls_boundsSize
- (void)setLs_boundsSize:(CGSize)ls_boundsSize {
    CGRect bounds = self.bounds;
    bounds.size = ls_boundsSize;
    self.bounds = bounds;
}

- (CGSize)ls_boundsSize
{
    return self.bounds.size;
}

// ls_boundsWidth
- (void)setLs_boundsWidth:(CGFloat)ls_boundsWidth {
    CGRect bounds = self.bounds;
    bounds.size.width = ls_boundsWidth;
    self.bounds = bounds;
}

- (CGFloat)ls_boundsWidth
{
    return self.ls_boundsSize.width;
}

// ls_boundsHeight
- (void)setLs_boundsHeight:(CGFloat)ls_boundsHeight {
    CGRect bounds = self.bounds;
    bounds.size.height = ls_boundsHeight;
    self.bounds = bounds;
}
- (CGFloat)ls_boundsHeight
{
    return self.ls_boundsSize.height;
}

//ls_contentBounds
- (CGRect)ls_contentBounds
{
    return CGRectMake(0.0f, 0.0f, self.ls_boundsWidth, self.ls_boundsHeight);
}

// ls_contentCenter
- (CGPoint)ls_contentCenter
{
    return CGPointMake(self.ls_boundsWidth/2.0f, self.ls_boundsHeight/2.0f);
}

///水平居中
- (void)alignHorizontal {
    self.ls_x = (self.superview.ls_width - self.ls_width) * 0.5;
}
///垂直居中
- (void)alignVertical {
    self.ls_y = (self.superview.ls_height - self.ls_height) *0.5;
}

/** **/
- (instancetype)ls_with {
    return self;
}

- (instancetype)ls_and {
    return self;
}

/**************************************************************************/
/**
 *  @brief 从Xib加载视图
 */
+ (id)loadFromNib
{
    NSString *nibName = NSStringFromClass([self class]);
    NSArray *elements = [[NSBundle mainBundle] loadNibNamed:nibName
                                                      owner:nil
                                                    options:nil];
    for ( NSObject *anObject in elements ) {
        if ( [anObject isKindOfClass:[self class]] ) {
            return anObject;
        }
    }
    return nil;
}

/**************************************************************************/
///判断是否显示在主窗口window上面
- (BOOL)isShowOnWindow {
    //主窗口
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //相对于父控件转换之后的rect
    CGRect newRect = [keyWindow convertRect:self.frame fromView:self.superview];
    //主窗口的bounds
    CGRect winBounds = keyWindow.bounds;
    //判断两个坐标系是否有交汇的地方，返回bool值
    BOOL isIntersects =  CGRectIntersectsRect(newRect, winBounds);
    if (self.hidden != YES && self.alpha >0.01 && self.window == keyWindow && isIntersects) {
        return YES;
    }else{
        return NO;
    }
}

///主控制器
- (UIViewController *)parentController {
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

/**************************************************************************/
- (UIView *)firstResponder {
    if ([self isFirstResponder]) {
        return self;
    }
    UIView *firstResponder = nil;
    NSArray *subviews = self.subviews;
    for (UIView *subview in subviews) {
        firstResponder = [subview firstResponder];
        if (firstResponder) {
            return firstResponder;
        }
    }
    return nil;
}


@end
