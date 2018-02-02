//
//  MBProgressHUD+Extension.m
//  Tedddd
//
//  Created by Xcode on 16/8/11.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#define kLastWindow [UIApplication sharedApplication].keyWindow

#import "MBProgressHUD+Extension.h"
#import <objc/runtime.h>

@implementation MBProgressHUD (Extension)


+ (MBProgressHUD *)hud:(CGFloat)graceTime{

    MBProgressHUD *hud = [self hud];
    [kLastWindow addSubview:hud];
    hud.graceTime = graceTime;
    // 设置该属性，graceTime才能生效
    hud.taskInProgress = YES;
    [hud show:YES];
    hud.userInteractionEnabled = YES;//打开hud用户交互,使hud所在的父视图不能用户交互
    
    return hud;
}

// 网络请求频率很高，不必每次都创建\销毁一个hud，只需创建一个反复使用即可
+ (MBProgressHUD *)hud {
    
    //获取相关联的对象时使用Objective-C函数objc_getAssociatedObject
    MBProgressHUD *hud = objc_getAssociatedObject(self, _cmd);
    
    if (!hud) {
        // 参数kLastWindow仅仅是用到了其CGFrame，并没有将hud添加到上面
        hud = [[MBProgressHUD alloc] initWithWindow:kLastWindow];
//        hud.labelText = @"加载中...";
        //objc_setAssociatedObject来把一个对象与另外一个对象进行关联。该函数需要四个参数：源对象(关联者)，关键字，关联的对象(被关联者)和一个关联策略。
        //关键字是一个void类型的指针。每一个关联的关键字必须是唯一的。通常都是会采用静态变量来作为关键字
        //
        objc_setAssociatedObject(self, _cmd, hud, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        //断开关联  断开关联是使用objc_setAssociatedObject函数，传入nil值即可。
        // 使用函数objc_removeAssociatedObjects可以断开所有关联。通常情况下不建议使用这个函数，因为他会断开所有关联。只有在需要把对象恢复到“原始状态”的时候才会使用这个函数。
        NSLog(@"创建了一个HUD");
    }
    return hud;
}


/**
 *  快速显示某些信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD， 不需要手动关闭
 */
+ (MBProgressHUD *)qucickTip:(NSString *)message {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //动画
    hud.animationType = MBProgressHUDAnimationZoom;
    //设置模式
    hud.mode = MBProgressHUDModeText;
    ///设置需要显示的文字信息
    hud.labelText = message;
    //关闭用户交互
    hud.userInteractionEnabled = NO;
    //1.4秒后消失
    [hud hide:YES afterDelay:1.4];
    return hud;
}

/**
 *  显示详细信息
 *
 *  @param message 信息内容
 *  @param view    需要显示信息的视图
 *
 *  @return 直接返回一个MBProgressHUD，不需要手动关闭
 */
+ (MBProgressHUD *)fakeWaiting:(NSString *)message toView:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    //动画
    hud.animationType = MBProgressHUDAnimationZoomOut;
    //设置需要显示的细节文字信息
    hud.detailsLabelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    //1.2秒后消失
    [hud hide:YES afterDelay:1.2];
    return hud;
}

#pragma mark - 显示成功信息
/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *
 *  不需要手动关闭
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success {
    return [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 *  @return 直接返回一个MBProgressHUD，不需要手动关闭
 */
+ (MBProgressHUD *)showSuccess:(NSString *)success toView:(UIView *)view {
    return  [self show:success icon:@"success.png" view:view];
}

/**
 *  显示错误信息
 *
 *  不需要手动关闭
 */
+ (MBProgressHUD *)showError:(NSString *)error {
    return [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 *  @return 直接返回一个MBProgressHUD，不需要手动关闭
 */
+ (MBProgressHUD *)showError:(NSString *)error toView:(UIView *)view {
    return [self show:error icon:@"error.png" view:view];
}
/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
+ (MBProgressHUD *)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view {
    if (view == nil) {
        view = [UIApplication sharedApplication].keyWindow;
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [self hud];
    //设置需要显示的文字信息
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    //设置动画
    hud.animationType = MBProgressHUDAnimationZoom;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
    return hud;
}

@end
