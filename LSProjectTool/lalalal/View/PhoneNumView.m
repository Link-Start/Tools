//
//  PhoneNumView.m
//  ChaoPai
//
//  Created by macbook v5 on 2018/8/31.
//  Copyright © 2018年 LinkStart. All rights reserved.
//

#import "PhoneNumView.h"
#import "Function.h"

#define VERTIFICATIONTIME 60

@interface PhoneNumView ()

@property (nonatomic, strong) UIView *lineH1;

///验证码
@property (nonatomic, copy) NSString *verifiCodeStr;
///验证码计时器
@property (nonatomic, weak) NSTimer *verTimer;
//验证码计数
@property (nonatomic, assign)NSUInteger verTimeLimit;

@end

@implementation PhoneNumView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubViews];
        [self addLayout];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubViews];
        [self addLayout];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}



#pragma mark - 按钮点击事件
///获取验证码
- (void)getVerifiCodeBtnAction:(UIButton *)sender {
    
    if (self.phoneNumTF.text.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        return;
    }
    if (![Function judgeMobileNumber:self.phoneNumTF.text]) {
        [MBProgressHUD showError:@"请输入正确的手机号"];
        return;
    }
    
    [self getSendCode];
}
///获取验证码
- (void)getSendCode {
    __weak __typeof(self)weakSelf = self;
//    [HttpRequestUtil sendMessageWithMobile:self.phoneNumTF.text scene:self.scene result:^(BOOL success, NSString *msg) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
//        if (success) {
//            [MBProgressHUD showSuccess:@"验证码已下发,请注意查收"];
            strongSelf.verTimeLimit = VERTIFICATIONTIME;
            if(strongSelf.verTimer){
            } else {
                strongSelf.verTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:weakSelf selector:@selector(RupdateTimer) userInfo:nil repeats:YES];
            }
//            [strongSelf.getVerifiCodeBtn setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
//        } else {
//            strongSelf.getVerifiCodeBtn.enabled = YES;
//        }
//    }];
}
///销毁定时器
- (void)invalidateTimer {
    [self.verTimer invalidate];
    self.verTimer = nil;
}

#pragma mark - 定时器方法
//更新计时器
- (void)RupdateTimer {
    
    if (self.verTimeLimit <= 0) {
        if ([self.verTimer isValid]) {
            [self.verTimer invalidate];
            self.verTimer = nil;
            [self.getVerifiCodeBtn setEnabled:YES];
            [self.getVerifiCodeBtn setTitle:@"重新获取验证码" forState:UIControlStateNormal];
            [self.getVerifiCodeBtn setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
        }
        
    } else {
        
    [self.getVerifiCodeBtn setTitleColor:[UIColor colorFromHexString:@"#999999"] forState:UIControlStateNormal];
        [self.getVerifiCodeBtn setEnabled:NO];
        NSString *str = [NSString stringWithFormat:@"重新获取(%lus)",(unsigned long)self.verTimeLimit];
        [self.getVerifiCodeBtn setTitle:str forState:UIControlStateNormal];
    }
    self.verTimeLimit--;
}

#pragma mark - 添加子视图
- (void)addSubViews {
    [self addSubview:self.desLabel];
    [self addSubview:self.phoneNumTF];
    [self addSubview:self.getVerifiCodeBtn];
    [self addSubview:self.lineH1];
}

- (void)addLayout {
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.top.mas_equalTo(self.mas_top);
//        make.height.mas_equalTo(kLS_relative_Height(20));
    }];
    
    [self.phoneNumTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.top.mas_equalTo(self.desLabel.mas_bottom).mas_offset(10);
//        make.height.mas_equalTo(kLS_relative_Height(30));
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-30-100-15);
    }];
    
    [self.getVerifiCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-30);
        make.centerY.mas_equalTo(self.phoneNumTF.mas_centerY);
    }];
    
    [self.lineH1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.phoneNumTF.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}


- (void)setScene:(NSString *)scene {
    _scene = scene;
}

#pragma mark - 懒加载
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _desLabel.textColor = [UIColor colorFromHexString:@"#BDBDBD"];
        _desLabel.text = @"请输入您的手机号码";
    }
    return _desLabel;
}

- (UITextField *)phoneNumTF {
    if (!_phoneNumTF) {
        _phoneNumTF = [[UITextField alloc] init];
        _phoneNumTF.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _phoneNumTF.textColor = [UIColor colorFromHexString:@"#212121"];
        _phoneNumTF.keyboardType = UIKeyboardTypeNumberPad;
        
    }
    
    return _phoneNumTF;
}

- (UIButton *)getVerifiCodeBtn {
    if (!_getVerifiCodeBtn) {
        _getVerifiCodeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _getVerifiCodeBtn.adjustsImageWhenDisabled = NO;
        _getVerifiCodeBtn.adjustsImageWhenHighlighted = NO;
        _getVerifiCodeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [_getVerifiCodeBtn setTitleColor:[UIColor colorFromHexString:@"#333333"] forState:UIControlStateNormal];
        [_getVerifiCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_getVerifiCodeBtn addTarget:self action:@selector(getVerifiCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getVerifiCodeBtn;
}

- (UIView *)lineH1 {
    if (!_lineH1) {
        _lineH1 = [[UIView alloc] init];
        _lineH1.backgroundColor = [UIColor colorFromHexString:@"#E8E8E8"];
    }
    return _lineH1;
}

- (void)dealloc {
    NSLog(@"llllssss");
    [self invalidateTimer];//销毁定时器
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
