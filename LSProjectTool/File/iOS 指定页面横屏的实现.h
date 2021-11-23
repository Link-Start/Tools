//
// iOS 指定页面横屏的实现.h
// LSProjectTool
//
// reated by 刘晓龙 on 2021/8/9.
// Copyright © 2021 Link-Start. All rights reserved.
//
/**
*　　┏┓　　　┏┓+ +
*　┏┛┻━━━┛┻┓ + +
*　┃　　　　　　　┃
*　┃　　　━　　　┃ ++ + + +
* ████━████ ┃+
*　┃　　　　　　　┃ +
*　┃　　　┻　　　┃
*　┃　　　　　　　┃ + +
*　┗━┓　　　┏━┛
*　　　┃　　　┃
*　　　┃　　　┃ + + + +
*　　　┃　　　┃
*　　　┃　　　┃ +  神兽保佑
*　　　┃　　　┃    代码无bug
*　　　┃　　　┃　　+
*　　　┃　 　　┗━━━┓ + +
*　　　┃ 　　　　　　　┣┓
*　　　┃ 　　　　　　　┏┛
*　　　┗┓┓┏━┳┓┏┛ + + + +
*　　　　┃┫┫　┃┫┫
*　　　　┗┻┛　┗┻┛+ + + +
*/


#ifndef iOS___________h
#define iOS___________h

#pragma - mark - 自动横屏
General-->Deployment Info: Device Orientation 只需要设置为Portrait,  其他3个选项不用选中

iOS 指定页面横屏的实现
https://blog.csdn.net/ForeverMyheart/article/details/114017598?utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-19.pc_relevant_baidujshouduan&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromMachineLearnPai2%7Edefault-19.pc_relevant_baidujshouduan

为了实现这个功能，网上看了几篇文章，发现基本都是一样，

1.第一步就是在 Appdelegate 里面进行如下操作：
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {//如果设置了allowRotation属性，支持横屏
        return UIInterfaceOrientationMaskLandscapeRight;
    }
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}

2.第二步就是在需要横屏的页面写上已下代码

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self begainFullScreen];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self endFullScreen];
}

//进入全屏
- (void)begainFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}

// 退出全屏
- (void)endFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
//    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

 

本以为这样就大功告成，没想到在运行的时候崩溃了，崩溃信息如下：

'UIApplicationInvalidInterfaceOrientation', reason: 'Supported orientations has no common orientation with the application, and [ZDFullScreenController shouldAutorotate] is returning YES'


/************************************************************************* 完整代码 ***********************************************************************/
General-->Deployment Info: Device Orientation 只需要设置为Portrait,  其他3个选项不用选中

1. AppDelegate.h 添加属性
///允许横屏
@property (nonatomic, assign) BOOL allowRotation;

2. AppDelegate.m 设置允许旋转的方向
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    if (self.allowRotation) {//如果设置了allowRotation属性，支持横屏
        return UIInterfaceOrientationMaskAllButUpsideDown;//设置允许的方向
    }
    return UIInterfaceOrientationMaskPortrait;//默认全局不支持横屏
}

3. 允许旋转的VC
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self begainFullScreen];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self endFullScreen];
}

//进入全屏
- (void)begainFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = YES;
}

// 退出全屏!!!!!!!!!!!! 这个方法在 关闭当前VC的方法(closeVC)里调用,在viewWillDisappear调用会有一个短暂的0.2秒左右的 View页面 残留
- (void)endFullScreen {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.allowRotation = NO;
//    //强制归正：
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

// 是否支持自动转屏
- (BOOL)shouldAutorotate {
    return NO;
}

// 支持哪些屏幕方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

// 默认的屏幕方向（当前ViewController必须是通过模态出来的UIViewController（模态带导航的无效）方式展现出来的，才会调用这个方法）
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.navigationController.topViewController preferredInterfaceOrientationForPresentation];
}






#pragma - mark - 手动横屏
iOS强制横屏
https://www.cnblogs.com/block123/p/5917770.html

在AppDelegate中添加方法关闭横竖屏切换,方法如下
1.AppDelegate.h中外露一个属性
@property(nonatomic,assign)BOOL allowRotation;//是否允许转向

2.AppDelegate.m中添加方法(如果属性值为YES,仅允许屏幕向左旋转,否则仅允许竖屏)

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window{
    if (_allowRotation == YES) {
        return UIInterfaceOrientationMaskLandscapeLeft;
    } else {
        return (UIInterfaceOrientationMaskPortrait);
    }
}


第三步:

1.在需要强制横屏的控制器.m中添加旋转为横屏方法

- (void)setNewOrientation:(BOOL)fullscreen {

if (fullscreen) {
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];

        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];

    } else{
        NSNumber *resetOrientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
        [[UIDevice currentDevice] setValue:resetOrientationTarget forKey:@"orientation"];

        NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
        [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
    }
}

 

2.view DidLoad中添加以下代码
AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
appDelegate.allowRotation = YES;//(以上2行代码,可以理解为打开横屏开关)
[self setNewOrientation:YES];//调用转屏代码

 

3.重写导航栏返回箭头按钮,拿到返回按钮点击事件

- (void)back {
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    [self setNewOrientation:NO];
    [self.navigationController popViewControllerAnimated:YES];
}

大功告成,强制横屏功能实现,而且重力感应不会转屏。




#endif /* iOS___________h */
