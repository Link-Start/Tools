//
//  LSSegmentedViewCell.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/29.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "LSSegmentedViewCell.h"

@interface LSSegmentedViewCell()

///名称
@property (nonatomic, strong) UIButton *ls_titleBtn;

@end

@implementation LSSegmentedViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addSubViews];
    }
    return self;
}

- (void)addSubViews{

    [self.contentView addSubview:self.ls_titleBtn];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    self.ls_titleBtn.frame = self.bounds;
}

#pragma mark - setter方法
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    [_ls_titleBtn setTitle:_titleStr forState:UIControlStateNormal];
}

- (void)setLs_titleLabelColor:(UIColor *)ls_titleLabelColor {
    ls_titleLabelColor = ls_titleLabelColor;
    [_ls_titleBtn setTitleColor:_ls_titleLabelColor forState:UIControlStateNormal];
}

#pragma mark - 懒加载
- (UIButton *)ls_titleBtn {
    if (!_ls_titleBtn) {
        _ls_titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_ls_titleBtn addTarget:self action:@selector(ls_titleBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _ls_titleBtn;
}
//点击事件
- (void)ls_titleBtnAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(cellDidClick:)]) {
        [self.delegate cellDidClick:self];
    }
}

@end
