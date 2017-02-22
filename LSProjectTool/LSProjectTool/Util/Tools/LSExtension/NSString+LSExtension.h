//
//  NSString+LSExtension.h
//  LSProjectTool
//
//  Created by Xcode on 16/10/9.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (LSExtension)
/**
 *  驼峰转下划线（loveYou -> love_you）
 */
- (NSString *)ls_underlineFromCamel;
/**
 *  下划线转驼峰（love_you -> loveYou）
 */
- (NSString *)ls_camelFromUnderline;
/**
 * 首字母变大写
 */
- (NSString *)ls_firstCharUpper;
/**
 * 首字母变小写
 */
- (NSString *)ls_firstCharLower;

- (BOOL)ls_isPureInt;

- (NSURL *)ls_url;

@end
