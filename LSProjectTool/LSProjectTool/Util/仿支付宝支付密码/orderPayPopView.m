//
//  orderPayPopView.m
//  RuiTuEBusiness
//
//  Created by Alex Yang on 2018/1/17.
//  Copyright © 2018年 Naive. All rights reserved.
//

#import "orderPayPopView.h"
#import "SYPasswordView.h"
///cellID
#define kCellID @"LSAlertViewCellId"

#define kScreenBounds ([UIScreen mainScreen].bounds)
#define kScreenWidth kScreenBounds.size.width
#define kScreenHeight kScreenBounds.size.height
#define MAS_SHORTHAND_GLOBALS
#import "Masonry.h"
#import "Tools.h"


@interface orderPayPopView ()<SYPasswordViewDelegate>

///弹窗控件所在的view
@property (nonatomic, strong) UIView *ls_alertView;

@property (nonatomic, strong) SYPasswordView *pasView;


@property (nonatomic, strong) UILabel *markedWordLabel;
@property (nonatomic, strong) UILabel *markedWord;
@property (nonatomic, copy) NSString *yue;
@end

@implementation orderPayPopView


/*!
 *  @brief 初始化方法
 */
- (instancetype)initWithViewController:(UIViewController *)vc  yue:(NSString *)yue {
    self = [super initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    if (self) {
        
        _ls_vc = vc;
        _yue = yue;
        //设置视图
        [self configSubviews];
    }
    return self;
}

///设置视图
- (void)configSubviews {
    //设置背景
    self.backgroundColor = kRGBA(51, 51, 51, 0.6);
    
    _ls_alertView = [[UIView alloc] initWithFrame:CGRectMake(30, 20, kScreenWidth - 60, 155)];
    [self addSubview:_ls_alertView];
    _ls_alertView.ls_centerX = self.ls_centerX;
    _ls_alertView.ls_centerY = self.ls_centerY - 50;
    
    _ls_alertView.backgroundColor = [UIColor whiteColor];
    //设置圆角
    _ls_alertView.layer.cornerRadius = 5;
    _ls_alertView.layer.masksToBounds = YES;
    
    //tableView
    [self setupView];
}


- (void)setupView {
    //
    UILabel *titLabel = [[UILabel alloc] init];
    [_ls_alertView addSubview:titLabel];
    titLabel.text = @"请输入支付密码";
    titLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    titLabel.textColor = RGB(51, 51, 51);
    [titLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(_ls_alertView.mas_centerX);
        make.top.mas_equalTo(_ls_alertView.mas_top).mas_equalTo(20);
    }];
    
    //删除btn
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_ls_alertView addSubview:delBtn];
    [delBtn setImage:[UIImage imageNamed:@"icon_pay_del"] forState:UIControlStateNormal];
    [delBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_ls_alertView.mas_trailing);
        make.top.mas_equalTo(_ls_alertView.mas_top);
    }];
    [delBtn addTarget:self action:@selector(delBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //    //余额
    //    UILabel *yueLab = [[UILabel alloc] init];
    //    [_ls_alertView addSubview:yueLab];
    //    yueLab.text = @"当前可用余额：";
    //    yueLab.font = [UIFont fontWithName:@"PingFang SC" size:12];
    //    yueLab.textColor = RGB(153, 153, 153);
    //    [yueLab mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.mas_equalTo(titLabel.mas_bottom).mas_offset(16);
    //        make.leading.mas_equalTo(titLabel.mas_leading);
    //    }];
    //    UILabel *yuePrice = [[UILabel alloc] init];
    //    [_ls_alertView addSubview:yuePrice];
    //    yuePrice.text = [NSString stringWithFormat:@"%@", _yue];
    //    yuePrice.font = [UIFont fontWithName:@"PingFang SC" size:12];
    //    yuePrice.textColor = RGB(255, 6, 0);
    //    [yuePrice mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.mas_equalTo(yueLab.mas_centerY);
    //        make.leading.mas_equalTo(yueLab.mas_trailing);
    //    }];
    
    //密码输入框
    _pasView = [[SYPasswordView alloc] initWithFrame:CGRectMake(0, 0, kLS_ScreenWidth - 120, 45)];
    [_ls_alertView addSubview:_pasView];
    _pasView.delegate = self;
    [_pasView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titLabel.mas_bottom).mas_offset(17);
        make.leading.mas_equalTo(_ls_alertView.mas_leading).mas_offset(30);
        make.centerX.mas_equalTo(_ls_alertView.mas_centerX);
        make.height.mas_equalTo(45);
    }];
    
    [_pasView.textField becomeFirstResponder];
    
    
    UIButton *forgetPwdBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_ls_alertView addSubview:forgetPwdBtn];
    [forgetPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    [forgetPwdBtn setTitleColor:RGB(153, 153, 153) forState:UIControlStateNormal];
    [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.trailing.mas_equalTo(_ls_alertView.mas_trailing).mas_offset(-30);
        make.top.mas_equalTo(_pasView.mas_bottom).mas_offset(17);
    }];
    [forgetPwdBtn addTarget:self action:@selector(forgetPwdBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)forgetPwdBtnAction {
    NSLog(@"忘记密码");
    if (_AlertViewForgetPwd) {
        _AlertViewForgetPwd(self);
    }
}
- (void)delBtnAction {
    NSLog(@"隐藏");
    
    [self exitToBottom];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    if (![touch.view isEqual:_ls_alertView]) {
        [self exitToBottom];
    }
}

- (void)show {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self fadeInAnimate];
}



/**
 *  出场/退场/重试动画
 */
- (void)fadeInAnimate {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}


- (void)exitToBottom {
    
    [self endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        _ls_alertView.transform = CGAffineTransformTranslate(_ls_alertView.transform, 0, kScreenHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview]; //移除视图
    }];
}

- (void)endInput {
    if (self.AlertViewEndInput) {
        self.AlertViewEndInput(_pasView.textField.text, self);
    }
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

