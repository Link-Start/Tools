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
@property (nonatomic, strong) UILabel *titleLabel;

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
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.titleLabel];
}



- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

#pragma mark - setter方法
- (void)setTitleStr:(NSString *)titleStr {
    _titleStr = titleStr;
    self.titleLabel.text = titleStr;
}

- (void)setLs_titleLabelColor:(UIColor *)ls_titleLabelColor {
    ls_titleLabelColor = ls_titleLabelColor;
    self.titleLabel.textColor = ls_titleLabelColor;
}

#pragma mark - 懒加载
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
