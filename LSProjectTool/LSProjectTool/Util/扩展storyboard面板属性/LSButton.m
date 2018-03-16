//
//  LSButton.m
//  RuiTuEBusiness
//
//  Created by Link_Start on 2018/2/9.
//  Copyright © 2018年 Naive. All rights reserved.
//

#import "LSButton.h"

@implementation LSButton
/*************** 可以扩展 storyboard 的属性面板 ***************/
- (void)setLs_borderWidth:(CGFloat)ls_borderWidth {
    _ls_borderWidth = ls_borderWidth;
    self.layer.borderWidth = ls_borderWidth;
    self.layer.masksToBounds = YES;
}

- (void)setLs_borderColor:(UIColor *)ls_borderColor {
    _ls_borderColor = ls_borderColor;
    self.layer.borderColor = ls_borderColor.CGColor;
}

- (void)setLs_cornerRadius:(CGFloat)ls_cornerRadius {
    _ls_cornerRadius = ls_cornerRadius;
    self.layer.cornerRadius = ls_cornerRadius;
    self.layer.masksToBounds = YES;
//    self.clipsToBounds = YES;
}
//下划线颜色
- (void)setLs_underlineColor:(UIColor *)ls_underlineColor {
    //字符串
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:self.titleLabel.text];
    //范围
    NSRange strRange = NSMakeRange(0, str.length);
    //添加下划线
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    //设置下划线的颜色
    [str addAttribute:NSUnderlineColorAttributeName value:ls_underlineColor range:strRange];
    self.titleLabel.attributedText = str;
}

//图片距离上下的距离
- (CGFloat)ls_space {
    if (!_ls_space) {
        _ls_space = 0;
    }
    return _ls_space;
}

- (void)setLs_style:(LSButtonStyle)ls_style {
    _ls_style = ls_style;
    //label的宽度
    CGFloat labelWidth = self.titleLabel.frame.size.width;
    //label的高度
    CGFloat labelHeight = self.titleLabel.frame.size.height;
    //button的image
    UIImage *btnImage = self.imageView.image;
    //设置后的image显示的高度
    CGFloat imageHeight = self.frame.size.height - (2 * self.ls_space);
    //文字和图片居中显示时距离两边的距离
    CGFloat edgeSpace = (self.frame.size.width - imageHeight - labelWidth - self.ls_padding)/2;
    if (ls_style == LSButtonStyleNormal) {//默认图片在左
        self.imageEdgeInsets = UIEdgeInsetsMake(self.ls_space, edgeSpace, self.ls_space, edgeSpace+labelWidth+self.ls_padding);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -btnImage.size.width+imageHeight+self.ls_padding, 0, 0);
        
    } else if (ls_style == LSButtonStyleImageRight) {
        self.imageEdgeInsets = UIEdgeInsetsMake(self.ls_space, edgeSpace+labelWidth+self.ls_padding, self.ls_space, edgeSpace);
        self.titleEdgeInsets = UIEdgeInsetsMake(0, -btnImage.size.width-self.ls_padding-imageHeight, 0, 0);
        
    } else if (ls_style == LSButtonStyleImageTop) {
        //设置后的image显示的高度
        imageHeight = self.frame.size.height - (2 * self.ls_space) - labelHeight - self.ls_padding;
        if (imageHeight > btnImage.size.height) {
            imageHeight = btnImage.size.height;
        }
        self.imageEdgeInsets = UIEdgeInsetsMake(self.ls_space, (self.frame.size.width - imageHeight) / 2, self.ls_space + labelHeight + self.ls_padding, (self.frame.size.width - imageHeight) / 2);
        self.titleEdgeInsets = UIEdgeInsetsMake(self.ls_space + imageHeight + self.ls_padding, -btnImage.size.width, self.ls_space, 0);
    } else if (ls_style == LSButtonStyleImageBottom) {
        //设置后的image显示的高度
        imageHeight = self.frame.size.height - (2 * self.ls_space) - labelHeight - self.ls_padding;
        if (imageHeight > btnImage.size.height) {
            imageHeight = btnImage.size.height;
        }
        self.imageEdgeInsets = UIEdgeInsetsMake(self.ls_space + labelHeight + self.ls_padding, (self.frame.size.width - imageHeight) / 2, self.ls_space, (self.frame.size.width - imageHeight) / 2);
        self.titleEdgeInsets = UIEdgeInsetsMake(self.ls_space, -btnImage.size.width, self.ls_padding + imageHeight + self.ls_space, 0);
    }
}

- (void)setLs_isSelectedBgColor:(UIColor *)ls_isSelectedBgColor {
    _ls_isSelectedBgColor = ls_isSelectedBgColor;
}

- (void)setLs_isSelected:(BOOL)ls_isSelected {
    _ls_isSelected = ls_isSelected;
    if (_ls_isSelected == YES) {
        [self setBackgroundColor:_ls_isSelectedBgColor];
        [self setTitleColor:_ls_isSelectedTitleColor forState:self.state];
    } else {
        [self setBackgroundColor:_ls_isNotSelectedBgColor];
        [self setTitleColor:_ls_isNotSelectedTitleColor forState:self.state];
    }
}


/***************  button  属性 ***************/

//圆角
- (LSButton *(^)(CGFloat))ls_buttonCornerRadius {
    __weak __typeof(self)weakSelf = self;
    return ^LSButton *(CGFloat cornerRadius) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        strongSelf.layer.cornerRadius = cornerRadius;
        strongSelf.layer.masksToBounds = YES;
        return strongSelf;
    };
}


- (LSButton *)ls_with {
    return self;
}
- (LSButton *)ls_and {
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
