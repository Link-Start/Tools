//
//  UIAlertAction+LSActionSetting.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/3/1.
//  Copyright © 2024 Link-Start. All rights reserved.
//
//  改变 alert 按钮的字体颜色
//  https://blog.51cto.com/u_13303/8571894
//  2024.3.1 测试可用

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertAction (LSActionSetting)

/// 按钮 title 的颜色
@property (nonatomic, strong) UIColor *titleColor;

@end

NS_ASSUME_NONNULL_END
