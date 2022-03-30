//
//  LSLayoutMethod.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/11/29.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "LSLayoutMethod.h"
#import "LSLayoutTool.h"

/// <#Description#>
@implementation LSLayoutMethod


/// 横屏情况下的宽度设置
/// @param iPhoneWidth：iPhone6 垂直方向@2x尺寸
/// @param iPadWidth：分辨率比例为 768*1024的iPad
/// @return：适配后的尺寸
- (CGFloat)lxl_autoLayoutWidth:(CGFloat)iPhoneWidth iPadWidth:(CGFloat)iPadWidth {
    CGFloat autoWidth = 0.0;
    CGFloat normalWidth = 667.0;//以iPhone6为标准 375*667
    CGFloat actualWidth = [LSLayoutTool autoScreenWidthInHorizontalScreenState];//横屏状态下的屏幕宽度
    
    // iPhone 的自动布局
    
    
    
    return 0;
}



@end
