//
//  PasswordView.m
//  ChaoPai
//
//  Created by macbook v5 on 2018/8/31.
//  Copyright © 2018年 LinkStart. All rights reserved.
//

#import "PasswordView.h"

@interface PasswordView ()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *lineH1;

@end


@implementation PasswordView


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
///显示隐藏密码
- (void)encryptBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.textField.secureTextEntry = !sender.selected;
    
    // 获得输入的值
    NSString *content = self.textField.text;
    // 解决输入框从密文切换明文时出现空格的问题
    self.textField.text = @"";
    self.textField.text = content;
    // 如果是密文转明文进行二次编辑不会出现清空现象,如果是明文转密文进行二次编辑就会出现清空现象,进行判断,如果切换后此时输入框是密文状态,就保存原有内容并赋值给输入框,这样就不会出现清空现象了
    if (self.textField.isSecureTextEntry) {
        // 解决输入框从明文切换为密文时进行二次编辑出现清空现象
        [self.textField insertText:content];
    }
}

#pragma mark - 代理方法
//解决密文状态下重新输入会清空之前的字符问题
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //得到输入框的内容
    NSString *textfieldContent = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (textField == self.textField && textField.isSecureTextEntry ) {
        textField.text = textfieldContent;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(secureTextEntryTextString:)]) {
            [self.delegate secureTextEntryTextString:textfieldContent];
        }
        
        return NO;
    }
    return YES;
}



#pragma mark - 添加子视图
- (void)addSubViews {
    [self addSubview:self.desLabel];
    [self addSubview:self.textField];
    [self addSubview:self.encryptBtn];
    [self addSubview:self.lineH1];
}

- (void)addLayout {
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.top.mas_equalTo(self.mas_top);
//        make.height.mas_equalTo(kLS_relative_Height(20));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.mas_leading).mas_offset(30);
        make.top.mas_equalTo(self.desLabel.mas_bottom).mas_offset(10);
//        make.height.mas_equalTo(kLS_relative_Height(30));
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-50-20-15);
    }];
    
    [self.encryptBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(self.mas_trailing).mas_offset(-50);
        make.centerY.mas_equalTo(self.textField.mas_centerY);
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
        _desLabel.text = @"密码";
    }
    return _desLabel;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
        _textField.textColor = [UIColor colorFromHexString:@"#212121"];
        _textField.clearsOnBeginEditing = NO;
        _textField.delegate = self;
        
        _textField.secureTextEntry = YES;
    }
    
    return _textField;
}

- (UIButton *)encryptBtn {
    if (!_encryptBtn) {
        _encryptBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _encryptBtn.adjustsImageWhenDisabled = NO;
        _encryptBtn.adjustsImageWhenHighlighted = NO;
        [_encryptBtn setImage:[UIImage imageNamed:@"icon_show"] forState:UIControlStateSelected];
        [_encryptBtn setImage:[UIImage imageNamed:@"icon_show_y"] forState:UIControlStateNormal];
        [_encryptBtn addTarget:self action:@selector(encryptBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _encryptBtn.selected = NO;
    }
    return _encryptBtn;
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
