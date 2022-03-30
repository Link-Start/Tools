//
//  UIFont+LXLAdpativeFont.m
//  Pension
//
//  Created by 刘晓龙 on 2021/12/20.
//  Copyright © 2021 ouba. All rights reserved.
//

#import "UIFont+LXLAdpativeFont.h"
#import "NSObject+KJRuntime.h"

@implementation UIFont (LXLAdpativeFont)

+ (void)load {
    //交换systemFontOfSize: 方法
    kRuntimeClassMethodSwizzling([self class], @selector(systemFontOfSize:), @selector(customSystemFontOfSize:));
    //交换fontWithName:size:方法
    kRuntimeClassMethodSwizzling([self class], @selector(fontWithName:size:), @selector(customFontWithName:size:));
}


//自定义的交换方法
+ (UIFont *)customSystemFontOfSize:(CGFloat)fontSize
{
    CGFloat size = [UIFont transSizeWithFontSize:fontSize];
    ///这里并不会引起递归，方法交换后，此时调用customSystemFontOfSize方法，其实是调用了原来的systemFontOfSize方法
    return [UIFont customSystemFontOfSize:size];
}

//自定义的交换方法
+ (UIFont *)customFontWithName:(NSString *)fontName size:(CGFloat)fontSize
{
    CGFloat size = [UIFont transSizeWithFontSize:fontSize];
    return [UIFont customFontWithName:fontName size:size];
}

///屏幕宽度大于320的，字体加10。(此处可根据不同的需求设置字体大小)
+ (CGFloat)transSizeWithFontSize:(CGFloat)fontSize
{
    CGFloat size = fontSize;
//    CGFloat width = [UIFont getWidth];
//    if (width > 320) {
//        size += 10;
//    }
//    return size;
    
    if (MemberInfoModel.overallSituationFontSizeEnlargeMultiple) {//如果设置了放大倍数
        return [NSNumber numberWithString:MemberInfoModel.overallSituationFontSizeEnlargeMultiple].floatValue*size;
    }
    return size;
}

///获取竖屏状态下的屏幕宽度
+ (CGFloat)getWidth
{
    if (@available(iOS 13.0, *)) {
        for (UIScreen *windowsScenes in UIApplication.sharedApplication.connectedScenes) {
            UIWindowScene * scenes = (UIWindowScene *)windowsScenes;
            UIWindow *window = scenes.windows.firstObject;
            if (scenes.interfaceOrientation == UIInterfaceOrientationPortrait) {
                return window.frame.size.width;
            }
            return window.frame.size.height;
        }
    } else {
        return [UIScreen mainScreen].bounds.size.width;
    }
    return 0;
}

@end
