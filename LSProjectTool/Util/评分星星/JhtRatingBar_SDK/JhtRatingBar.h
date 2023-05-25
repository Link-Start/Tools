//
//  JhtRatingBar.h
//  JhtRatingBar
//
//  GitHub主页: https://github.com/jinht
//  CSDN博客: http://blog.csdn.net/anticipate91
//
//  Created by Jht on 2016/12/7.
//  Copyright © 2016年 JhtRatingBar. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 评分条 View */
@interface JhtRatingBar : UIView

#pragma mark - property
#pragma mark optional
/** 点亮星星数量 发生变化 */
typedef void (^StarChange)(void);

/// 可以在这里监测 星星数值变化
@property (nonatomic, copy) StarChange starChange;

/// 选择的分数
@property (nonatomic, assign, readonly) CGFloat scale;

/// 星星总的数量。默认: 5
@property (nonatomic, assign) NSInteger starTotalNumber;
/// 最少选中星星数。默认: 1
@property (nonatomic, assign) CGFloat minSelectedNumber;

///  选中星星的数量（设置默认选中星星个数）。 default: 星星总数
@property (nonatomic, assign) CGFloat selectedStarNumber;



/******************** 滑动评分：下面这两个属性不关闭，就可以滑动评分，默认是开启的 ********************/

/// 是否可触摸。默认：YES
@property (nonatomic, assign) BOOL touchEnable;
/// 是否允许滑动选择（在touchEnable = YES 前提下才有意义）。默认：YES
@property (nonatomic, assign) BOOL scrollSelectEnable;


/******************** 个性化设置：半分、背景色 ********************/

/// 是否需要半分。 默认：NO
@property (nonatomic, assign) BOOL isNeedHalf;
/// 底部视图的颜色。默认：[UIColor whiteColor]
@property (nonatomic, strong) UIColor *bgViewColor;


@end


/**
 1.
 
 [self addRatingBar];
 
 //添加评分条
 - (void)addRatingBar {
     __weak JhtRatingBar *weakBar = self.ratingBar;
     self.ratingBar.starChange = ^() {
         NSLog(@"星星值 scale = %lf", weakBar.scale);
     };
     
     [self.view addSubview:self.ratingBar];
 }

 - (JhtRatingBar *)ratingBar {
     if (!_ratingBar) {
         _ratingBar = [[JhtRatingBar alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 280) / 2, 88, 280, 35)];
         
         _ratingBar.bgViewColor = [UIColor lightGrayColor];
         _ratingBar.starTotalNumber = 8;
         _ratingBar.selectedStarNumber = 4;
         _ratingBar.minSelectedNumber = 0;
         _ratingBar.isNeedHalf = YES;
     }
     
     return _ratingBar;
 }
 
 2. 常规初始化
 JhtRatingBar *bar = [[JhtRatingBar alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width - 280) / 2, 150, 280, 35)];
 注：1. 假使这样初始化后不做其他属性的传递，评分条相关属性会使用默认值，例：星星总的数量（默认：5）
   2. 假使评分条宽度在初始化设置的时候，不足以放得下所有星星，内部会动态改变其宽度以至于可以放得下所有星星
 */
