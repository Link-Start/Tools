//
//  UITextField+LSDeleteBackward.h
//  Pension
//
//  Created by 刘晓龙 on 2023/5/11.
//  Copyright © 2023 ouba. All rights reserved.
//  监听键盘删除按钮，textField内无文本时也能监听到

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// 监听删除按钮
extern NSString * const LSTextFieldDidDeleteBackwardNotification;

@protocol LSTextFieldDeleteBackwardDelegate <NSObject>

/// 键盘的删除按键，
- (void)textFieldDidDeleteBackward:(UITextField *)textField;

@end

@interface UITextField (LSDeleteBackward)

@property (nonatomic, weak) id<LSTextFieldDeleteBackwardDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
