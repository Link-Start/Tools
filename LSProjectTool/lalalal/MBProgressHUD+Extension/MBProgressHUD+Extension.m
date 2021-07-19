//
//  MBProgressHUD+Extension.m
//  Tedddd
//
//  Created by Xcode on 16/8/11.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#define kLastWindow [UIApplication sharedApplication].delegate.window

#import "MBProgressHUD+Extension.h"
#import <objc/runtime.h>

@implementation MBProgressHUD (Extension)


+ (MBProgressHUD *)hud:(CGFloat)graceTime{

    MBProgressHUD *hud = [self hud];
    [kLastWindow addSubview:hud];
    hud.graceTime = graceTime;
    // 设置该属性，graceTime才能生效
//    hud.taskInProgress = YES;
    [hud showAnimated:YES];
    hud.userInteractionEnabled = NO;//打开hud用户交互,使hud所在的父视图不能用户交互
    return hud;
}

// 网络请求频率很高，不必每次都创建\销毁一个hud，只需创建一个反复使用即可
+ (MBProgressHUD *)hud{
    
    //获取相关联的对象时使用Objective-C函数objc_getAssociatedObject
    MBProgressHUD *hud = objc_getAssociatedObject(self, _cmd);
    
    if (!hud) {
        // 参数kLastWindow仅仅是用到了其CGFrame，并没有将hud添加到上面
        hud = [[MBProgressHUD alloc] initWithView:kLastWindow];
        
        //        //去除白色背景框
//                hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//                hud.bezelView.backgroundColor = [UIColor clearColor];
        
//        hud.label.text = @"加载中...";
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
    
    MBProgressHUD *hud = [self hud];
    [kLastWindow addSubview:hud];
    [hud showAnimated:YES];
    //动画
    hud.animationType = MBProgressHUDAnimationZoom;
    //设置模式
    hud.mode = MBProgressHUDModeText;
    ////设置需要显示的文字信息
    hud.label.text = message;
//    hud.detailsLabel.text = message;
//    hud.detailsLabel.font = [UIFont systemFontOfSize:16];
    //关闭用户交互
    hud.userInteractionEnabled = NO;
    //1.4秒后消失
    [hud hideAnimated:YES afterDelay:1.4];
    return hud;
}

//隐藏hud  移除hud
+ (void)hiddenHud:(MBProgressHUD *)hud {
    if (!hud) {
        hud = [self hud];
    }
    if (hud != nil) {
//        hud.taskInProgress = NO;
        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES];
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
    } else {
        hud = [self hud];
//        hud.taskInProgress = NO;
        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES];
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
    }
}



@end
