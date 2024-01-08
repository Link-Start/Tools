//
//  UIViewController+LSTools.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/4.
//  Copyright © 2024 Link-Start. All rights reserved.
//
//  isKindOfClass：确定一个对象是否是一个类的成员，或者是派生自该类的成员。
//  isMemberOfClass：确定一个对象是否是当前类的成员。
//
//  isMemberOfClass不能检测任何的类都是基于NSObject类这一事实，而isKindOfClass可以。

#import "UIViewController+LSTools.h"


@interface UIViewController ()

@end

@implementation UIViewController (LSTools)


#pragma mark - 返回，pop/dismiss
- (void)judge {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
    } else {
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

// 返回方法
- (void)ls_backButtonAction {//(当根试图是present出来的时候)这个方法会有问题
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - pop
/// 返回指定控制器(同一个Nav之下)
- (void)ls_backOutToVC:(UIViewController *)VC {
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[VC class]]) {
            [self.navigationController popToViewController:VC animated:YES];
        }
    }
}
/// 返回指定控制器(同一个Nav之下)
- (void)ls_backOutToClassVC:(Class)tempClass {
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:tempClass]) {
            [self.navigationController popToViewController:tempVC animated:YES];
        }
    }
}

/// 返回指定控制器(可以是 不同Nav之下)
/// 从tabBarController的某个item下的 多层栈中的一个VC 跳转到同一个tabBarController之下的其他item的第一个VC
- (void)ls_backOutToClassVCs:(Class)tempClass {
//    for (UIViewController *tempVC in self.navigationController.viewControllers) {
//        if ([tempVC isKindOfClass:tempClass]) {
//            [self.navigationController popToViewController:tempVC animated:YES];
//            return;
//        } else {
//            for (int i = 0; i < self.tabBarController.viewControllers.count; i++) {
//                UINavigationController *tempNav = self.tabBarController.viewControllers[i];
//                if ([tempNav.topViewController isKindOfClass:tempClass]) {
//
//                    //借鉴:https://blog.csdn.net/zhao15127334470/article/details/98955374
//                    /******************下面的方法可以偷偷的把nav中的vc 移出栈*********************/
//                    NSMutableArray *VCSArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//                    if (VCSArray.count >= 2) {
//                        [VCSArray removeObjectsInRange:NSMakeRange(1, VCSArray.count-2)];
//                        self.navigationController.viewControllers = VCSArray;
//                    }
//                     /******************上面的方法可以偷偷的把nav中的vc 移出栈*********************/
//
//                    [self ls_selectTabBarControllerOtherItemVC:i];//选择tabBarController其他 item
//                    [self.navigationController popViewControllerAnimated:YES];
//                    return;
//                }
//            }
//        }
//    }
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:tempClass]) {
            [self.navigationController popToViewController:tempVC animated:YES];
            return;
        }
    }
    for (int i = 0; i < self.tabBarController.viewControllers.count; i++) {
        UINavigationController *tempNav = self.tabBarController.viewControllers[i];
        if ([tempNav.topViewController isKindOfClass:tempClass]) {
            
            //借鉴:https://blog.csdn.net/zhao15127334470/article/details/98955374
            /******************下面的方法可以偷偷的把nav中的vc 移出栈*********************/
            NSMutableArray *VCSArray = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            if (VCSArray.count >= 2) {
                [VCSArray removeObjectsInRange:NSMakeRange(1, VCSArray.count-2)];
                self.navigationController.viewControllers = VCSArray;
            }
             /******************上面的方法可以偷偷的把nav中的vc 移出栈*********************/
            
            [self ls_selectTabBarControllerOtherItemIndex:i];//选择tabBarController其他 item
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    NSLog(@"没找到要跳转的控制器：%@", tempClass);
}

/// 返回指定控制器(可以是 不同Nav之下)
/// 从tabBarController的某个item下的 多层栈中的一个VC 跳转到同一个tabBarController之下的其他item的 某个VC
- (void)ls_backOutTabBarControlItemToOtherItem:(Class)tempClass tabBarlItem:(NSInteger)tabBarItem {
    //    for (UIViewController *tempVC in self.navigationController.viewControllers) {
    //        if ([tempVC isKindOfClass:tempClass]) {
    //            [self.navigationController popToViewController:tempVC animated:YES];
    //            return;
    //        } else {
    //            [self ls_selectTabBarControllerOtherItemVC:tabBarItem];//选择tabBarController其他 item
    //            UINavigationController *tempNav = self.tabBarController.viewControllers[tabBarItem];
    //            NSMutableArray *VCS = [NSMutableArray arrayWithArray:tempNav.viewControllers];
    //            [VCS addObject:tempVC];
    //            tempNav.viewControllers = VCS;
    //            self.navigationController.viewControllers = VCS;
    //            [self.navigationController popViewControllerAnimated:YES];
    //            break;
    //        }
    //    }
    
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:tempClass]) {
            [self.navigationController popToViewController:tempVC animated:YES];
            return;
        }
    }
    [self ls_selectTabBarControllerOtherItemIndex:tabBarItem];//选择tabBarController其他 item
    UINavigationController *tempNav = self.tabBarController.viewControllers[tabBarItem];
    if ([[tempNav.topViewController class] isKindOfClass:tempClass]) {
    } else {
        UIViewController *tempVC = [[tempClass alloc] init];
        NSMutableArray *VCS = [NSMutableArray arrayWithArray:tempNav.viewControllers];
        [VCS addObject:tempVC];
        tempNav.viewControllers = VCS;
        self.navigationController.viewControllers = VCS;
    }
    [self.navigationController popViewControllerAnimated:YES];
    return;
}

/// 从tabBarController的某个itemVC 返回到同一个tabBarController 之下的其他 item 的VC
/// Note:感觉有点鸡肋,只能从 tabBarControll.的某个item第一个VC跳到其他item的第一个VC
- (void)ls_backOutToTabBarControllerOtherItemVC:(Class)tempClass {
    for (int i = 0; i < self.tabBarController.viewControllers.count; i++) {
        //nav
        if ([self.tabBarController.viewControllers[i] isKindOfClass:[UINavigationController class]]) {
            UINavigationController *tempNav = self.tabBarController.viewControllers[i];
            if ([tempNav.topViewController isKindOfClass:tempClass]) {
                [self ls_selectTabBarControllerOtherItemIndex:i];//选择tabBarController其他 item
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        } else { //VC
            UIViewController *tempVC = self.tabBarController.viewControllers[i];
            if ([tempVC isKindOfClass:tempClass]) {
                [self ls_selectTabBarControllerOtherItemIndex:i];//选择tabBarController其他 item
                [self.navigationController popToRootViewControllerAnimated:YES];
                return;
            }
        }
    }
    NSLog(@"没找到要跳转的控制器：%@", tempClass);
}


/// 返回根试图
- (void)ls_backRootVC {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

/// 后退几步
- (void)ls_backSeveralSteps:(NSInteger)steps {
    NSInteger subNum = self.navigationController.viewControllers.count;
    if (steps >= subNum) {//如果后退太多，返回根试图控制器
        NSLog(@"确定可以pop掉那么多控制器?");
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        UIViewController *VC = self.navigationController.viewControllers[subNum - steps - 1];
        [self.navigationController popToViewController:VC animated:YES];
    }
}

/// 延迟 几秒， 后退几步
- (void)ls_backSeveralSteps:(NSInteger)steps delay:(CGFloat)delay {
    NSInteger subNum = self.navigationController.viewControllers.count;
    if (steps >= subNum) {//如果后退太多，返回根试图控制器
        NSLog(@"确定可以pop掉那么多控制器?");
        [self ls_popToRootViewControllerDelay:delay];
    } else {
        UIViewController *VC = self.navigationController.viewControllers[subNum - steps - 1];
        [self ls_popToViewController:VC delay:delay];
    }
}

/// 延迟 几秒 popToVC
- (void)ls_popToViewController:(UIViewController *)vc delay:(CGFloat)delay {
    [self ls_popToViewController:vc animated:YES delay:delay];
}
/// 延迟 几秒 popToVC
- (void)ls_popToViewController:(UIViewController *)vc animated:(BOOL)animated delay:(CGFloat)delay {
    [self performSelector:@selector(ls_popToViewController:animated:) withObject:nil afterDelay:delay];
}
/// 延迟 几秒 popToRootVC
- (void)ls_popToRootViewControllerDelay:(CGFloat)delay {
    [self performSelector:@selector(ls_popToRootViewController) withObject:nil afterDelay:delay];
}
/// 延迟 几秒 pop
- (void)ls_popViewControllerDelay:(CGFloat)delay {
    [self performSelector:@selector(ls_popViewControllerDelay) withObject:nil afterDelay:delay];
}

/// popToVC
- (void)ls_popToViewController:(UIViewController *)vc animated:(BOOL)animated {
    [self.navigationController popToViewController:vc animated:animated];
}
/// popToVC
- (void)ls_popToViewController:(UIViewController *)vc {
    [self.navigationController popToViewController:vc animated:YES];
}
/// popToRootVC
- (void)ls_popToRootViewController {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
/// pop  返回上一个页面
- (void)ls_popViewControllerDelay {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dismiss
/// dismiss 到指定的控制器
- (void)ls_dismissToVC:(Class)temVC {
    UIViewController *vc = self.presentingViewController;
    //temVC 要dimiss到的控制器
    while (![vc isKindOfClass:[temVC class]]) {
        vc = vc.presentingViewController;
        if (vc == nil) {
            break;
        }
    }
    if (vc) {
        [vc dismissViewControllerAnimated:YES completion:nil];
    } else {
        NSLog(@"没有找到要dismiss到的控制器：%@", temVC);
    }
}

/// dismiss 到根试图控制器
- (void)ls_dismissToRootVC {
    UIViewController *parentVC = self.presentingViewController;
    UIViewController *bottomVC;
    while (parentVC) {
        bottomVC = parentVC;
        parentVC = parentVC.presentingViewController;
    }
    [bottomVC dismissViewControllerAnimated:YES completion:^{
    }];
}
/// dismiss 指定 层数 控制器
- (void)dismissViewControllerWithTimes:(NSUInteger)times animated:(BOOL)flag completion:(void (^)(void))completion {
    UIViewController *rootVC = [UIApplication sharedApplication].delegate.window.rootViewController;
    
    if (rootVC) {
        while (times > 0) {
            rootVC = rootVC.presentingViewController;
            times -= 1;
        }
        [rootVC dismissViewControllerAnimated:YES completion:completion];
    }
    
    if (!rootVC.presentedViewController) {
        NSLog(@"确定能dismiss掉这么多控制器?");
    }
}

#pragma mark -
/// 从targetVc 所在的导航控制器Nav中 移除某个vc
- (void)removeCurrentVC:(UIViewController *)targetVc {
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy;
    [childsVcs removeObject:targetVc];
    targetVc.navigationController.viewControllers = childsVcs;
}
/// 从targetVc 所在的导航控制器Nav中 移除某个vc
- (void)removeCurrentVcAnimation:(UIViewController *)targetVc {
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy;
    [childsVcs removeObject:targetVc];
    [targetVc.navigationController setViewControllers:childsVcs animated:YES];
}
/// 保留 targetVc 所在导航条Nav 中的第一个和最后一个VC,其余的全部移除
- (void)retainTargetVcWhereNavFirstAndLastVC:(UIViewController *)targetVc {
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy;
    NSMutableArray *remainChildVcs = [NSMutableArray array];
    [remainChildVcs addObject:[childsVcs firstObject]];
    [remainChildVcs addObject:[childsVcs lastObject]];
    targetVc.navigationController.viewControllers = remainChildVcs;
}

#pragma mark - present
/// iOS13后，Prensent方式弹出页面时，默认的模式变为了UIModalPresentationAutomatic
/// 如果想用之前的样式
- (void)ls_presentViewController:(UIViewController *)vc completion:(void (^)(void))completion {
    
    if (@available(iOS 13.0,*)) {
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self.navigationController presentViewController:vc animated:YES completion:completion];
    } else {
        [self.navigationController presentViewController:vc animated:YES completion:completion];
    }
}


#pragma mark - tabBar
/// 更改tabBarController选中的 item
- (void)ls_changeTabBarControllerSelectItemIndex:(NSInteger)index {
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    if (self.tabBarController.viewControllers.count < index + 1) {
        NSLog(@"传入的 tabBarItem 下标越界!! (item总数量:%lu ,传入的下标:%ld)", (unsigned long)self.tabBarController.viewControllers.count, (long)index);
        index = self.tabBarController.viewControllers.count -1;
    }
    
    if ([window.rootViewController isKindOfClass:[UIWindow class]]) {
        [(UITabBarController *)window.rootViewController setSelectedIndex:index];
    } else {
        UITabBarController *tabBarCon = self.tabBarController;
        [tabBarCon setSelectedIndex:index];
    }
}

/// 选择tabBarController其他 item
- (void)ls_selectTabBarControllerOtherItemIndex:(NSInteger)index {
    if (self.tabBarController.viewControllers.count < index + 1) {
        NSLog(@"传入的 tabBarItem 下标越界!! (item总数量:%lu ,传入的下标:%ld)", (unsigned long)self.tabBarController.viewControllers.count, (long)index);
        index = self.tabBarController.viewControllers.count - 1;
    }
    UITabBarController *tabBarCon = self.tabBarController;
    tabBarCon.selectedIndex = index;
}

/// 设置tabBar角标
- (void)setTabBarBadgeWithTabBarItemIndex:(NSInteger)tabBarItemIndex badgeNum:(NSInteger)badgeNum {
    
    UITabBarController *tabBar = (UITabBarController *)self.tabBarController;
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] init];
    
    if ([self.tabBarController.selectedViewController isMemberOfClass:[self class]]) {//如果当前VC就是要设置item角标的VC
        tabBarItem = self.tabBarItem;
    }
    
    if (tabBar.tabBar.items.count > 1) {
        tabBarItem = tabBar.tabBar.items[tabBarItemIndex]; //需要设置角标的tabBarItem
    }
    
    if (badgeNum > 0) {
        tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld", badgeNum];
        
    } else {
        tabBarItem.badgeValue = nil;//清除
    }
}


#pragma mark -
/// 获取当前控制器
- (UIViewController*)ls_getCurrentViewController {
    ///获取keyWindow
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }
    //app默认windowLevel是UIWindowLevelNormal，如果不是，找到UIWindowLevelNormal的
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow *tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    id nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;
    // 如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;
    } else {
//        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }
    
    return [self ls_currentViewControllerFrom:nextResponder];
}

/// 通过递归拿到当前控制器
- (UIViewController*)ls_currentViewControllerFrom:(UIViewController *)viewController {
    // 如果传入的控制器是UIWindow,则返回 rootVC
    if ([viewController isKindOfClass:[UIWindow class]]) {
        UIWindow *window = (UIWindow *)viewController;
        return [self ls_currentViewControllerFrom:window.rootViewController];
    }
    // 如果传入的控制器是tabBar控制器,则返回选中的那个
    if ([viewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self ls_currentViewControllerFrom:tabBarController.selectedViewController];
    }
    // 如果传入的控制器是分屏控制器
    if ([viewController isKindOfClass:[UISplitViewController class]]) {
        UISplitViewController *splitVC = (UISplitViewController *)viewController;
        // splitVC.splitViewController 或者是splitVC.viewControllers.lastObject 不晓得是哪一个
        return [self ls_currentViewControllerFrom:splitVC.splitViewController];
    }
    // 如果传入的控制器是导航控制器,则返回最后一个
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)viewController;
        // nav.viewControllers.lastObject
        // nav.topViewController
        return [self ls_currentViewControllerFrom:nav.viewControllers.lastObject];
    }
    //     // 如果传入的控制器发生了modal,则就可以拿到modal的那个控制器
    if ([viewController isKindOfClass:[UIViewController class]] && viewController.presentedViewController) {
        return [self ls_currentViewControllerFrom:viewController.presentedViewController];
    }
    //否则返回本身
    return viewController;
}


#pragma mark -
///判断当前UIViewController 是否正在显示。
- (BOOL)ls_currentVCIsVisible {
    return (self.isViewLoaded && self.view.window);
}
/// 判断某个VC是否正在显示
- (BOOL)ls_judgeVCWhetherIsVisible:(UIViewController *)VC {
    return (VC.isViewLoaded && VC.view.window);
}


#pragma mark -
/// Xib 加载 View
- (UIView *)ls_loadViewFromXibName:(NSString *)viewXibName {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([viewXibName class]) owner:self options:nil] firstObject];
}

/// 加载 Xib
- (UINib *)ls_loadNibWithNibName:(NSString *)nibName {
    return [UINib nibWithNibName:NSStringFromClass([nibName class]) bundle:nil];
}




@end
