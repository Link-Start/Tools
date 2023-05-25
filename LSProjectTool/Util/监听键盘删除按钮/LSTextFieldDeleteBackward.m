//
//  LSTextFieldDeleteBackward.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/5/11.
//  Copyright © 2023 Link-Start. All rights reserved.
//  https://www.jianshu.com/p/77bfe5d84961

#import "LSTextFieldDeleteBackward.h"

@implementation LSTextFieldDeleteBackward

- (void)deleteBackward {
    [super deleteBackward];//这里要调用super方法，要不然删不了东西
    
    if ([self.ls_delegate respondsToSelector:@selector(ls_textFieldDidDeleteBackward:)]) {
        [self.ls_delegate ls_textFieldDidDeleteBackward:self];
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
