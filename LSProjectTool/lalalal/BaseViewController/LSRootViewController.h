//
//  LSRootViewController.h
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/25.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 VC 基类
 */
@interface LSRootViewController : UIViewController

///修改状态栏颜色
@property (nonatomic, assign) UIStatusBarStyle ls_statusBarStyle;
///是否隐藏导航栏
@property (nonatomic, assign) BOOL ls_isHidenNavBar;


///默认返回按钮的点击事件，默认是返回，子类可重写
- (void)ls_backButtonAction;
///返回指定控制器
- (void)ls_backOutToVC:(UIViewController *)VC;

///判断当前UIViewController 是否正在显示。
- (BOOL)ls_currentVCIsVisible;
/// 判断某个VC是否正在显示
- (BOOL)ls_judgeVCWhetherIsVisible:(UIViewController *)VC;

@end
