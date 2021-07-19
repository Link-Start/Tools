//
//  PhoneNumView.h
//  ChaoPai
//
//  Created by macbook v5 on 2018/8/31.
//  Copyright © 2018年 LinkStart. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneNumView : UIView

///
@property (nonatomic, strong) UILabel *desLabel;

///
@property (nonatomic, strong) UITextField *phoneNumTF;

///获取验证码按钮
@property (nonatomic, strong) UIButton *getVerifiCodeBtn;


///类型 0是注册 2是忘记密码 3:客户下单,4:客户支付,5:商家发货,6:身份验证 7修改手机 8支付密码 9更改密码前验证手机 11快捷登录 10公共验证码模板
@property (nonatomic, copy) NSString *scene;


/// 暂停定时器
- (void)pauseTimer;
///恢复定时器
- (void)resumeTimer;
///销毁定时器
- (void)invalidateTimer;

@end
