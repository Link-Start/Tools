//
//  UIAlertController+LSAlertSetting.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/2/29.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import "UIAlertController+LSAlertSetting.h"
#import <objc/runtime.h>

@implementation UIAlertController (LSAlertSetting)


// 自己来实现 setter 和 getter
@dynamic titleColor;
@dynamic titleFont;
@dynamic messageColor;
@dynamic messageFont;


#pragma mark - title 颜色
/// titleColor 标题 颜色的 getter 和 setter
static char *titleColorKey = "titleColorKey";

- (UIColor *)titleColor {
    id color = objc_getAssociatedObject(self, titleColorKey);
    if (color == nil) {
        return [UIColor darkTextColor];
    } else {
        return color;
    }
}

- (void)setTitleColor:(UIColor *)titleColor {
    objc_setAssociatedObject(self, titleColorKey, titleColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableDictionary *attributesDict = [NSMutableDictionary dictionary];
    attributesDict[NSFontAttributeName] = self.titleFont;
    attributesDict[NSForegroundColorAttributeName] = titleColor;
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:attributesDict];
    [self setValue:attributedString forKey:@"attributedTitle"];
}

#pragma mark - title 字体
/// titleFont 标题字体的 getter 和 setter
static char *titleFontKey = "titleFontKey";

- (UIFont *)titleFont {
    id font = objc_getAssociatedObject(self, titleFontKey);
    if (font == nil) {
        return [UIFont systemFontOfSize:15];
    } else {
        return font;
    }
}

- (void)setTitleFont:(UIFont *)titleFont {
    objc_setAssociatedObject(self, titleFontKey, titleFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableDictionary *attributesDict = [NSMutableDictionary dictionary];
    attributesDict[NSFontAttributeName] = titleFont;
    attributesDict[NSForegroundColorAttributeName] = self.titleColor;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:attributesDict];
    [self setValue:attributedString forKey:@"attributedTitle"];
}

#pragma mark - title 标题的富文本属性
/// titleAttributedString 为标题赋值的富文本属性 getter 和 setter
static char *titleAttributedStringKey = "titleAttributedStringKey";

- (NSAttributedString *)titleAttributedString {
    return [self valueForKey:@"attributedTitle"];
}

- (void)setTitleAttributedString:(NSAttributedString *)titleAttributedString {
    objc_setAssociatedObject(self, titleAttributedStringKey, titleAttributedString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setValue:titleAttributedString forKey:@"attributedTitle"];
}


#pragma mark - message 颜色
/// messageColor message 颜色的 getter 和 setter
static char *messageColorKey = "messageColorKey";

- (UIColor *)messageColor {
    id color = objc_getAssociatedObject(self, messageColorKey);
    if (color == nil) {
        return [UIColor darkGrayColor];
    } else {
        return color;
    }
}

- (void)setMessageColor:(UIColor *)messageColor {
    objc_setAssociatedObject(self, messageColorKey, messageColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableDictionary *attributesDict = [NSMutableDictionary dictionary];
    attributesDict[NSFontAttributeName] = self.messageFont;
    attributesDict[NSForegroundColorAttributeName] = messageColor;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:attributesDict];
    [self setValue:attributedString forKey:@"attributedMessage"];
}

#pragma mark - message 字体
/// message 字体的 getter 和 setter
static char *messageFontKey = "messageFontKey";

- (UIFont *)messageFont {
    id font = objc_getAssociatedObject(self, messageFontKey);
    if (font == nil) {
        return [UIFont systemFontOfSize:15];
    } else {
        return font;
    }
}

- (void)setMessageFont:(UIFont *)messageFont {
    objc_setAssociatedObject(self, messageFontKey, messageFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableDictionary *attributesDict = [NSMutableDictionary dictionary];
    attributesDict[NSFontAttributeName] = messageFont;
    attributesDict[NSForegroundColorAttributeName] = self.messageColor;
    
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:self.title attributes:attributesDict];
    [self setValue:attributedString forKey:@"attributedMessage"];
}

#pragma mark - message 的富文本属性

/// messageAttributedString 为 message 赋值的富文本属性 的 getter 和 setter
static char *messageAttributedStringKey = "messageAttributedStringKey";

- (NSAttributedString *)messageAttributedString {
    return [self valueForKey:@"attributedMessage"];
}

- (void)setMessageAttributedString:(NSAttributedString *)messageAttributedString {
    objc_setAssociatedObject(self, messageAttributedStringKey, messageAttributedString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setValue:messageAttributedString forKey:@"attributedMessage"];
}





@end
