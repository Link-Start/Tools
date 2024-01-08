//
//  LSUserCenterTabCell.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/8/24.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#import "LSUserCenterTabCell.h"
#import "LSUserCenterItemModel.h"
#import "UIView+LSCategory.h"
#import "UIView+YYAdd.h"

#define XBDetailViewToIndicatorGap 10
#define kXBFuncImgToLeftGap 10
#define XBFuncLabelToFuncImgGap 10
#define XBIndicatorToRightGap 10


@interface LSUserCenterTabCell ()

@property (nonatomic, strong) UILabel *funcNameLabel;

@property (nonatomic, strong) UIImageView *imgView;

@property (nonatomic, strong) UIImageView *indicator;

@property (nonatomic, strong) UISwitch *aswitch;

@property (nonatomic, strong) UILabel *detailLabel;

@property (nonatomic, strong) UIImageView *detailImageView;


@end

@implementation LSUserCenterTabCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setItem:(LSUserCenterItemModel *)item {
    _item = item;
    
    [self updateUI];
}

- (void)updateUI {
    
    // 移除所有的子视图
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //如果有图片
    if (self.item.img) {
        [self setupImgView];
    }
    // 功能名称
    if (self.item.funcName) {
        [self setupFuncLabel];
    }
    // 右侧指示器类型
    if (self.item.accessorType) {
        [self setupAccessoryType];
    }
    // 详情
    if (self.item.detailText) {
        [self setupDetailText];
    }
    if (self.item.detailImage) {
        [self setupDetailImage];
    }
    
    // 底部细线
    UIView *lineH = [[UIView alloc] initWithFrame:CGRectMake(0, self.contentView.frame.size.height-0.5, self.contentView.frame.size.width, 0.5)];
    lineH.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    [self.contentView addSubview:lineH];
}

- (void)setupImgView {
    self.imgView = [[UIImageView alloc] initWithImage:self.item.img];
    self.imgView.ls_x = kXBFuncImgToLeftGap;
    self.imgView.centerX = self.contentView.centerY;
    [self.contentView addSubview:self.imgView];
}

- (void)setupFuncLabel {
    self.funcNameLabel = [[UILabel alloc]init];
    self.funcNameLabel.text = self.item.funcName;
    self.funcNameLabel.textColor = [UIColor blackColor];
    self.funcNameLabel.font = [UIFont systemFontOfSize:13];
    self.funcNameLabel.size = [self sizeForTitle:self.item.funcName withFont:self.funcNameLabel.font];
    self.funcNameLabel.centerY = self.contentView.centerY;
    self.funcNameLabel.ls_x = CGRectGetMaxX(self.imgView.frame) + XBFuncLabelToFuncImgGap;
    [self.contentView addSubview:self.funcNameLabel];
}
- (void)setupAccessoryType {
    switch (self.item.accessorType) {
        case LSUserCenterAccessoryTypeNone:
            break;
        case LSUserCenterAccessoryTypeDiscloseureIndicator: {
            [self setupIndicator];
        }
            break;
        case LSUserCenterAccessoryTypeSwitch: {
            [self setupSwitch];
        }
            break;
        default:
            break;
    }
}
- (void)setupIndicator {
    [self.contentView addSubview:self.indicator];
}
- (void)setupSwitch {
    [self.contentView addSubview:self.aswitch];
}

- (void)setupDetailText {
    
    self.detailLabel = [[UILabel alloc] init];
    self.detailLabel.text = self.item.detailText?:@"";
    self.detailLabel.textColor = [UIColor blackColor];
    self.detailLabel.font = [UIFont systemFontOfSize:13];
    self.detailLabel.ls_size = [self sizeForTitle:self.item.detailText withFont:self.detailTextLabel.font];
    self.detailTextLabel.ls_centerY = self.contentView.ls_centerY;
    
    switch (self.item.accessorType) {
        case LSUserCenterAccessoryTypeNone: {
            self.detailLabel.ls_x = kLS_ScreenWidth-self.detailLabel.ls_width-XBDetailViewToIndicatorGap;
        }
            break;
        case LSUserCenterAccessoryTypeDiscloseureIndicator: {
            self.detailLabel.ls_x = self.indicator.ls_x - self.detailLabel.ls_width-XBDetailViewToIndicatorGap;
        }
            break;
        case LSUserCenterAccessoryTypeSwitch: {
            self.detailLabel.ls_x = self.aswitch.ls_x - self.detailLabel.ls_width - XBDetailViewToIndicatorGap;
        }
            break;
        default:
            break;
    }
    
    [self.contentView addSubview:self.detailLabel];
}

// 根据文字和字体计算宽高
- (CGSize)sizeForTitle:(NSString *)title withFont:(UIFont *)font {
    CGRect titleRect = [title boundingRectWithSize:CGSizeMake(FLT_MAX, FLT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
    return CGSizeMake(titleRect.size.width, titleRect.size.height);
}

- (void)setupDetailImage {
    self.detailImageView = [[UIImageView alloc] initWithImage:self.item.detailImage];
    self.detailImageView.ls_centerY = self.contentView.ls_centerY;
    
    switch (self.item.accessorType) {
        case LSUserCenterAccessoryTypeNone: {
            self.detailImageView.ls_x = kLS_ScreenWidth-self.detailImageView.ls_width-XBDetailViewToIndicatorGap;
        }
            break;
            
        case LSUserCenterAccessoryTypeDiscloseureIndicator: {
            self.detailImageView.ls_x = self.indicator.ls_x - self.detailImageView.ls_width-XBDetailViewToIndicatorGap;
        }
            break;
        case LSUserCenterAccessoryTypeSwitch: {
            self.detailImageView.ls_x = self.aswitch.ls_x - self.detailImageView.ls_width - XBDetailViewToIndicatorGap;
        }
            break;
        default:
            break;
    }
    
    [self.contentView addSubview:self.detailImageView];
}


- (UIImageView *)indicator {
    if (!_indicator) {
        _indicator = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"icon-arrow1"]];
        _indicator.centerY = self.contentView.centerY;
        _indicator.ls_x = kLS_ScreenWidth - _indicator.width - XBIndicatorToRightGap;
    }
    return _indicator;
}
 
- (UISwitch *)aswitch {
    if (!_aswitch) {
        _aswitch = [[UISwitch alloc]init];
        _aswitch.centerY = self.contentView.centerY;
        _aswitch.ls_x = kLS_ScreenWidth - _aswitch.width - XBIndicatorToRightGap;
        [_aswitch addTarget:self action:@selector(switchTouched:) forControlEvents:UIControlEventValueChanged];
    }
    return _aswitch;
}
 
- (void)switchTouched:(UISwitch *)sw {
    __weak typeof(self) weakSelf = self;
    self.item.switchValueChanged(weakSelf.aswitch.isOn);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
