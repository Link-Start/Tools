





///iOS获取当前的ViewController
///从Windows中获取当前控制器
- (UIViewController *)getCurrentVC {

    UIViewController *result = nil;
    ///获取keyWindow
    UIWindow *window = [UIApplication sharedApplication].delegate.window;

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
    id  nextResponder = nil;
    UIViewController *appRootVC = window.rootViewController;

    // 如果是present上来的appRootVC.presentedViewController 不为nil
    if (appRootVC.presentedViewController) {
        nextResponder = appRootVC.presentedViewController;

    } else {
        NSLog(@"===%@",[window subviews]);
        UIView *frontView = [[window subviews] objectAtIndex:0];
        nextResponder = [frontView nextResponder];
    }

    //如果是Window
    if ([nextResponder isKindOfClass:[UIWindow class]]) {
        nextResponder = self.window.rootViewController;

    }

    if ([nextResponder isKindOfClass:[UITabBarController class]]) {//如果是tabBarController
        UITabBarController *tabbar = (UITabBarController *)nextResponder;
        UINavigationController *nav = (UINavigationController *)tabbar.viewControllers[tabbar.selectedIndex];

        //UINavigationController * nav = tabbar.selectedViewController ; 上下两种写法都行
        result = nav.childViewControllers.lastObject;

    } else if ([nextResponder isKindOfClass:[UINavigationController class]]) { //如果是navController

        UIViewController *nav = (UIViewController *)nextResponder;
        result = nav.childViewControllers.lastObject;

    } else {
        result = nextResponder;
    }
    return result;
}





//自定义弹出框显示动画
///视图展示
- (void)show {
    
    UIViewController *currentController = [self currentController];
    [currentController addChildViewController:self];
    [currentController.view addSubview:self.view];
    //    [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.edges.insets(UIEdgeInsetsZero);
    //    }];
    
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(0.8);
    animation.toValue = @(1);
    animation.duration = 0.15;
    animation.autoreverses = NO;
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    
    //    [self.containerView.layer addAnimation:animation forKey:@"animation"];
}


//如果点击弹窗视图以外的部分 隐藏弹窗
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.tableView]) {
        [self dismissWithCompletion:nil];
    }
}






#pragma mark - 2 拿到当前正在显示的控制器，不管是push进去的，还是present进去的都能拿到

- (UIViewController *)getVisibleViewControllerFrom:(UIViewController*)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self getVisibleViewControllerFrom:[((UINavigationController*) vc) visibleViewController]];
    }else if ([vc isKindOfClass:[UITabBarController class]]){
        return [self getVisibleViewControllerFrom:[((UITabBarController*) vc) selectedViewController]];
    } else {
        if (vc.presentedViewController) {
            return [self getVisibleViewControllerFrom:vc.presentedViewController];
        } else {
            return vc;
        }
    }
}




