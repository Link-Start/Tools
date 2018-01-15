//
//  MyButton.m
//  DianDianXiYi
//
//  Created by Xcode on 16/8/2.
//  Copyright © 2016年 mycard. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (void)setBorderColor:(UIColor *)borderColor {
    self.layer.masksToBounds = YES;
    self.layer.borderColor = borderColor.CGColor;
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
}

- (void)setCornerRadius:(CGFloat)cornerRadius {
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = cornerRadius;
}

+ (instancetype)buttonInitWith:(void (^)(MyButton *))initBlock {
    MyButton *btn = [[MyButton alloc] init];
    if (initBlock) {
        initBlock(btn);
    }
    return btn;
}

- (MyButton *(^)(CGRect))ButtonFrame {
    return ^MyButton *(CGRect rect) {
        self.frame = rect;
        return self;
    };
}

- (MyButton *(^)(UIColor *))ButtonBgColor {
    return ^MyButton *(UIColor *color) {
        self.backgroundColor = color;
        return self;
    };
}

- (MyButton *(^)(NSString *, UIColor *, CGFloat))ButtonStr {
    return ^MyButton *(NSString *str, UIColor *color, CGFloat fontSize) {
        [self setTitle:str forState:UIControlStateNormal];
        [self setTitleColor:color forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:fontSize];
        
        return self;
    };
}

@end
