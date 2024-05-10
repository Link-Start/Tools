//
//  导航栏Nav.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/3/22.
//  Copyright © 2024 Link-Start. All rights reserved.
//
/// 导航栏

#ifndef ___Nav_h
#define ___Nav_h


iOS导航栏的正确隐藏方式(解决右滑返回上一层页面时导航栏出现空白的问题)
https://blog.csdn.net/a563096676/article/details/136060011


// A:隐藏导航栏，  B:显示导航栏，
// A-- push --> B  ，
// B--pop-->A  或者  B 侧滑手势返回 A
// 导航栏上面会出现一层空白


/************** 方法一： **************/
// 用动画的方式隐藏导航栏,这样在使用滑动返回手势的时候效果最好，这样做有一个缺点就是在切换tabBar的时候有一个导航栏向上消失的动画.
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

// !!!! 测试可用， 这两个方法要同时写在 A 控制器，
///     同时，B 要设置view的背景色 和 导航条颜色(不能为clearColor) ，导航条不透明(.translucent=NO)
///     .translucent=YES时，顶部会出现空白，并且会有卡顿



/************** 方法二： **************/

// 设置self为导航控制器的代理,实现代理方法,在将要显示控制器中设置导航栏隐藏和显示,
// 使用这种方式不仅完美切合滑动返回手势,同时也解决了切换tabBar的时候,导航栏动态隐藏的问题。最后要记得在控制器销毁的时候把导航栏的代理设置为nil。

@interface HomeViewController () <UINavigationControllerDelegate>

@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 设置导航控制器的代理为self
    self.navigationController.delegate = self;
}
#pragma mark - UINavigationControllerDelegate
// 将要显示控制器
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 判断要显示的控制器是否是要隐藏的控制器
    BOOL isHome = [viewController isKindOfClass:[self class]];
    [self.navigationController setNavigationBarHidden:isHome animated:YES];
}
- (void)dealloc {
    self.navigationController.delegate = nil;
}



/************** 方法三： **************/

// 主要是针对A隐藏Nav, A push 到B，B也需要隐藏Nav的这种情况 主要是在自定义UINavigationController文件内进行操作的

// 自定义UINavigationController

#import "NavigationController.h"
#import "HomeViewController.h"
#import "HomeViewController_two.h"

@interface NavigationController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>
@end

@implementation NavigationController

- (void)viewDidLoad {

    [super viewDidLoad];
    self.delegate = self;
    // 设置全屏滑动返回
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    self.interactivePopGestureRecognizer.enabled = NO;
}
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (self.viewControllers.count > 0) {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    [super pushViewController:viewController animated:animated];
}
#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {

    // 判断如果是需要隐藏导航控制器的类，则隐藏
    BOOL isHideNav = ([viewController isKindOfClass:[HomeViewController class]] ||
                      [viewController isKindOfClass:[HomeViewController_two class]]);
    //setNavigationBarHidden:YES设置这行代码后会导致Nav的滑动返回手势失效，这也就是为什么前面我们在自定义导航的时候需要设置全屏滑动返回了
    [self setNavigationBarHidden:isHideNav animated:YES];
}




#endif /* ___Nav_h */
