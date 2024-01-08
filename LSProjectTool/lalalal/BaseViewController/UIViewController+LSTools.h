//
//  UIViewController+LSTools.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/4.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LSTools)


#pragma mark - 返回


#pragma mark - pop/dismiss
/// 返回上个页面，pop/dismiss
- (void)judge;
/// 默认返回按钮的点击事件，pop/dimiss【当根试图是present出来的时候，这个方法会有问题】
- (void)ls_backButtonAction;


#pragma mark - pop
/// 返回指定控制器(同一个Nav之下)
- (void)ls_backOutToVC:(UIViewController *)VC;
/// 返回指定控制器(同一个Nav之下)
- (void)ls_backOutToClassVC:(Class)tempClass;
/// 返回指定控制器(可以是 不同Nav之下)
/// 从tabBarController的某个item下的 多层栈中的一个VC 跳转到同一个tabBarController之下的其他item的第一个VC
- (void)ls_backOutToClassVCs:(Class)tempClass;
///返回指定控制器(可以是 不同Nav之下)
/// 从tabBarController的某个item下的 多层栈中的一个VC 跳转到同一个tabBarController之下的其他item的 某个VC
- (void)ls_backOutTabBarControlItemToOtherItem:(Class)tempClass tabBarlItem:(NSInteger)tabBarItem;
/// 从tabBarController的某个itemVC 返回到同一个tabBarController 之下的其他 item 的VC
/// Note:感觉有点鸡肋,只能从 tabBarControll.的某个item第一个VC跳到其他item的第一个VC
- (void)ls_backOutToTabBarControllerOtherItemVC:(Class)tempClass;


/// 返回根试图
- (void)ls_backRootVC;
///后退几步
- (void)ls_backSeveralSteps:(NSInteger)steps;

/// 延迟 几秒， 后退几步
- (void)ls_backSeveralSteps:(NSInteger)steps delay:(CGFloat)delay;

/// 延迟 几秒 popToVC
- (void)ls_popToViewController:(UIViewController *)vc delay:(CGFloat)delay;
/// 延迟 几秒 popToVC
- (void)ls_popToViewController:(UIViewController *)vc animated:(BOOL)animated delay:(CGFloat)delay;
/// 延迟 几秒 popToRootVC
- (void)ls_popToRootViewControllerDelay:(CGFloat)delay;
/// 延迟 几秒 popVC
- (void)ls_popViewControllerDelay:(CGFloat)delay;

/// popToVC
- (void)ls_popToViewController:(UIViewController *)vc;
/// popToRootVC
- (void)ls_popToRootViewController;
/// popVC  返回上一个页面
- (void)ls_popViewControllerDelay;


#pragma mark - dismiss
/// dismiss 到指定的控制器
- (void)ls_dismissToVC:(Class)temVC;
/// dismiss 到根试图控制器
- (void)ls_dismissToRootVC;
/// dismiss 指定 层数 控制器
- (void)dismissViewControllerWithTimes:(NSUInteger)times animated:(BOOL)flag completion:(void (^)(void))completion;


#pragma mark -
/// 从targetVc 所在的导航控制器Nav中 移除某个vc
- (void)removeCurrentVC:(UIViewController *)targetVc;
/// 从targetVc 所在的导航控制器Nav中 移除某个vc
- (void)removeCurrentVcAnimation:(UIViewController *)targetVc;
/// 保留 targetVc 所在导航条Nav 中的第一个和最后一个VC,其余的全部移除
- (void)retainTargetVcWhereNavFirstAndLastVC:(UIViewController *)targetVc;


#pragma mark - present
/// iOS13后，Prensent方式弹出页面时，默认的模式变为了UIModalPresentationAutomatic，如果想用之前的样式
- (void)ls_presentViewController:(UIViewController *)vc completion:(void (^)(void))completion;


#pragma mark - tabBar
/// 选择tabBarController其他 item
- (void)ls_selectTabBarControllerOtherItemIndex:(NSInteger)index;
/// 更改tabBarController选中的 item
- (void)ls_changeTabBarControllerSelectItemIndex:(NSInteger)index;
/// 设置tabBar角标
- (void)setTabBarBadgeWithTabBarItemIndex:(NSInteger)tabBarItemIndex badgeNum:(NSInteger)badgeNum;


#pragma mark -
/// 获取当前控制器
- (UIViewController*)ls_getCurrentViewController;
/// 通过递归拿到当前控制器
- (UIViewController*)ls_currentViewControllerFrom:(UIViewController *)viewController;


#pragma mark -
///判断当前UIViewController 是否正在显示。
- (BOOL)ls_currentVCIsVisible;
/// 判断某个VC是否正在显示
- (BOOL)ls_judgeVCWhetherIsVisible:(UIViewController *)VC;



#pragma mark -
/// Xib 加载 View
- (UIView *)ls_loadViewFromXibName:(NSString *)viewXibName;
/// 加载 Xib
- (UINib *)ls_loadNibWithNibName:(NSString *)nibName;


@end

NS_ASSUME_NONNULL_END
