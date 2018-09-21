//
//  PasswordView.h
//  ChaoPai
//
//  Created by macbook v5 on 2018/8/31.
//  Copyright © 2018年 LinkStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PasswordViewDelegate <NSObject>

///密文状态下输入的字符串
- (void)secureTextEntryTextString:(NSString *)string;

@end

///密码
@interface PasswordView : UIView

///
@property (nonatomic, strong) UILabel *desLabel;

///
@property (nonatomic, strong) UITextField *textField;

///是否密文
@property (nonatomic, strong) UIButton *encryptBtn;


@property (nonatomic, weak) id<PasswordViewDelegate> delegate;


@end
