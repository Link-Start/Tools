//
//  LSLabel.m
//  RuiTuEBusiness
//
//  Created by Alex Yang on 2018/2/9.
//  Copyright © 2018年 Naive. All rights reserved.
//

#import "LSLabel.h"

@implementation LSLabel

//删除线
- (void)setLs_deleteLineRange:(NSRange)ls_deleteLineRange {
    if (self.text.length > 0) {
        NSRange tempRange = ls_deleteLineRange;
        if (tempRange.length == 0 && tempRange.location == 0) {//如果range(0,0)设置所有字符串都加删除线
            tempRange.length = self.text.length;//
        }
        if (tempRange.length + tempRange.location > self.text.length) { //超出字符串范围
            tempRange.length = self.text.length - tempRange.location;//只取到字符串最后一位
        }        
        
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleNone)}];
        [attriStr setAttributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle), NSBaselineOffsetAttributeName:@0} range:tempRange];
        self.attributedText = attriStr;
    }
}

//下划线
- (void)setLs_underLineRange:(NSRange)ls_underLineRange {
    if (self.text.length > 0) {
        NSRange tempRange = ls_underLineRange;
        if (tempRange.length == 0 && tempRange.location == 0) {//如果range(0,0)设置所有字符串都加删除线
            tempRange.length = self.text.length;//
        }
        if (tempRange.length + tempRange.location > self.text.length) { //超出字符串范围
            tempRange.length = self.text.length - tempRange.location;//只取到字符串最后一位
        }
        NSMutableAttributedString *attriStr = [[NSMutableAttributedString alloc] initWithString:self.text attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleNone)}];
        [attriStr setAttributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle)} range:tempRange];
        self.attributedText = attriStr;
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
