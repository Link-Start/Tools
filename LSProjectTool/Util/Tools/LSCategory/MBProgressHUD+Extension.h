//
//  MBProgressHUD+Extension.h
//  Tedddd
//
//  Created by Xcode on 16/8/11.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
//
//
//  适合 MBProgressHUD版本 1.1.0
//
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)

/*!
 *  @brief 几秒后显示菊花
 *
 *  @param graceTime
 *
 *  @return
 */
+ (MBProgressHUD *)hud:(CGFloat)graceTime;

/**
 *  快速显示某些信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD， 不需要手动关闭
 */
+ (MBProgressHUD *)qucickTip:(NSString *)message;

/**
 *  显示详细信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，不需要手动关闭
 */
+ (MBProgressHUD *)fakeWaiting:(NSString *)message toView:(UIView *)view;

//隐藏hud  移除hud
+ (void)hiddenHud:(MBProgressHUD *)hud;

@end
