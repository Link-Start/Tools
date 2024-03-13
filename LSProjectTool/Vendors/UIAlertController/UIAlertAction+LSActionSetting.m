//
//  UIAlertAction+LSActionSetting.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/3/1.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import "UIAlertAction+LSActionSetting.h"
#import <objc/runtime.h>

@implementation UIAlertAction (LSActionSetting)

@dynamic titleColor;


/// 按钮 title颜色
static char *titleColorKey = "titleTextColor";

- (UIColor *)titleColor {
    id color = objc_getAssociatedObject(self, titleColorKey);
    if (color == nil) {
        return [UIColor lightGrayColor];
    } else {
        return color;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    objc_setAssociatedObject(self, titleColorKey, titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setValue:titleColor forKey:@"titleTextColor"];
}




@end
