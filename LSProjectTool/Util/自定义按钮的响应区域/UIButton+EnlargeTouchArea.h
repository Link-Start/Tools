//
//  UIButton+EnlargeTouchArea.h
//  DianDianXiYi
//
//  Created by Xcode on 16/8/3.
//  Copyright © 2016年 mycard. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (EnlargeTouchArea)

#pragma mark - 自定义button的响应区域
/*************************** 扩张的边界大小 ******************/
@property (nonatomic, assign) CGFloat enlargedEdge;
/*************** 设置四个边界扩充的大小 ************************/
- (void)setEnlargeEdgeWithTop:(CGFloat)top right:(CGFloat)right bottom:(CGFloat)bottom left:(CGFloat)left;

@end
