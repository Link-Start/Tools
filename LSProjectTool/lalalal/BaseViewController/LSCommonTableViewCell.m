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
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self addSubViews];
        [self addLayout];
    }
    return self;
}

#pragma mark - 添加subViews
- (void)addSubViews {
    
    [self addContentViewSubViews];
}

#pragma mark - 添加约束
- (void)addLayout {
    [self addContentViewSubViewsLayout];
}

#pragma mark - 添加其他子视图
- (void)addContentViewSubViews {
    
    
}
#pragma mark - 添加其他子视图约束
- (void)addContentViewSubViewsLayout {
    
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

#pragma mark - 懒加载

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
