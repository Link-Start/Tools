//
//  LSNavigationController.m
//  copyText
//
//  Created by Xcode on 16/8/17.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#pragma mark - 推荐使用第1种方法
#pragma mark - iOS隐藏导航条1px的底部横线
#pragma mark - 方法1: 找出黑线,再做处理 可以保持bar的translucent
#pragma mark - 方法2: 直接隐藏 会影响导航栏的translucent(透明)属性



#import "LSNavigationController.h"

@interface LSNavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
{
#pragma mark - iOS隐藏导航条1px的底部横线 方法1 第一步
    ///声明UIImageView变量,存储底部横线
    UIImageView *navBarHairlineImageView;
}

//@property (nonatomic, assign) BOOL shouldIgnorePushingViewControllers;


@end

@implementation LSNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //设置导航条
    [self confitNav];
#pragma mark - 右滑返回  1 添加滑动手势
    //添加手势
    [self addGestureRecognizer];
}

///添加手势
- (void)addGestureRecognizer {
    //1:需要获取系统自带滑动手势的target对象
    id target = self.interactivePopGestureRecognizer.delegate;
    //2:创建全屏滑动手势~调用系统自带滑动手势的target的action方法
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    //3:设置手势代理~拦截手势触发
    pan.delegate = self;//这里一定要设置pan.delegate = self, 不然程序会有假死的状况
    //4:给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    //5:将系统自带的滑动手势禁用
    self.interactivePopGestureRecognizer.enabled = NO;
}

/// https://www.jianshu.com/p/3e1f0ce35bd5
/// UINavigationBar
/// iOS15 从 iOS 15 开始，UINavigationBar、UIToolbar 和 UITabBar 在控制器中关联滚动视图顶部或底部时使用
/// 在iOS15中，UINavigationBar默认是透明的，有滑动时会逐渐变为模糊效果，
/// 可以通过改变UINavigationBar.scrollEdgeAppearance属性直接变为模糊效果、配置相关属性-背景、字体等
- (void)adaptationiOS15 {
    if (@available(iOS 13.0, *)) {
//        /**********************/
//        UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
//        //背景色
//        navBarAppearance.backgroundColor = [UIColor whiteColor];
//        //去掉半透明效果,
//        navBarAppearance.backgroundEffect = nil;
//        //  去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
//        navBarAppearance.shadowColor = [UIColor clearColor];
//        //字体颜色、尺寸等
//        navBarAppearance.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
//        // 带scroll滑动的页面
//        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;
//        // 常规页面
//        self.navigationController.navigationBar.standardAppearance = appearance;
//        /**********************/
        
        /**********************/
        UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
        [appearance configureWithOpaqueBackground];//重置背景和阴影颜色
        appearance.titleTextAttributes = @{
            NSFontAttributeName:[UIFont systemFontOfSize:18],//字体大小
            NSForegroundColorAttributeName:[UIColor whiteColor]//字体颜色
        };
        appearance.backgroundColor = [UIColor whiteColor];//设置导航栏背景色
        appearance.shadowImage = [self barSpeLineWithColor:[UIColor clearColor]]; //设置导航栏下边界分割线透明
        self.navigationBar.scrollEdgeAppearance = appearance;//带scroll滑动的页面
        self.navigationBar.standardAppearance = appearance;//常规页面
        
        /**********************/
    }
    else {
        //中间标题 字体设置为黑色 (查看图层: nav 默认的中间标题 字号17，黑色,粗体)
        NSDictionary *dic = @{
            NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
            NSForegroundColorAttributeName:[UIColor blackColor]
        };
        self.navigationBar.titleTextAttributes = dic;
    }
}

/***
 //https://www.jianshu.com/p/acb0d1d3efe9
 不透明导纯色航栏：
     //navigation标题文字颜色
     NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor blackColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]};
     if (@available(iOS 15.0, *)) {
         UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
         barApp.backgroundColor = [UIColor whiteColor];
         barApp.shadowColor = [UIColor whiteColor];
         barApp.titleTextAttributes = dic;
         self.navigationController.navigationBar.scrollEdgeAppearance = barApp;
         self.navigationController.navigationBar.standardAppearance = barApp;
     }else{
         //背景色
         self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
         self.navigationController.navigationBar.titleTextAttributes = dic;
         [self.navigationBar setShadowImage:[UIImage new]];
         [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
     }
     //不透明
     self.navigationController.navigationBar.translucent = NO;
     //navigation控件颜色
     self.navigationController.navigationBar.tintColor = [UIColor blackColor];
 
 
 
 透明导航栏:
     //navigation标题文字颜色
     NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:18]};
     if (@available(iOS 15.0, *)) {
         UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
         barApp.backgroundColor = [UIColor clearColor];
         barApp.titleTextAttributes = dic;
         self.navigationController.navigationBar.scrollEdgeAppearance = nil;
         self.navigationController.navigationBar.standardAppearance = barApp;
     }else{
         self.navigationController.navigationBar.titleTextAttributes = dic;
         [self.navigationBar setShadowImage:[UIImage new]];
         [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
     }
     //透明
     self.navigationController.navigationBar.translucent = YES;
     //navigation控件颜色
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 
 /////////////////////////////////--------------------->/////////////////////////////////
 之前有人遇到导航栏隐藏的返回按钮失效问题，备注里面也已经解决，并做出说明
 [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-200, 0) forBarMetrics:UIBarMetricsDefault];
     // iOS 15适配
     if (@available(iOS 13.0, *)) {
         UINavigationBarAppearance *appearance = [[UINavigationBarAppearance alloc] init];
         [appearance setBackgroundColor:[UIColor whiteColor]];
         // UINavigationBarAppearance 会覆盖原有的导航栏设置，这里需要重新设置返回按钮隐藏，不隐藏可注释或删掉
         appearance.backButtonAppearance.normal.titlePositionAdjustment = UIOffsetMake(-200, 0);

         [[UINavigationBar appearance] setScrollEdgeAppearance: appearance];
         [[UINavigationBar appearance] setStandardAppearance:appearance];
     }
 **/


///设置导航条
- (void)confitNav {
    //设置板的背景图片
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部"] forBarMetrics:UIBarMetricsDefault];
    // 设置navigationBar的背景颜色，根据需要自己设置
    //    self.navigationBar.barTintColor = [UIColor clearColor];//导航栏背景
    //设置左右字体的颜色
    self.navigationBar.tintColor = [UIColor whiteColor];//着色，让返回栏图片渲染为白色
    //中间标题 字体设置为白色
    NSDictionary *dic = @{
        NSForegroundColorAttributeName:[UIColor whiteColor]
    };
    //中间标题 字体设置
    // 查看图层: nav 默认的中间标题 字号17，黑色,粗体
//    NSDictionary *dic = @{
//        NSFontAttributeName:[UIFont boldSystemFontOfSize:17],
//        NSForegroundColorAttributeName:[UIColor blackColor]
//    };
    self.navigationBar.titleTextAttributes = dic;
    
    //打开毛玻璃效果
    self.navigationBar.translucent = YES;//透明
    
#pragma mark - iOS隐藏导航条1px的底部横线 方法1 第二步
    //    navBarHairlineImageView = [self findHairlineImageViewUnder:self.navigationBar];
    
        
    [self adaptationiOS15]; //适配iOS15
}
#pragma mark - iOS隐藏导航条1px的底部横线 方法1 第三步
///实现找出底部横线的函数
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

//在页面出现的时候就将黑线隐藏起来
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
#pragma mark - iOS隐藏导航条1px的底部横线 方法1 第四步
    navBarHairlineImageView.hidden = YES;
    
#pragma mark - iOS隐藏导航条1px的底部横线 方法2 第一步
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

//在页面消失的时候就让navigationbar还原样式
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
#pragma mark - iOS隐藏导航条1px的底部横线 方法1 第五步
    navBarHairlineImageView.hidden = NO;
    
#pragma mark - iOS隐藏导航条1px的底部横线 方法2 第二步
    //    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:nil];
}

#pragma mark - iOS隐藏导航条1px的底部横线 方法3
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
- (UIImage *)barSpeLineWithColor:(UIColor *)color{
    
    CGRect rect = CGRectMake(0, 0, kLS_ScreenWidth, 0.5);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

///重写push方法 push的控制器隐藏tabbar
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) {
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
        
        //FIXME:这样做防止主界面卡顿时，导致一个ViewController被push多次、
        if ([[self.childViewControllers lastObject] isKindOfClass:[viewController class]]) {
            return;
        }
    }
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 右滑返回  2  判断(方法1)
//是否触发手势
//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
//
//    //当当前控制器是根控制器了,那么就不接收触摸事件,只有当不是根控制器时才需要接收事件.
//    return self.childViewControllers.count > 1;
//}

#pragma mark - 右滑返回  2  判断(方法2)
//防止scrollView手势覆盖侧滑手势[scrollView.panGestureRecognizerrequireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
//iOS自定义全屏返回与tableView左划删除手势冲突解决
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (self.cannotRightSlipBack) {
        return NO;
    }
    
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        if (self.childViewControllers.count <= 1) {
            // ==1表示用户在根控制器界面，就不需要触发滑动手势，
            return NO;
        }
        
        if (self.interactivePopGestureRecognizer &&
            [[self.interactivePopGestureRecognizer.view gestureRecognizers] containsObject:gestureRecognizer]) {
            
            CGPoint tPoint = [(UIPanGestureRecognizer *)gestureRecognizer translationInView:gestureRecognizer.view];
            
            if (tPoint.x >= 0) {
                CGFloat y = fabs(tPoint.y);
                CGFloat x = fabs(tPoint.x);
                CGFloat af = 30.0f/180.0f * M_PI;
                CGFloat tf = tanf(af);
                if ((y/x) <= tf) {
                    return YES;
                }
                return NO;
                
            }else{
                return NO;
            }
        }
    }
    
    return YES;
}

///解决ios 11 下，系统imagePicker 取消按钮不灵敏问题
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([UIDevice currentDevice].systemVersion.floatValue < 11) {
        return;
    }
    if ([viewController isKindOfClass:NSClassFromString(@"PUPhotoPickerHostViewController")]) {
        [viewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.frame.size.width < 42) {
                [viewController.view sendSubviewToBack:obj];
                *stop = YES;
            }
        }];
    }
}
//
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
////    UIBarButtonItem *backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backBarButtonItemAction)];
////    viewController.navigationItem.backBarButtonItem = backBarButtonItem;
//}




/////设置状态栏的样式
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    return self.topViewController;
//}


//- (void)backBarButtonItemAction {
//    [self popViewControllerAnimated:YES];
//}


#pragma mark - ...
//// 做显示的操作
//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // self.viewControllers[0]表示根控制器
//    if ([viewController isEqual:[self.viewControllers objectAtIndex:0]]) {
//        viewController.hidesBottomBarWhenPushed = NO;
//    }
//}
//
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // push过程中隐藏tabBar
//    if (self.viewControllers.count > 0 && ![viewController isEqual:[self.viewControllers objectAtIndex:0]]) {
//        viewController.hidesBottomBarWhenPushed = YES;
//    }
//    bool remoteConfigOptimizePushTransition = NO;
//    // 当前界面显示完成的时候则将 shouldIgnorePushingViewControllers 置为NO.
//    // 解决问题.避免同时push相同的界面导致自身添加自身的崩溃.
//    // 控制 push 时的方向
//    if (!self.shouldIgnorePushingViewControllers) {
//        if (remoteConfigOptimizePushTransition && animated) {
//            CATransition *animation = [CATransition animation];
//            animation.duration = 0.3f;
//            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//            animation.type = kCATransitionPush;
//            animation.subtype = [RTLHelper isRTL] ? kCATransitionFromLeft : kCATransitionFromRight;
//            [self.navigationController.view.layer addAnimation:animation forKey:nil];
//            [self.view.layer addAnimation:animation forKey:nil];
//            [super pushViewController:viewController animated:NO];
//            return;
//        }
//        [super pushViewController:viewController animated:animated];
//    }
//
//    self.shouldIgnorePushingViewControllers = YES;
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    self.shouldIgnorePushingViewControllers = NO;
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 屏幕旋转(如果UINavigationController是根视图控制器,然后在需要特殊设置的控制器内,重写这几个方法即可.)
-(BOOL)shouldAutorotate {//[self.viewControllers lastObject]是获取当前导航的栈顶的控制器
    return [[self.viewControllers lastObject] shouldAutorotate];
}
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
