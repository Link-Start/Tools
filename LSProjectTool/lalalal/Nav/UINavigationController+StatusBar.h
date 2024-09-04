//
//  UINavigationController+StatusBar.h
//  qnche
//
//  Created by pengkang on 2017/7/4.
//  Copyright © 2017年 pengkang. All rights reserved.
//  
//  https://blog.51cto.com/u_16213618/10855410

#import <UIKit/UIKit.h>

@interface UINavigationController (StatusBar)

-(UIStatusBarStyle)preferredStatusBarStyle;

-(UIViewController *)childViewControllerForStatusBarStyle;

-(UIStatusBarAnimation)preferredStatusBarUpdateAnimation;


@end
