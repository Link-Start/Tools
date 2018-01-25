//
//  SYPasswordView.h
//  PasswordDemo
//
//  Created by aDu on 2017/2/6.
//  Copyright © 2017年 DuKaiShun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SYPasswordView;

@protocol SYPasswordViewDelegate <NSObject>


- (void)endInput;

@end

@interface SYPasswordView : UIView<UITextFieldDelegate>

@property (nonatomic, weak) id<SYPasswordViewDelegate> delegate;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, copy) NSString *str;


/**
 *  清除密码
 */
- (void)clearUpPassword;



@end
