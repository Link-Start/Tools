//
//  LSRootViewController.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/25.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "LSRootViewController.h"
#import "LSTabBarController.h"

@interface LSRootViewController ()

@end

@implementation LSRootViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //设置导航条透明
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
    //                                                  forBarMetrics:UIBarMetricsDefault];
    //    self.navigationController.navigationBar.shadowImage = [UIImage new];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏下1px线的颜色 -- 测试可用(通过颜色创建图片)
    //    [self.navigationController.navigationBar setShadowImage:[UIImage imageCreateImageWithColor:UIColorFromRGB(0xe8e8e8) size:CGSizeMake(kLS_ScreenWidth, 0.5)]];
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    //自定义返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        //    返回按钮
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(ls_backButtonAction)];
        
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

- (void)createBackBtn {
    //1.初始化按钮UIButton
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //1.2设置位置
    leftBtn.frame = CGRectMake(0, 0, 25,25);
    //1.3添加背景颜色
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    //1.4监听
    [leftBtn addTarget:self action:@selector(ls_backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.adjustsImageWhenHighlighted = NO;
    //2 初始化按钮UIBarButtonItem
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    //2.2创建UIBarButtonSystemItemFixedSpace
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    //2.3将宽度设为负值
    spaceItem.width = -8;
    //2.4将两个BarButtonItem都返回给NavigationItem
    self.navigationItem.leftBarButtonItems = @[spaceItem,leftBarBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///系统侧滑返回按钮
- (void)willMoveToParentViewController:(UIViewController*)parent{
    [super willMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
}
- (void)didMoveToParentViewController:(UIViewController*)parent{
    [super didMoveToParentViewController:parent];
    NSLog(@"%s,%@",__FUNCTION__,parent);
    if(!parent){
        NSLog(@"页面pop成功了");
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - 设置状态栏
//动态更新状态栏颜色
- (void)setLs_statusBarStyle:(UIStatusBarStyle)ls_statusBarStyle {
    _ls_statusBarStyle = ls_statusBarStyle;
    [self setNeedsStatusBarAppearanceUpdate];
}

//设置样式
//// ios 13.0 之后，这个方法已经失效了
// [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//- (UIStatusBarStyle)preferredStatusBarStyle {
//    //1
//    if (@available(iOS 13.0, *)){
//        return UIStatusBarStyleDarkContent;
//    }
//    return UIStatusBarStyleDefault;
//    //2
//    return (@available(iOS 13.0, *) ? UIStatusBarStyleDarkContent : UIStatusBarStyleDefault);
//    //3
////可以使用预编译命令
//#if defined(__IPHONE_13_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_13_0
//if (@available(iOS 13.0, *)) {
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDarkContent];
//}else{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//}
//#else
//[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//#endif
//}
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//#ifdef __IPHONE_13_0
//    if (@available(iOS 13.0, *)) {
//        [self preferredStatusBarUpdateAnimation];
////        [self changeStatus];
//    }
//#endif
//}
//- (UIStatusBarStyle)preferredStatusBarStyle {
//#ifdef __IPHONE_13_0
//    if (@available(iOS 13.0, *)) {
//        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            return UIStatusBarStyleLightContent;
//        }
//    }
//#endif
//    return UIStatusBarStyleDefault;
//}
//- (void)changeStatus {
//#ifdef __IPHONE_13_0
//    if (@available(iOS 13.0, *)) {
//        if (UITraitCollection.currentTraitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
//            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
//            return;
//        }
//    }
//#endif
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
//}
//设置样式
- (UIStatusBarStyle)preferredStatusBarStyle{
    return _ls_statusBarStyle;
}
//设置是否隐藏
- (BOOL)prefersStatusBarHidden {
    return NO;
}
//设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark -  屏幕旋转(如果当前VC是根视图控制器直接设置下面的方法)
//需要在支持除竖屏以外方向的页面重新下边三个方法
// 最好在需要支持旋转的VC 中重写这个方法，以防止有其他nav,vc,tabBarCon的分类中有重写这三个方法导致 横屏支持不可用
//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    // 是否支持旋转
    return YES;         //需要支持横屏的VC中这里设置为YES/NO 好像没什么影响
}
//支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.navigationController.topViewController preferredInterfaceOrientationForPresentation];
}
/************************ 屏幕旋转 ********************************/

//只要日志没有打印出来，说明内存得不到释放，就需要学会分析内存引用问题了
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"进入控制器：%@", [[self class] description]);
}

// https://www.jianshu.com/p/360f2bb06afa，
//在UIViewController的category中重写的dealloc方法，会导致键盘上的控制器UIInputWindowController,UICompatibilityInputViewController过度释放而崩溃
// 解决办法： 去掉category中的dealloc方法（使用方法交换后仍然会过度释放）。
- (void)dealloc {
    //移除通知
    NSLog(@"控制器被dealloc: %@", [[self class] description]);
    NSLog(@"%s", __func__);
    
    
    //KVO没有添加监听的情况下移除观察者导致崩溃
//    @try {
//        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
//
//    }
//    @catch (NSException *exception) {
//    }
}


@end
