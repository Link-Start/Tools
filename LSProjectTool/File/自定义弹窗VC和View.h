//
// 自定义弹窗VC和View.h
// LSProjectTool
//
// reated by 刘晓龙 on 2021/8/13.
// Copyright © 2021 Link-Start. All rights reserved.
//



#ifndef _____VC_View_h
#define _____VC_View_h

封装自定义弹窗有一下几种：
1 直接在当前视图控制器上放view(简直6翻了)
2 present到一个新的半透明视图控制器(类似UIAlertViewController，也就是说咱们要用的就是个控制器而不是个View了)
3 使用一个windowLevel更高的UIWindow(UIAlertView就是这种)
4 放在keyWindow上(使用这种方式有隐患，点击查看详情)
5 放在[UIApplication sharedApplication] delegate] window]上




// View
#pragma mark ------------------- - View

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:self.bgView]) {
        [self exitToBottom];
    }
}

//1 ********************************
- (void)show {
    
    [[UIApplication sharedApplication].delegate.window addSubview:self.view];
    [self.currentVC addChildViewController:self];
    
    [self fadeInAnimate];
}
//2 ********************************
- (void)show:(UIViewController *)VC {
    
    AppDelegate *del =  (AppDelegate *)[UIApplication sharedApplication].delegate;
    [del.window.rootViewController addChildViewController:self];
    [del.window.rootViewController.view addSubview:self.view];
    
    [self fadeInAnimate];
}


//3 ******************************** 自定义 UIWindow
@property (nonatomic, strong) UIWindow *popupWindow;

- (void)show {
    
    MainNavController *navIndex = [[MainNavController alloc] initWithRootViewController:self];
    [navIndex setNavigationBarHidden:YES animated:NO];
    self.popupWindow.rootViewController = navIndex;
    [self fadeInAnimate];
}

- (UIWindow *)popupWindow {
    if (!_popupWindow) {
        
        _popupWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _popupWindow.windowLevel = UIWindowLevelStatusBar-1;//在状态栏下一层,不会遮住导航栏
       // _popupWindow.rootViewController = [[UIViewController alloc] init];
        [_popupWindow makeKeyAndVisible];
    }
    return _popupWindow;
}

//https://www.jianshu.com/p/9373a7e0e34e
//UIKIT_EXTERN const UIWindowLevel UIWindowLevelNormal;                 0
//UIKIT_EXTERN const UIWindowLevel UIWindowLevelAlert;                  2000
//UIKIT_EXTERN const UIWindowLevel UIWindowLevelStatusBar;              1000
//windowLevel数值越大的显示在窗口栈的越上面
//显示层的优先级 为： UIWindowLevelAlert > UIWindowLevelStatusBar > UIWindowLevelNormal
//系统给UIWindow默认的windowLevel为UIWindowLevelNorma


///销毁自定义UIWindow
- (void)dimissPopupWindow {
    [self.popupWindow removeFromSuperview];
    [self.popupWindow removeAllSubviews];
    [self.popupWindow resignKeyWindow];
    self.popupWindow.windowLevel = -1000;
    self.popupWindow.hidden = YES;
    [self.popupWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    self.popupWindow = nil;
}

//3 ********************************

/**
 *  出场动画
 */
- (void)fadeInAnimate {
    
    self.view.alpha = 0;
    [UIView animateWithDuration:0.6*0.2 animations:^{
        self.view.alpha = 1;
    }];
    
    CGPoint startPosition = self.bgView.layer.position;
    self.bgView.layer.position = CGPointMake(startPosition.x, -self.bgView.height*0.5);
    
    @weakify(self);
    //Duration: 动画持续时间
//delay: 动画执行延时
//usingSpringWithDamping: 震动效果，范围 0.0f~1.0f，数值越小,「弹簧」的震动效果越明显.当“dampingRatio”为1时，动画将平滑地减速到其最终模型值，而不会振荡
//initialSpringVelocity: 初始速度，数值越大一开始移动越快
//options: 动画的过渡效果
    [UIView animateWithDuration:0.6
                          delay:0
         usingSpringWithDamping:0.65
          initialSpringVelocity:1.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
        @strongify(self);
        self.bgView.layer.position = startPosition;
    } completion:nil];
}


- (void)exitToBottom {

//     __weak __typeof(self)weakSelf = self;
    @weakify(self);
    [UIView animateWithDuration:0.3 animations:^{
        @strongify(self);
        self.bgView.transform = CGAffineTransformTranslate(self.bgView.transform, 0, kScreenHeight);
    } completion:^(BOOL finished) {
        @strongify(self);
        self.bgView.alpha = 0;
        [self.view removeAllSubviews];
        [self.view removeFromSuperview]; //移除视图
        [self removeFromParentViewController];
    }];
}



#pragma mark ------------------- - VC

//UIModalTransitionStyleCoverVertical //垂直向上替换， default
//UIModalTransitionStyleFlipHorizontal //旋转
//UIModalTransitionStyleCrossDissolve 溶解
//UIModalTransitionStylePartialCurl //向上部分卷曲
//navigationC.modalPresentationStyle = UIModalPresentationStyle.formSheet

//使用方法
//显示
- (void)show {
    AlertVC *alert = [[AlertVC alloc]init];
    alert.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    alert.modalTransitionStyle = UIModalTransitionStyleCoverVertical
//    alreadySetPwd.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController presentViewController:alert animated:YES completion:nil];
}
//关闭
- (void)close {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

注意：AlertVC 的view的背景色设置
[[UIColor blackColor] colorWithAlphaComponent:0.2];



#endif /* _____VC_View_h */
