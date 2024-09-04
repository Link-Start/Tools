//
//  UINavigationController+StatusBar.m
//  qnche
//
//  Created by pengkang on 2017/7/4.
//  Copyright © 2017年 pengkang. All rights reserved.
//  https://blog.51cto.com/u_16213618/10855410




#import "UINavigationController+StatusBar.h"

@implementation UINavigationController (StatusBar)

/// 这个方法默认返回值是nil，当我们调用 setNeedsStatusBarAppearanceUpdate 的时候，
/// 系统会调用 container(容器控制器)的preferredStatusBarStyle这个方法
/// （app.window.rootViewController的preferred的方法，一般我们用UINavigationController或者UITabBarController来做container），
/// 也就是根本不会调用子控制器（我们所看到的UIViewController）的preferredStatusBarStyle方法。
///     这个时候 - (UIViewController *)childViewControllerForStatusBarStyle 就派上用场了，
///     重写这个方法，系统会调用contanier（容器控制器）就会返回当前的UIViewController，
///     从而UIViewController里面重写的方法就会调用，状态栏的颜色就会响应改变
- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.topViewController;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return [[self topViewController] preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return  UIStatusBarAnimationSlide;
}

@end
