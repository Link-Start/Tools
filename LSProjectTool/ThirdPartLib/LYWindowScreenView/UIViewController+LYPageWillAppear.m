//
//  UIViewController+LYPageWillAppear.m
//  bangjob
//
//  Created by langezhao on 2019/12/23.
//  Copyright © 2019 com.58. All rights reserved.
//

#import "UIViewController+LYPageWillAppear.h"
#import "NSObject+LYSwizzle.h"


@implementation UIViewController (LYPageWillAppear)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL oldviewWillAppear = @selector(viewWillAppear:);
        SEL newviewWillAppear = @selector(p_viewWillAppear:);
        
        SEL oldviewDidAppear = @selector(viewDidAppear:);
        SEL newviewDidAppear = @selector(p_viewDidAppear:);
        
        SEL oldviewWillDisappear = @selector(viewWillDisappear:);
        SEL newviewWillDisappear = @selector(p_viewWillDisappear:);
        
        SEL oldviewDidDisappear = @selector(viewDidDisappear:);
        SEL newviewDidDisappear = @selector(p_viewDidDisappear:);
        
        SEL oldpresentDidDisappear = @selector(presentViewController:animated:completion:);
        SEL newpresentDidDisappear = @selector(p_presentViewController:animated:completion:);

        
        [self swizzleInstanceSelector:oldviewWillAppear withNewSelector:newviewWillAppear];
        [self swizzleInstanceSelector:oldviewDidAppear withNewSelector:newviewDidAppear];
        [self swizzleInstanceSelector:oldviewWillDisappear withNewSelector:newviewWillDisappear];
        [self swizzleInstanceSelector:oldviewDidDisappear withNewSelector:newviewDidDisappear];
        [self swizzleInstanceSelector:oldpresentDidDisappear withNewSelector:newpresentDidDisappear];

    });
}

/// 修复ios13下模态页面问题
/// iOS13的present默认是非全屏的展示，present之后页面并不会走viewWillDisappear方法，导致弹窗不会自动移除。
/// 这种情况需要手动去移除弹窗或者走iOS13以前的present方式。
- (void)p_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if (@available(iOS 13.0, *)) {
        if (viewControllerToPresent.modalPresentationStyle != UIModalPresentationCustom) {
            viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    } else {
        // Fallback on earlier versions
    }
    [self p_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

/// 页面将要显示
- (void)p_viewWillAppear:(BOOL)animated {
    [self p_viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:LYViewControllerViewWillAppearNotification object:@{LYViewControllerClassName:NSStringFromClass([self class]),LYViewControllerClassIdentifier:self}];
}

/// 页面已经显示
- (void)p_viewDidAppear:(BOOL)animated {
    [self p_viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:LYViewControllerViewDidAppearNotification object:@{LYViewControllerClassName:NSStringFromClass([self class]),LYViewControllerClassIdentifier:self}];
}

/// 页面将要消失
- (void)p_viewWillDisappear:(BOOL)animated {
    [self p_viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:LYViewControllerViewWillDisappearNotification object:@{LYViewControllerClassName:NSStringFromClass([self class]),LYViewControllerClassIdentifier:self}];
}

/// 页面已经消失
- (void)p_viewDidDisappear:(BOOL)animated {
    [self p_viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:LYViewControllerViewDidDisappearNotification object:@{LYViewControllerClassName:NSStringFromClass([self class]),LYViewControllerClassIdentifier:self}];
}

/// 获取当前显示的Controller
+ (UIViewController *)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}

+ (UIViewController *)findBestViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self findBestViewController:viewController.presentedViewController];
        
    } else if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = (UISplitViewController *)viewController;
        if (splitVC.viewControllers.count > 0) {
            return [self findBestViewController:splitVC.viewControllers.lastObject];
        }
        
    } else if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        if (nav.viewControllers.count > 0) {
            return [self findBestViewController:nav.topViewController];
        }
        
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        if (tabBarController.viewControllers.count > 0) {
            return [self findBestViewController:tabBarController.selectedViewController];
        }
        
    } else if ([viewController isKindOfClass:[UIWindow class]]) {
        UIWindow *window = (UIWindow *)viewController;
        if (window.rootViewController) {
            return [self findBestViewController:window.rootViewController];
        }
    }
    
    return viewController;
}

/// 判断是否存在存在视图控制器VC
+ (BOOL)existViewController:(UIViewController *)identifier {
    if ([identifier isKindOfClass:[UIViewController class]]) {
        if (identifier.navigationController || identifier.presentingViewController) {
            return YES;
        }
    }
    return NO;
}

@end
