//
//  LSCommonTableViewCell.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/17.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "LSCommonTableViewCell.h"

@interface LSCommonTableViewCell ()

@end

@implementation LSCommonTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


#pragma mark - 初始化
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubViews];
        [self addLayout];
        [self otherConfig];
    }
    return self;
}

#pragma mark - 添加subViews
- (void)addSubViews {
    [self addContentViewSubViews];
    [self addContentViewOtherSubViews];
}

#pragma mark - 添加约束
- (void)addLayout {
    [self addContentViewSubViewsLayout];
    [self addContentViewOtherSubViewsLayout];
}

#pragma mark - 添加子视图
- (void)addContentViewSubViews {
    [self.contentView addSubview:self.containerView];
    
}
#pragma mark - 添加子视图约束
- (void)addContentViewSubViewsLayout {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.containerView);
    }];
}

/// 添加其他子视图
- (void)addContentViewOtherSubViews {
    
}
/// 添加其他子视图约束
- (void)addContentViewOtherSubViewsLayout {
    
}

/// 其他设置
- (void)otherConfig {
    // 去掉点击的颜色变化效果，
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // 去掉背景色
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    self.contentView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    // iOS 13 之后横竖屏切换的时候 self.contentView 会变化
    if (self.contentView.frame.origin.x > 0 ) {
        CGRect frame = self.contentView.frame;
        frame.origin.x = 0;
        self.contentView.frame = frame;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 懒加载
- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
    }
    return _containerView;
}


@end
