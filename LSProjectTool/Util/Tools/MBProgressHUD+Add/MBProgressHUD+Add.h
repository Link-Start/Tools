//
//  MBProgressHUD+Add.h

//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//
//
//
//  适合 MBProgressHUD版本 1.1.0
//
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)

///单利
+ (instancetype)shareHud;

/**
 *  显示成功信息
 *  不需要手动关闭
 */
+ (void)showSuccess:(NSString *)success;

/**
 *  显示成功信息
 *  @return 直接返回一个MBProgressHUD，不需要手动关闭
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view;

/**
 *  显示错误信息
 *  不需要手动关闭
 */
+ (void)showError:(NSString *)error;

/**
 *  显示错误信息
 *  @return 直接返回一个MBProgressHUD，不需要手动关闭
 */
+(MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view;

/**
 *  显示 信息
 *  最好不要用在第一个viewControll，否则可能会崩溃
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message;

/**
 *  显示一些信息
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view;

/**
 *  快速显示某些信息
 *  @return 直接返回一个MBProgressHUD， 不需要手动关闭
 */
+(MBProgressHUD *)qucickTip:(NSString *)message;

/**
 *  显示详细的信息
 *  @return 直接返回一个MBProgressHUD，不需要手动关闭
 */
+ (MBProgressHUD *)fakeWaiting:(NSString *)message toView:(UIView *)view;

/**
 *  显示加载中...
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showLoadingToView:(UIView *)view;

/**
 *  显示一些字符串
 *  不需要手动关闭
 */
+ (void)showString:(NSString *)message toView:(UIView *)view;

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD;

/**
 *  手动关闭MBProgressHUD
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view;

///手动关闭所有的hud
+ (void)hideAllHuds;

@end
