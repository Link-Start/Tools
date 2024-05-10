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
    //2:创建全屏滑动手势~调用系统自带滑动手势的target的action方法,
    // NSSelectorFromString(@"handleNavigationTransition:")
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];//
    //3:设置手势代理~拦截手势触发
    pan.delegate = self;//这里一定要设置pan.delegate = self, 不然程序会有假死的状况
    //4:给导航控制器的view添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    //5:将系统自带的滑动手势禁用
    self.interactivePopGestureRecognizer.enabled = NO;
    
//    //处理全屏返回
//    UIGestureRecognizer *systemGes = self.interactivePopGestureRecognizer;
//    id target =  systemGes.delegate;
//    self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:target action:NSSelectorFromString(@"handleNavigationTransition:")];
//    [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
//    self.panGesture.delegate = self;
//    systemGes.enabled = NO;
}

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

/// https://www.jianshu.com/p/3e1f0ce35bd5
/// iOS15更新之后 导航条突然就白了,如果恰巧你的页面上有 ScorllView 的滑动视图的话,那么向上滑动时,你的导航栏又变了正常设置的颜色
/// UINavigationBar
/// iOS15 从 iOS 15 开始，UINavigationBar、UIToolbar 和 UITabBar 在控制器中关联滚动视图顶部或底部时使用
/// 在iOS15中，UINavigationBar默认是透明的，有滑动时会逐渐变为模糊效果，
/// 可以通过改变UINavigationBar.scrollEdgeAppearance属性直接变为模糊效果、配置相关属性-背景、字体等
- (void)adaptationiOS15 {
    if (@available(iOS 13.0, *)) {
//        /**********************/
//        UINavigationBarAppearance *navBarAppearance = [[UINavigationBarAppearance alloc] init];
//        // 背景色
//       //[backgroundColor:注意这个属性在backgroundImage下(在某个界面单独设置导航栏颜色,直接使用backgroundColor无效,被backgroundImage遮住了)]
//        //如果设置导航栏透明 ，也会无效。原因：新的导航栏 在加入 large 模式之后 apple 会对普通模式的 nav 的 _UIbarBackground 进行一次 alpha = 1 的设置。
//        //解决方法：
//        if (@available(iOS 15.0, *)) {//设置导航栏透明
//            self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
//        }
//        navBarAppearance.backgroundColor = [UIColor whiteColor];
//        // 去掉半透明效果,backgroundEffect：基于backgroundColor或backgroundImage的磨砂效果
//        navBarAppearance.backgroundEffect = nil;
//        // 去除导航栏阴影（如果不设置clear，导航栏底下会有一条阴影线）
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
            NSFontAttributeName:[UIFont fontWithName:@".SFUIText-Semibold" size:17],//字体大小
            NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]//字体颜色
        };
        appearance.backgroundColor = [UIColor whiteColor];//设置导航栏背景色
        appearance.shadowImage = [self barSpeLineWithColor:[UIColor clearColor]]; //设置导航栏下边界分割线透明
//        appearance.shadowColor = [UIColor clearColor]; //设置导航栏下边界分割线透明，(底部分割线阴影颜色)
        self.navigationBar.scrollEdgeAppearance = appearance;//带scroll滑动的页面
        self.navigationBar.standardAppearance = appearance;//常规页面.描述导航栏以标准高度
        
        /**********************/
    }
    else {
        //中间标题 字体设置为黑色 (查看图层: nav 默认的中间标题 字号17，黑色,粗体)
        NSDictionary *dic = @{
            NSFontAttributeName:[UIFont fontWithName:@".SFUIText-Semibold" size:17],
            NSForegroundColorAttributeName:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]
        };
        self.navigationBar.titleTextAttributes = dic;
    }
}

/***
 
 // https://www.jianshu.com/p/acb0d1d3efe9
 // https://www.cnblogs.com/eric-zhangy1992/p/15571539.html
 不透明导纯色航栏：
     //navigation标题文字颜色
     NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor blackColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:18 weight:UIFontWeightMedium]};
     if (@available(iOS 15.0, *)) {
         UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
         barApp.backgroundColor = [UIColor whiteColor];
         barApp.shadowColor = [UIColor whiteColor];
         barApp.titleTextAttributes = dic;
         self.navigationController.navigationBar.scrollEdgeAppearance = barApp;//带scroll滑动的页面
         self.navigationController.navigationBar.standardAppearance = barApp;//常规页面。描述导航栏以标准高度
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
 // 因为 scrollEdgeAppearance = nil ，
 // 如果当前界面中使用可了 ScrollView ，当 ScrollView 向上滚动时 scrollEdgeAppearance 会默认使用 standardAppearance。
 // 因此 backgroundEffect 和 shadowColor 也要显式设置为 nil ，防止 backgroundEffect、shadowColor 出现变成有颜色
 
     //navigation标题文字颜色
     NSDictionary *dic = @{NSForegroundColorAttributeName : [UIColor whiteColor],
                           NSFontAttributeName : [UIFont systemFontOfSize:18]};
     if (@available(iOS 15.0, *)) {
         UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
         [barApp configureWithOpaqueBackground];//重置背景和阴影颜色
         barApp.backgroundColor = [UIColor clearColor];//设置导航栏背景色
         barApp.titleTextAttributes = dic;
         barApp.backgroundEffect = nil;//
         barApp.shadowColor = nil;//
         self.navigationController.navigationBar.scrollEdgeAppearance = nil;//带scroll滑动的页面
         self.navigationController.navigationBar.standardAppearance = barApp;//常规页面。描述导航栏以标准高度
     }else{
         self.navigationController.navigationBar.titleTextAttributes = dic;
         [self.navigationBar setShadowImage:[UIImage new]];
         [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
     }
     //透明
     self.navigationController.navigationBar.translucent = YES;
     //navigation控件颜色
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
 
 透明导航栏时动态修改颜色：
    -(Void)setNavigationBarBackgroundColor:(UIColor *)color {
         if (@available(iOS 15.0, *)) {
             self.navigationController.navigationBar.standardAppearance.backgroundColor = color;
             self.navigationController.navigationBar.scrollEdgeAppearance.backgroundColor = color;
         }else{
             self.navigationController.navigationBar.barTintColor = color;
         }
     }
 
 
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

#pragma mark - 设置导航栏 不透明
/// 设置导航栏不透明
- (void)setNavOpaque {
    //navigation标题文字颜色
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrDict[NSFontAttributeName] = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];//重置背景和阴影颜色
        appearance.backgroundColor = [UIColor whiteColor];//设置导航栏背景色
        appearance.shadowColor = [UIColor clearColor];//设置导航栏下边界分割线透明
        appearance.titleTextAttributes = attrDict;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;//带scroll滑动的页面
        self.navigationController.navigationBar.standardAppearance = appearance;//常规页面。描述导航栏以标准高度
        
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0].hidden = YES;
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
        
        UIView *barBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = 0;
        }
    } else {
        self.navigationController.navigationBar.titleTextAttributes = attrDict;
        [self.navigationBar setShadowImage:[UIImage new]];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
            //背景色
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        
//        // 设置导航栏imageView子视图的alpha。navigationBar上的subviews的第一个视图即为我们要的子视图
//        // iOS11的导航栏视图结构发生了变化。需要做个判断
//        if (@available(iOS 11.0, *)) {
////            [self.navigationController.navigationBar.subviews.firstObject.subviews objectAtIndex:1].alpha = 0;
        /////            [[[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0] setHidden:YES];
//            [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
//        } else {
//            // 设置导航栏imageView子视图的alpha。
//            // navigationBar上的subviews的第一个视图即为我们要的子视图
//            self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
//        }
    }
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    //navigation控件颜色
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
}

#pragma mark - 设置导航栏 透明

////背景色，translucent=NO，其他设置不变，改变这里的颜色，导航栏颜色就会变，变色区域高度64/。
// self.navigationController.navigationBar.barTintColor = [UIColor clearColor];//
// .barTintColor = [UIColor clearColor];.translucent=YES; 顶部导航栏位置会出现一块64的黑色区域，
// .barTintColor = [UIColor clearColor];.translucent=NO;  顶部导航栏位置会显示 window.backgroundColor的颜色
// .barTintColor = 其他颜色;.translucent=NO; 导航栏显示设置的颜色
// .barTintColor = 其他颜色;.translucent=YES; 导航栏显示白色
// .barTintColor = [[UIColor redColor] colorWithAlphaComponent:0.1];.translucent=NO; 小数0~1,无论怎么改都只显示设置的颜色，不会透明什么的
// .barTintColor = [[UIColor redColor] colorWithAlphaComponent:0.1];.translucent=YES; 小数0~1,无论怎么改都只显示白色


/// 设置导航栏透明
- (void)setNavClear {
    //navigation标题文字颜色
    NSMutableDictionary *attrDict = [NSMutableDictionary dictionary];
    attrDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    attrDict[NSFontAttributeName] = [UIFont systemFontOfSize:18];

    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = [UINavigationBarAppearance new];
        [barApp configureWithOpaqueBackground];//重置背景和阴影颜色
        barApp.backgroundColor = [UIColor clearColor];//设置导航栏背景色
        barApp.backgroundEffect = nil;//
        barApp.shadowColor = nil;//设置导航栏下边界分割线透明
        barApp.titleTextAttributes = attrDict;
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;//带scroll滑动的页面
        self.navigationController.navigationBar.standardAppearance = barApp;//常规页面。描述导航栏以标准高度
        
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0].hidden = YES;
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
        
        UIView *barBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = 0;
        }
    } else {
        self.navigationController.navigationBar.titleTextAttributes = attrDict;
        [self.navigationBar setShadowImage:[UIImage new]];
        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        //背景色，translucent=NO，其他设置不变，改变这里的颜色，导航栏颜色就会变，变色区域高度64/。
        self.navigationController.navigationBar.barTintColor = [UIColor clearColor];//
        // navigationBar.backgroundColor:是Bar的颜色，变色区域高度只有44。
        //  barTintColor颜色设置为[UIColor clearColor]，translucent=YES，backgroundColor的颜色才会显示出来，而且只有44的高度
//        self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];//
        
        // 设置导航栏imageView子视图的alpha。
        // navigationBar上的subviews的第一个视图即为我们要的子视图
        // iOS11的导航栏视图结构发生了变化。需要做个判断
        if (@available(iOS 11.0, *)) {
//            [[[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0] setHidden:YES];
//            [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
//            //            [self.navigationController.navigationBar.subviews.firstObject.subviews objectAtIndex:1].alpha = 0;
            
            UIView *barBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
            for (UIView *view in barBackgroundView.subviews) {
                view.alpha = 0;
            }
        } else {
            // 设置导航栏imageView子视图的alpha。
            // navigationBar上的subviews的第一个视图即为我们要的子视图
            self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
        }
    }
    // 透明，打开毛玻璃效果，view会从VC顶部开始
    self.navigationController.navigationBar.translucent = YES;
    //navigation控件颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
}
/// 透明导航栏时动态修改颜色：
- (void)setNavigationBarBackgroundColor:(UIColor *)color {
    if (@available(iOS 15.0, *)) {
        self.navigationController.navigationBar.standardAppearance.backgroundColor = color;
        self.navigationController.navigationBar.scrollEdgeAppearance.backgroundColor = color;
    } else {
        self.navigationController.navigationBar.barTintColor = color;
    }
}

// 用于动态改变导航栏透明度
// 进去视图的时候，导航栏是透明的，随着tableview的滑动，导航栏渐渐变得不透明，有个颜色的渐变效果。可以在 scrollViewDidScroll:  中设置 代码如下：
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGFloat minAlphaOffset = -64;
//    CGFloat maxAlphaOffset = 500;
//    CGFloat offset = scrollView.contentOffset.y;
//    CGFloat alpha = (offset - minAlphaOffset)/(maxAlphaOffset-minAlphaOffset);
//
//    if (@available(iOS 11.0, *)) {
//        [[[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0] setHidden:YES];
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = alpha;
//    } else {
//        self.navigationController.navigationBar.subviews.firstObject.alpha = alpha;
//    }
//}

#pragma mark - 设置导航栏背景色，20240321，测试可用有效
/// 设置导航栏背景色
- (void)setNavBarBgColor:(UIColor *)barBgColor {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];//重置背景和阴影颜色
        appearance.backgroundColor = barBgColor;//设置导航栏背景色
        appearance.backgroundEffect = nil;//
        appearance.shadowColor = [UIColor clearColor];//设置导航栏下边界分割线透明
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;//带scroll滑动的页面
        self.navigationController.navigationBar.standardAppearance = appearance;//常规页面。描述导航栏以标准高度
        
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0].hidden = YES;
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
        
        UIView *barBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = 0;
        }
    } else {
        //背景色
        self.navigationController.navigationBar.barTintColor = barBgColor;
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        
        // iOS11的导航栏视图结构发生了变化。需要做个判断
        if (@available(iOS 11.0, *)) {
            [[[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0] setHidden:YES];
            [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
        } else {
            // 设置导航栏imageView子视图的alpha。
            // navigationBar上的subviews的第一个视图即为我们要的子视图
            self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
        }
    }
    
    if ([barBgColor isEqual:[UIColor clearColor]]) {
        //透明
        self.navigationController.navigationBar.translucent = YES;
    } else {
        //不透明
        self.navigationController.navigationBar.translucent = NO;
    }
}

#pragma mark - 设置导航栏背景图片，20240321，测试可用有效
/// 设置导航栏背景图片
- (void)setNavBarBackgroundImage:(UIImage *)backgroundImage {
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *appearance = [UINavigationBarAppearance new];
        [appearance configureWithOpaqueBackground];//重置背景和阴影颜色
        appearance.backgroundColor = [UIColor clearColor];//设置导航栏背景色
        appearance.backgroundEffect = nil;//
        appearance.shadowColor = [UIColor clearColor];//设置导航栏下边界分割线透明
        appearance.backgroundImage = backgroundImage;
        self.navigationController.navigationBar.scrollEdgeAppearance = appearance;//带scroll滑动的页面
        self.navigationController.navigationBar.standardAppearance = appearance;//常规页面。描述导航栏以标准高度
        
//        // 必须设置 这一层alpha=0或者hidden=YES，否则当页面有scrollView滑动的时候，这一层会挡住设置的背景图片
//        // 设置 alpha=0和hidden=YES，可以达到同样的效果
//        // alpha=0,图层还在,颜色透明度为0，不会挡住 设置的图片，
//        // hidden=YES,图层被隐藏，不会挡住设置的图片
//        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0].alpha = 0;
//        // [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0].hidden = YES;
//
////        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
//        // nabBar的背景图片，这里就是设置的背景图片的那一层
////        [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].hidden = YES;
        
        UIView *barBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = 0;
        }
        
    } else {
        //背景色
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
        [self.navigationController.navigationBar setShadowImage:[UIImage new]];
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
        
        // iOS11的导航栏视图结构发生了变化。需要做个判断
        if (@available(iOS 11.0, *)) {
            [[[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:0] setHidden:YES];
            [[[[self.navigationController.navigationBar subviews] objectAtIndex:0] subviews] objectAtIndex:1].alpha = 0;
        } else {
            // 设置导航栏imageView子视图的alpha。
            // navigationBar上的subviews的第一个视图即为我们要的子视图
            self.navigationController.navigationBar.subviews.firstObject.alpha = 0;
        }
    }
    if (backgroundImage) {
        //透明
        self.navigationController.navigationBar.translucent = YES;
    } else {
        //不透明
        self.navigationController.navigationBar.translucent = NO;
    }
}

#pragma mark - 设置导航栏 透明度 alpha

// 设置导航栏 透明度 alpha
- (void)setBarBackgroundAlpha:(CGFloat)alpha {
    
    UIView *barBackgroundView = self.navigationController.navigationBar.subviews.firstObject;
    if (@available(iOS 11.0, *)) {
        for (UIView *view in barBackgroundView.subviews) {
            view.alpha = alpha;
        }
    } else {
        barBackgroundView.alpha = alpha;
    }
    
    
    if (alpha < 1) {
        // 设置了.translucent=YES，就可以调控 alpha 的值看到透明的效果。
        self.navigationController.navigationBar.translucent = YES;//透明，毛玻璃
    } else {
        // 设置了.translucent=NO，无论 alpha 的值设置多少，都不会有透明的效果。
        self.navigationController.navigationBar.translucent = NO;//不透明
    }
}

#pragma mark -  设置导航栏标题 字体和颜色，测试可用
/// 设置导航栏标题 字体和颜色
- (void)setNavBarTitleTextAttributes:(NSMutableDictionary *)attrDict {
    
    //navigation标题文字颜色
    if (!attrDict || attrDict.allKeys.count == 0) {
        attrDict = [NSMutableDictionary dictionary];
        attrDict[NSForegroundColorAttributeName] = [UIColor whiteColor];
        attrDict[NSFontAttributeName] = [UIFont systemFontOfSize:18];
    }
    
    if (@available(iOS 15.0, *)) {
        UINavigationBarAppearance *barApp = self.navigationController.navigationBar.standardAppearance;
        barApp.titleTextAttributes = attrDict;
        self.navigationController.navigationBar.standardAppearance = barApp;//常规页面。描述导航栏以标准高度
        self.navigationController.navigationBar.scrollEdgeAppearance = barApp;//带scroll滑动的页面
    } else {
        self.navigationController.navigationBar.titleTextAttributes = attrDict;
    }
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
//防止scrollView手势覆盖侧滑手势[scrollView.panGestureRecognizer requireGestureRecognizerToFail:self.navigationController.interactivePopGestureRecognizer];
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
                
            } else {
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
