//
//  模态显示PresentModalViewController.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/12/7.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#ifndef ____PresentModalViewController_h
#define ____PresentModalViewController_h

模态显示PresentModalViewController

https://blog.51cto.com/u_15318120/3241314


模态显示PresentModalViewController 原创
wx6103b5205e1842021-07-31 17:01:23
文章标签模态模态窗口视图控制器状态栏ipad文章分类运维阅读数1288
1、主要用途
弹出模态ViewController是IOS变成中很有用的一个技术，UIKit提供的一些专门用于模态显示的ViewController，如UIImagePickerController等。弹出模态ViewController
主要使用于一下这几种情形：
1、收集用户输入信息
2、临时呈现一些内容
3、临时改变工作模式
4、相应设备方向变化（用于针对不同方向分别是想两个ViewController的情况）
5、显示一个新的view层级
这几种情形都会暂时中断程序正常的执行流程，主要作用是收集或者显示一些信息。
2、弹出方法：presentModalViewController:
由 视图控制器类对象调用presentModalViewController: 方法。
以模态窗口的形式管理视图，当前视图关闭前其他视图上的内容无法操作。
3、modalTransitionStyle属性
通过设置设置presenting VC的modalTransitionStyle属性，我们可以设置弹出presented VC时场景切换动画的风格，包含类型如下：
typedef enum {
    UIModalTransitionStyleCoverVertical,   // 自下而上（从底部滑入）
    UIModalTransitionStyleFlipHorizontal,  // 自左至右180度翻转（水平翻转进入）
    UIModalTransitionStyleCrossDissolve,   // 淡出效果（交叉溶解）
    UIModalTransitionStylePartialCurl      // 翻页效果
} UIModalTransitionStyle;
1.
2.
3.
4.
5.
6.
这四种风格在不受设备的限制，即不管是iPhone还是iPad都会根据我们指定的风格显示转场效果。
4、Modal Presentation Styles（弹出风格）
通过设置presenting VC的modalPresentationStyle属性，我们可以设置弹出View Controller时的风格，有以下四种风格，其定义如下：
typedef enum {
    UIModalPresentationFullScreen = 0,
    UIModalPresentationPageSheet,
    UIModalPresentationFormSheet,
    UIModalPresentationCurrentContext,
} UIModalPresentationStyle;
1.
2.
3.
4.
5.
6.
4.1 UIModalPresentationFullScreen
代表弹出VC时，presented VC充满全屏，如果弹出VC的wantsFullScreenLayout设置为YES的，则会填充到状态栏下边，否则不会填充到状态栏之下。
4.2 UIModalPresentationPageSheet
代表弹出是弹出VC时，presented VC的高度和当前屏幕高度相同，宽度和竖屏模式下屏幕宽度相同，剩余未覆盖区域将会变暗并阻止用户点击，这种弹出模式下，竖屏时跟UIModalPresentationFullScreen的效果一样，横屏时候两边则会留下变暗的区域。
4.3 UIModalPresentationFormSheet
这种模式下，presented VC的高度和宽度均会小于屏幕尺寸，presented VC居中显示，四周留下变暗区域。
4.4 UIModalPresentationCurrentContext
这种模式下，presented VC的弹出方式和presenting VC的父VC的方式相同。
这四种方式在iPad上面统统有效，但在iPhone和iPod touch上面系统始终已UIModalPresentationFullScreen模式显示presented VC。
5、关闭方法：dismissModalViewControllerAnimated:
由 视图控制器类对象调用dismissModalViewControllerAnimated: 方法。
6、获取不同的模态窗口(主要的属性)
@property(nonatomic, readonly) UIViewController *presentedViewController ; // 当前控制器模态出的窗口
@property(nonatomic, readonly) UIViewController *presentingViewController; // 模态出当前控制器的窗口
1.
2.
7、处理模态窗口(主要的方法)
// 显示想要显示的模态窗口
- (void)presentViewController:(UIViewController *)viewControllerToPresent
                     animated: (BOOL)flag
                   completion:(void (^)(void))completion);

// 关闭当前显示的模态窗口
- (void)dismissViewControllerAnimated: (BOOL)flag
                           completion: (void (^)(void))completion);

// 当前控制器模态另一个窗口并传输数据时调用的方法
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)
1.
2.
3.
4.
5.
6.
7.
8.
9.
10.
11.
8、使用提醒
presenting view controller Vs presented view controller
当我们在view controller A中模态显示view controller B的时候，A就充当presenting view controller（弹出VC），而B就是presented view controller（被弹出VC）。官方文档建议这两者之间通过delegate实现交互，如果使用过UIImagePickerController从系统相册选取照片或者拍照，我们可以发现imagePickerController和弹出它的VC之间就是通过UIImagePickerControllerDelegate实现交互的。因此我们在实际应用用，最好也遵守这个原则，在被弹出的VC中定义delegate，然后在弹出VC中实现该代理，这样就可以比较方便的实现两者之间的交互。
9、示例
ModalTestController *vc = [[ModalTestController alloc] init];

vc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
vc.hidesBottomBarWhenPushed = YES;
UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
navi.definesPresentationContext = YES;
navi.modalPresentationStyle = UIModalPresentationCurrentContext;

[self.navigationController presentViewController:navi animated:YES completion:^{
    navi.navigationBarHidden = YES;
}];
1.
2.
3.
4.
5.
6.
7.
8.
9.
10.
11.






#endif /* ____PresentModalViewController_h */
