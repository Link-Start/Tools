//
//  图片拉伸.h
//  LSProjectTool
//
//  Created by Xcode on 16/10/25.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef _____h
#define _____h


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