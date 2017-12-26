//
//  LSTabBarController.m
//  copyText
//
//  Created by Xcode on 16/8/17.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "LSTabBarController.h"

@interface LSTabBarController ()

@property (nonatomic, assign) NSInteger indexFlag;

@end

@implementation LSTabBarController

+ (void)initialize {
    [super initialize];
}

//#pragma mark - 设置自定义Tabbar的文字大小
////在自定义tabbar中的控制器里 /********** 设置自定义Tabbar的文字大小 方法 1**************/
//+ (void)load {
//    
//    [super load];
//    
//    // 获取当前类的tabBarItem
//    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
//    
//    // 设置所有item的选中时颜色
//    // 设置选中文字颜色
//    // 创建字典去描述文本
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    // 文本颜色 -> 描述富文本属性的key -> NSAttributedString.h
//    attr[NSForegroundColorAttributeName] = [UIColor colorFromHexString:@"#da251c"];
//    [item setTitleTextAttributes:attr forState:UIControlStateSelected];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //添加子导航控制器
    [self addChildNav];
    //打开tabBar的毛玻璃效果
    self.tabBar.translucent = YES;
    
/************** 这里是去掉 系统tabbar上黑线的  方法 1 ***********************/
//    self.tabBar.backgroundImage = [[UIImage alloc]init];
//    self.tabBar.shadowImage = [[UIImage alloc]init];
    //设置tabBar的背景色
//    self.tabBar.barTintColor = [UIColor colorFromHexString:@"f5f5f5"];
    
/************ 去掉tabBar顶部黑色线条             方法2 *******************/
    [self configTabBar];
}

///去掉tabBar顶部黑色线条 (解决思路是用画布创建了一个透明色的图片)
- (void)configTabBar {
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    [self.tabBar setBackgroundImage:img];
    
    [self.tabBar setShadowImage:img];
}

///添加子导航控制器
- (void)addChildNav {
    //vc
//    HomepageViewController *homepageVC = [[HomepageViewController alloc] init];
//    BookingLaundryViewController *bookingLaundryVC = [[BookingLaundryViewController alloc] init];
//    PersonalCenterViewController *personalCenterVC = [[PersonalCenterViewController alloc] init];
//    //将VC 加入导航控制器nav
//    LSNavigationController *homepageNav = [[LSNavigationController alloc] initWithRootViewController:homepageVC];
//    LSNavigationController *bookingLaundryNav = [[LSNavigationController alloc] initWithRootViewController:bookingLaundryVC];
//    LSNavigationController *personalCenterNav = [[LSNavigationController alloc] initWithRootViewController:personalCenterVC];
//
//    self.viewControllers = @[homepageNav, bookingLaundryNav, personalCenterNav];
//
//    //设置item
//    homepageVC.title = @"首页";
//    bookingLaundryVC.title = @"";
//    personalCenterVC.title = @"我的";
//
//    //设置tabBarItem的图片 显示图片原本的颜色
//    homepageNav.tabBarItem.image = [UIImage imageNamed:@"底部-首页默认"];
//    homepageVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部-首页点击"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    bookingLaundryNav.tabBarItem.image = [[UIImage imageNamed:@"预约取件"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    bookingLaundryNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"预约取件"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    personalCenterNav.tabBarItem.image = [UIImage imageNamed:@"底部-我的默认"];
//    personalCenterNav.tabBarItem.selectedImage = [[UIImage imageNamed:@"底部-我的点击"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    [self setTabBarItem:homepageNav.tabBarItem
//                  Title:@"首页"
//          withTitleSize:14.0
//            andFoneName:@"Marion-Italic"
//          selectedImage:@"orderError"
//         withTitleColor:[UIColor redColor]
//        unselectedImage:@"orderSuccess"
//         withTitleColor:[UIColor whiteColor]];

}

#pragma mark - 设置自定义Tabbar的文字大小
//在自定义tabbar中的控制器里 /********** 设置自定义Tabbar的文字大小 方法 1**************/
//+ (void)load {
//    [super load];
//    
//    // 获取当前类的tabBarItem
//    UITabBarItem *item = [UITabBarItem appearanceWhenContainedIn:self, nil];
//    
//    // 设置所有item的选中时颜色
//    // 设置选中文字颜色
//    // 创建字典去描述文本
//    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
//    // 文本颜色 -> 描述富文本属性的key -> NSAttributedString.h
//    attr[NSForegroundColorAttributeName] = [UIColor blueColor];
//    [item setTitleTextAttributes:attr forState:UIControlStateSelected];
//    
//    // 通过normal状态设置字体大小
//    // 字体大小 跟 normal
//    NSMutableDictionary *attrnor = [NSMutableDictionary dictionary];
//    
//    // 设置字体
//    attrnor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
//    
//    [item setTitleTextAttributes:attrnor forState:UIControlStateNormal];
//}

/********** 设置自定义Tabbar的文字大小 方法 2**************/
/******* 设置TabBarItem的字体大小、颜色，各种状态下的图片  这个方法可以直接设置 *******/
/*!
 *  @brief 设置TabBarItem的字体大小、颜色，各种状态下的图片
 *
 *  @param tabbarItem      要设置的item
 *  @param title           item 的 title
 *  @param size            title 的字体大小
 *  @param foneName        字体类型名称
 *  @param selectedImage   选中的图片
 *  @param selectColor     选中的字体的颜色
 *  @param unselectedImage 为选中的图片
 *  @param unselectColor   为选中的字体的颜色
 */
//- (void)setTabBarItem:(UITabBarItem *)tabbarItem
//                Title:(NSString *)title
//        withTitleSize:(CGFloat)size
//          andFoneName:(NSString *)foneName
//        selectedImage:(NSString *)selectedImage
//       withTitleColor:(UIColor *)selectColor
//      unselectedImage:(NSString *)unselectedImage
//       withTitleColor:(UIColor *)unselectColor{
//    
//    //设置图片
//    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
//    
//    //未选中字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateNormal];
//    
//    //选中字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateSelected];
//}


//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
//    NSInteger index = [self.tabBar.items indexOfObject:item];
//
//    if (self.indexFlag != index) {
//        //缩放动画
//        [self animationWithIndex:index];
//    }
//}
//
////动画
//- (void)animationWithIndex:(NSInteger)index {
//    NSMutableArray *tabBarButtonArray = [NSMutableArray array];
//
//    for (UIView *tabBarButton in self.tabBar.subviews) {
//        if ([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [tabBarButtonArray addObject:tabBarButton];
//        }
//    }
//
//    CABasicAnimation*pulse = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//    pulse.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    pulse.duration = 0.08;
//    pulse.repeatCount= 1;
//    pulse.autoreverses= YES;
//    pulse.fromValue= [NSNumber numberWithFloat:0.7];
//    pulse.toValue= [NSNumber numberWithFloat:1.3];
//    [[tabBarButtonArray[index] layer]
//     addAnimation:pulse forKey:nil];
//
//    self.indexFlag = index;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
