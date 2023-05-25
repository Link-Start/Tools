//
//  GGProgressView.h
//
//  Created by GG on 2016/10/20.
//  Copyright © 2016年 GG. All rights reserved.
//
//
/**
 自定义UIProgressView
 http://www.javashuo.com/article/p-yzzjdwvj-nk.html
 https://github.com/chenxing640/DYFProgressView
 
 */

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GGProgressViewStyle) {
    /// 默认 ，都不圆角
    GGProgressViewStyleDefault,
    /// 轨道圆角(默认半圆) -----------> 背景圆角，进度条不圆角
    GGProgressViewStyleTrackFillet ,
    /// 进度与轨道都圆角 -----------> 都圆角
    GGProgressViewStyleAllFillet,
};

NS_ASSUME_NONNULL_BEGIN

@interface GGProgressView : UIView

/// 类型
@property(nonatomic) GGProgressViewStyle progressViewStyle;

/// 背景图片是平铺填充 默认NO拉伸填充 设置为YES时图片复制平铺填充
@property(nonatomic, assign) BOOL isTile;

/// 0.0 .. 1.0, 默认0 超出为1.
@property (nonatomic, assign) float progress;

/// 背景颜色
@property(nonatomic, strong) UIColor *progressTintColor;
/// 进度/轨道填充 颜色
@property(nonatomic, strong) UIColor *trackTintColor;

/// 进度条背景图片,默认拉伸填充  优先级大于背景色
@property(nonatomic, strong) UIImage *progressImage;
/// 轨道填充图片
@property(nonatomic, strong) UIImage *trackImage;

/// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame progressViewStyle:(GGProgressViewStyle)style;


@end

NS_ASSUME_NONNULL_END


/**
 #import "GGProgressView.h"

 //初始化
 //高度就是frame设定的高度,自由设置
 GGProgressView *progressView=[[GGProgressView alloc]initWithFrame:CGRectMake(10, 100, self.view.bounds.size.width-20, 30)];
 //设置
 progressView.progressTintColor=[UIColor blueColor];
 progressView.trackTintColor=[UIColor redColor];
 progressView.progress=0.5;
 //添加
 [self.view addSubview:progressView];
 
 
 //更改样式,圆角
 
 progressView.progressViewStyle=GGProgressViewStyleAllFillet; // 都圆角

 progressView.progressViewStyle=GGProgressViewStyleTrackFillet;//  背景view圆角，进度不圆角

 
 //设置图片 能够设定填充方式
 progressView.progressImage=[UIImage imageNamed:@"111"];
 
*/
