//
//  UIView+LSCategory.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/6/2.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LSCategory)
////////////////////////////////////////////////////////frame
/// view的x 坐标
@property (nonatomic, assign) CGFloat ls_x;
/// y 坐标
@property (nonatomic, assign) CGFloat ls_y;
///最大横坐标(代表控件右边界)
@property (nonatomic, assign) CGFloat ls_maxX;
///最大纵坐标(代表控件下边界)
@property (nonatomic, assign) CGFloat ls_maxY;
/*!
 @brief 中心点X坐标
 */
@property (nonatomic, assign) CGFloat ls_centerX;
/*!
 @brief 中心点Y坐标
 */
@property (nonatomic, assign) CGFloat ls_centerY;
/*!
 @brief 宽度值
 */
@property (nonatomic, assign) CGFloat ls_width;
/*!
 @brief 高度值
 */
@property (nonatomic, assign) CGFloat ls_height;
/*!
 @brief View大小
 */
@property (nonatomic, assign) CGSize ls_size;
/*!
 @brief 初始坐标
 */
@property (nonatomic, assign) CGPoint ls_origin;
/*!
 @brief 顶部坐标值
 */
@property (nonatomic, assign) CGFloat ls_top;
/*!
 @brief 左部坐标值
 */
@property (nonatomic, assign) CGFloat ls_left;
/*!
 @brief 底部坐标值
 */
@property (nonatomic, assign) CGFloat ls_bottom;
/*!
 @brief 右部坐标值
 */
@property (nonatomic, assign) CGFloat ls_right;

////////////////////////////////////////////////////////bounds
/*!
 @brief 边界大小
 */
@property (nonatomic, assign) CGSize ls_boundsSize;
/*!
 @brief 边界宽度
 */
@property (nonatomic, assign) CGFloat ls_boundsWidth;
/*!
 @brief 边界高度
 */
@property (nonatomic, assign) CGFloat ls_boundsHeight;

//content getters
/*!
 @brief 边界区域
 */
@property (nonatomic, readonly) CGRect ls_contentBounds;
/*!
 @brief 边界中心点
 */
@property (nonatomic, readonly) CGPoint ls_contentCenter;

////////////////////////////////////////////////////////







////////////////////////////////////////////////////////
/**
 *  水平居中
 */
- (void)alignHorizontal;
/**
 *  垂直居中
 */
- (void)alignVertical;
/** **/
- (instancetype)ls_with;

- (instancetype)ls_and;
////////////////////////////////////////////////////////
/**
 *  @brief 从Xib加载视图
 *
 *  @description Loads an instance from the Nib named like the class.
 *               Returns the first root object of the Nib.
 */
+ (id)loadFromNib;

////////////////////////////////////////////////////////

/**
 *  判断是否显示在主窗口window上面
 *
 *  @return 是:在      否：不在
 */
- (BOOL)isShowOnWindow;
///主控制器 - 响应者
- (UIViewController *)parentController;
// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen;
/// 第一响应者
- (UIView *)firstResponder;
///获取一个view所属的控制器
- (UIViewController *)belongViewController;


///移除所有的子视图
- (void)removeAllSubViews;

@end

NS_ASSUME_NONNULL_END
