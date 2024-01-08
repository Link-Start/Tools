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



@end
