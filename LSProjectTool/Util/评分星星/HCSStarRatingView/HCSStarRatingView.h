// HCSStarRatingView.h
//
// Copyright (c) 2015 Hugo Sousa
//
// pod 'HCSStarRatingView', '~> 1.5'

@import UIKit;

typedef BOOL(^HCSStarRatingViewShouldBeginGestureRecognizerBlock)(UIGestureRecognizer *gestureRecognizer);

IB_DESIGNABLE
@interface HCSStarRatingView : UIControl
/// 最大星星值，默认 5
@property (nonatomic) IBInspectable NSUInteger maximumValue;
/// 最小星星值，默认0。不能选择比minimumValue小的星星值,当你没有选择星星时value也是minimumValue
@property (nonatomic) IBInspectable CGFloat minimumValue;
/// 当前星星值。默认0
@property (nonatomic) IBInspectable CGFloat value;
/// 星星之间的间距
@property (nonatomic) IBInspectable CGFloat spacing;
/// 是否允许选择半星。默认NO
@property (nonatomic) IBInspectable BOOL allowsHalfStars;
/// 是否允许精确选择，可以根据选择位置进行精确选择，默认NO
@property (nonatomic) IBInspectable BOOL accurateHalfStars;
/// 是否连续调用回调方法。如果设置为YES,则在手指拖动时,会持续调用回调方法;如果设置为NO,则是有拖动结束后才调用回调。默认YES
@property (nonatomic) IBInspectable BOOL continuous;
/// 是否允许成为第一响应者
@property (nonatomic) BOOL shouldBecomeFirstResponder;

// Optional: if `nil` method will return `NO`.
/// 应该开始识别手势，可选:如果为nil,方法将返回NO。    添加手势时使用
@property (nonatomic, copy) HCSStarRatingViewShouldBeginGestureRecognizerBlock shouldBeginGestureRecognizerBlock;

/// 星星的边框颜色
@property (nonatomic, strong) IBInspectable UIColor *starBorderColor;
/// 星星的边框宽度
@property (nonatomic) IBInspectable CGFloat starBorderWidth;
/// 空星的颜色                       [.tintColor 设置满星的颜色]
@property (nonatomic, strong) IBInspectable UIColor *emptyStarColor;

/**************** 自定义星星视图UI ****************/

/// 设置空星 的图片
@property (nonatomic, strong) IBInspectable UIImage *emptyStarImage;
/// 设置半星 的图片
@property (nonatomic, strong) IBInspectable UIImage *halfStarImage;
/// 设置满星 的图片
@property (nonatomic, strong) IBInspectable UIImage *filledStarImage;

@end

/**
 
 HCSStarRatingView *starRatingView = [HCSStarRatingView new];
 starRatingView.maximumValue = 10; //最大的星星数量，默认5
 starRatingView.minimumValue = 0; //最小的星星评分的值，默认0，不能选择比minimumValue小的星星值，当你没有选择星星时value也是minimumValue
 starRatingView.value = 4; //当前星星的值
 starRatingView.allowsHalfStars = YES; //是否允许半星，默认NO
 starRatingView.accurateHalfStars = YES; //是否允许精确选择，可以根据选择位置进行精确选择，默认NO
 starRatingView.tintColor = [UIColor redColor]; // 星星的颜色
 // 设置空星时的图片
 starRatingView.emptyStarImage = [[UIImage imageNamed:@"heart-empty"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
 // 设置满星时的图片
 starRatingView.filledStarImage = [[UIImage imageNamed:@"heart-full"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
 // 添加target
 [starRatingView addTarget:self action:@selector(didChangeValue:) forControlEvents:UIControlEventValueChanged];
 [self.view addSubview:starRatingView];
 
 
 - (void)didChangeValue:(HCSStarRatingView *)sender {
     NSLog(@"Changed rating to %.1f", sender.value);
 }

 
 */
