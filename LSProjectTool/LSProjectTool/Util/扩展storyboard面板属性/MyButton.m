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

@end
