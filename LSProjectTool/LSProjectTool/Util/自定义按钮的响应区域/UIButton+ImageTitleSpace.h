//
//  UIButton+ImageTitleSpace.h
//  MadnessLAB
//
//  Created by Alex Yang on 2018/4/21.
//  Copyright © 2018年 Link_Start. All rights reserved.
//

#import <UIKit/UIKit.h>

// 定义一个枚举（包含了四种类型的button）
typedef NS_ENUM(NSUInteger, LSButtonEdgeInsetsStyle) {
    /// image在上，label在下
    LSButtonEdgeInsetsStyleTop,
    /// image在左，label在右
    LSButtonEdgeInsetsStyleLeft,
     /// image在下，label在上
    LSButtonEdgeInsetsStyleBottom,
    /// image在右，label在左
    LSButtonEdgeInsetsStyleRight
};


IB_DESIGNABLE

@interface UIButton (ImageTitleSpace)
///image在上，label在下:0   image在左，label在右:1  image在下，label在上:2  image在右，label在左:3
@property (nonatomic, assign) IBInspectable NSInteger ls_type;
///间隔
@property (nonatomic, assign) IBInspectable CGFloat ls_space;

///按钮点击事件
@property (nonatomic, copy) void(^btnClickAction)(UIButton *btn);

/**
 *  设置button的titleLabel和imageView的布局样式，及间距
 *
 *  @param style titleLabel和imageView的布局样式
 *  @param space titleLabel和imageView的间距
 */
- (void)layoutButtonWithEdgeInsetsStyle:(LSButtonEdgeInsetsStyle)style
                        imageTitleSpace:(CGFloat)space;
@end
