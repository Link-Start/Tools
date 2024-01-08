//
//  SettingTableViewBindActionModelCell.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/11/17.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "SettingTableViewBindActionModelCell.h"
#import "SettingTableViewBindActionModel.h"



@interface SettingTableViewBindActionModelCell ()

@property (nonatomic, strong) UIImageView *leftImgV;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UIImageView *rightImgV;

@end

@implementation SettingTableViewBindActionModelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(SettingTableViewBindActionModel *)model {
    _model = model;
    
    self.leftImgV.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", model.leftImgName?:@""]];
    self.leftLabel.text = model.leftLabelStr?:@"";
    self.rightImgV.hidden = !model.isMore;
    self.rightLabel.text = model.rightLabelStr?:@"";
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
    NSArray *subsArray = @[self.leftImgV, self.leftLabel, self.rightLabel, self.rightImgV];
    
    [subsArray enumerateObjectsUsingBlock:^(UIView *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
}
#pragma mark - 添加其他子视图约束
- (void)addContentViewSubViewsLayout {
    self.leftImgV.frame = CGRectMake(15, 5, 30, 30);
    self.leftLabel.frame = CGRectMake(self.leftImgV.frame.origin.y + 5, 10, 200, 30);
    self.rightLabel.frame = CGRectMake(kLS_ScreenWidth-15-150, 10, 150, 30);
    self.rightImgV.frame = CGRectMake(kLS_ScreenWidth-15-20, 10, 20, 20);
}

#pragma mark - 懒加载
- (UILabel *)leftLabel {
    if (!_leftLabel) {
        _leftLabel = [[UILabel alloc] init];
        _leftLabel.font = [UIFont systemFontOfSize:13];
//        _leftLabel.textColor = UIColor_333333;
    }
    return _leftLabel;
}

- (UIImageView *)leftImgV {
    if (!_leftImgV) {
        _leftImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
    }
    return _leftImgV;
}

- (UILabel *)rightLabel {
    if (!_rightLabel) {
        _rightLabel = [[UILabel alloc] init];
        _rightLabel.font = [UIFont systemFontOfSize:13];
        _rightLabel.textColor = [UIColor redColor];

    }
    return _rightLabel;
}

- (UIImageView *)rightImgV {
    if (!_rightImgV) {
        _rightImgV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"more"]];
    }
    return _rightImgV;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
