//
//  LSTextFieldDeleteBackward.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/5/11.
//  Copyright © 2023 Link-Start. All rights reserved.
//  UITextField 在没有数据时系统键盘监听不到点击了删除按钮，

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LSTextFieldDeleteBackward;

@protocol LSTextFieldDeleteBackwardDelegate <NSObject>

/// 键盘的删除按键方法
- (void)ls_textFieldDidDeleteBackward:(LSTextFieldDeleteBackward *)textField;

@end


@interface LSTextFieldDeleteBackward : UITextField

@property (nonatomic, weak) id<LSTextFieldDeleteBackwardDelegate> ls_delegate;

@end

NS_ASSUME_NONNULL_END
