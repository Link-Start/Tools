//
//  VerificationCodeView.m
//  ChaoPai
//
//  Created by macbook v5 on 2018/8/31.
//  Copyright © 2018年 LinkStart. All rights reserved.
//

#import "VerificationCodeView.h"
#import "Masonry.h"

@interface VerificationCodeView ()

@property (nonatomic, strong) UIView *lineH1;

@end

@implementation VerificationCodeView


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




#pragma mark - 添加子视图
- (void)addSubViews {
    [self addSubview:self.desLabel];
    [self addSubview:self.textField];
    [self addSubview:self.lineH1];
}

- (void)addLayout {
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.top.mas_equalTo(self.mas_top);
        make.height.mas_equalTo(kLS_relative_Height(20));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.top.mas_equalTo(self.desLabel.mas_bottom).mas_offset(10);
        make.height.mas_equalTo(kLS_relative_Height(30));
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-30);
    }];
    
    [self.lineH1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_bottom);
        make.height.mas_equalTo(0.5);
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.centerX.mas_equalTo(self.mas_centerX);
    }];
}


#pragma mark - 懒加载
- (UILabel *)desLabel {
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] init];
        _desLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        _desLabel.textColor = [UIColor colorFromHexString:@"#BDBDBD"];
        _desLabel.text = @"短信验证码";
    }
    return _desLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _textField.textColor = [UIColor colorFromHexString:@"#212121"];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
    }
    
    return _textField;
}

- (UIView *)lineH1 {
    if (!_lineH1) {
        _lineH1 = [[UIView alloc] init];
        _lineH1.backgroundColor = [UIColor colorFromHexString:@"#E8E8E8"];
    }
    return _lineH1;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
