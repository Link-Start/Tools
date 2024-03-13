//
//  UIAlertController+LSAlertSetting.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/2/29.
//  Copyright © 2024 Link-Start. All rights reserved.
//
//  改变 alert 标题,message 字体,颜色
//  https://blog.51cto.com/u_13303/8571894


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (LSAlertSetting)

/// 标题颜色
@property (nonatomic, strong) UIColor *titleColor;
/// 标题字体
@property (nonatomic, strong) UIFont *titleFont;
/// 设置标题的富文本属性
@property (nonatomic, strong) NSAttributedString *titleAttributedString;
/// message颜色
@property (nonatomic, strong) UIColor *messageColor;
/// message 字体
@property (nonatomic, strong) UIFont *messageFont;
/// 设置 message 的富文本属性
@property (nonatomic, strong) NSAttributedString *messageAttributedString;

@end

NS_ASSUME_NONNULL_END
