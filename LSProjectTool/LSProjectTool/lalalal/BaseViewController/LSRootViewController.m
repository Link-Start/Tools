//
//  LSRootViewController.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/25.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "LSRootViewController.h"

@interface LSRootViewController ()

@end

@implementation LSRootViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //设置导航栏下1px线的颜色 -- 测试可用
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

#pragma mark - 返回
//返回方法
- (void)ls_backButtonAction {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

///返回指定控制器
- (void)backOutToVC:(UIViewController *)VC {
    for (UIViewController *tempVC in self.navigationController.viewControllers) {
        if ([tempVC isKindOfClass:[VC class]]) {
            [self.navigationController popToViewController:VC animated:YES];
        }
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
//是否自动旋转,返回YES可以自动旋转
- (BOOL)shouldAutorotate {
    // 是否支持旋转
    return NO;
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}
//这个是返回优先方向\默认进去类型
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

//只要日志没有打印出来，说明内存得不到释放，就需要学会分析内存引用问题了
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"进入控制器：%@", [[self class] description]);
}
- (void)dealloc {
    //移除通知
    NSLog(@"控制器被dealloc: %@", [[self class] description]);
    NSLog(@"%s", __func__);
}


@end