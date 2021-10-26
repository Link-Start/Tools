//
//  LSNavigationController.h
//  copyText
//
//  Created by Xcode on 16/8/17.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 导航控制器
@interface LSNavigationController : UINavigationController

///右滑返回 YES:不能
@property (nonatomic, assign) BOOL cannotRightSlipBack;

@end





//#pragma mark - 只在本界面禁用侧滑返回手势  1.
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    LSNavigationController *nav = self.navigationController;
//    nav.cannotRightSlipBack = YES;
//    
//}
//#pragma mark - 只在本界面禁用侧滑返回手势  2.
//- (void)viewDidDisappear:(BOOL)animated {
//    [super viewDidDisappear:animated];
//    
//    LSNavigationController *nav = self.navigationController;
//    nav.cannotRightSlipBack = NO;
//}

