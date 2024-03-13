//
//  MBProgressHUD+Extension.h
//  Tedddd
//
//  Created by Xcode on 16/8/11.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
//
//  适合 MBProgressHUD版本 1.1.0
//
//

#if __has_include(<MBProgressHUD/MBProgressHUD.h>)
#import <MBProgressHUD/MBProgressHUD.h>
#else
#import "MBProgressHUD.h"
#endif

//#import "MBProgressHUD.h"

@interface MBProgressHUD (Extension)


/// 几秒后显示菊花
/// graceTime
+ (MBProgressHUD *)hud:(CGFloat)graceTime;

/// 快速显示某些信息
/// message 信息内容
/// 直接返回一个MBProgressHUD， 不需要手动关闭
+ (MBProgressHUD *)qucickTip:(NSString *)message;

/// 隐藏hud  移除hud
+ (void)hiddenHud:(MBProgressHUD *)hud;

@end
