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
///
/// view的x 坐标
@property (nonatomic, assign) CGFloat ls_x;
/// y 坐标
@property (nonatomic, assign) CGFloat ls_y;
/// 最大横坐标(代表控件右边界)
@property (nonatomic, assign) CGFloat ls_maxX;
/// 最大纵坐标(代表控件下边界)
@property (nonatomic, assign) CGFloat ls_maxY;
/// 中心点X坐标
@property (nonatomic, assign) CGFloat ls_centerX;
/// 中心点Y坐标
@property (nonatomic, assign) CGFloat ls_centerY;
/// 宽度值
@property (nonatomic, assign) CGFloat ls_width;
/// 高度值
@property (nonatomic, assign) CGFloat ls_height;
/// View大小
@property (nonatomic, assign) CGSize ls_size;
/// 初始坐标
@property (nonatomic, assign) CGPoint ls_origin;
/// 顶部坐标值
@property (nonatomic, assign) CGFloat ls_top;
/// 左部坐标值
@property (nonatomic, assign) CGFloat ls_left;
/// 底部坐标值
@property (nonatomic, assign) CGFloat ls_bottom;
/// 右部坐标值
@property (nonatomic, assign) CGFloat ls_right;

////////////////////////////////////////////////////////bounds
///
/// 边界大小
@property (nonatomic, assign) CGSize ls_boundsSize;
/// 边界宽度
@property (nonatomic, assign) CGFloat ls_boundsWidth;
/// 边界高度
@property (nonatomic, assign) CGFloat ls_boundsHeight;

//content getters
/// 边界区域
@property (nonatomic, readonly) CGRect ls_contentBounds;
/// 边界中心点
@property (nonatomic, readonly) CGPoint ls_contentCenter;

////////////////////////////////////////////////////////







///////////////////////////////////////////////////////

/// 水平居中
- (void)ls_alignHorizontal;
/// 垂直居中
- (void)ls_alignVertical;
/** **/
- (instancetype)ls_with;
///
- (instancetype)ls_and;
////////////////////////////////////////////////////////
/// 从Xib加载视图
+ (id)ls_loadFromNib;

////////////////////////////////////////////////////////

/// 判断是否显示在主窗口window上面      YES:在      NO：不在
- (BOOL)ls_isShowOnWindow;
/// 主控制器 - 响应者
- (UIViewController *)ls_parentController;
/// 判断View是否显示在屏幕上
- (BOOL)ls_isDisplayedInScreen;

/// 判断某个点是否在视图区域内，针对 transform 做了转换计算，并提供 UIEdgeInsets 缩放区域的参数
/// @param point  要判断的点坐标
/// @param view   传入的视图，一定要与本视图处于同一视图树中
/// @param insets UIEdgeInsets参数可以调整判断的边界
/// @return BOOL类型，返回点坐标是否位于视图内
- (BOOL)checkPoint:(CGPoint) point inView:(UIView *)view withInsets:(UIEdgeInsets)insets;

/// 第一响应者
- (UIView *)ls_firstResponder;
///获取一个view所属的控制器
- (UIViewController *)ls_belongViewController;


/// 移除所有的子视图
- (void)ls_removeAllSubViews;

/// 更新尺寸，使用autolayout布局时需要刷新约束才能获取到真实的frame
- (void)ls_updateFrame;

/// 切圆角
- (void)ls_setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;

@end

NS_ASSUME_NONNULL_END
