//
//  UIViewController+LYPageWillAppear.h
//  bangjob
//
//  Created by langezhao on 2019/12/23.
//  Copyright © 2019 com.58. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString * const LYViewControllerViewWillAppearNotification = @"LYViewControllerViewWillAppearIdentify";
static NSString * const LYViewControllerViewDidAppearNotification = @"LYViewControllerViewDidAppearIdentify";
static NSString * const LYViewControllerViewWillDisappearNotification = @"LYViewControllerViewWillDisappearIdentify";
static NSString * const LYViewControllerViewDidDisappearNotification = @"LYViewControllerViewDidDisappearIdentify";

static NSString * const LYViewControllerClassName = @"LYViewControllerClassNameIdentify";
static NSString * const LYViewControllerClassIdentifier = @"LYViewControllerClassIdentifier";

@interface UIViewController (LYPageWillAppear)

/// 获取当前显示的Controller
+ (UIViewController *)currentViewController;

/// 判断是否存在存在视图控制器VC
+ (BOOL)existViewController:(UIViewController *)identifier;

@end

NS_ASSUME_NONNULL_END
