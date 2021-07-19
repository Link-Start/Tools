//
//  NSString+LSCategory.h
//  LSProjectTool
//
//  Created by Xcode on 16/10/10.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (LSCategory)

/// 判断是否为空
- (BOOL)isNotEmpty;
/// 去除字符串空格和回车字符
- (NSString *)trimWhitespaceAndNewline;
/// 是否包含字符 YES:是
- (BOOL)containsCharacterSet:(NSCharacterSet *)set;
/// 是否包含字符串 YES:是
- (BOOL)containsString:(NSString *)string;
/// 查找指定字符串出现的次数
- (NSInteger)countOccurencesOfString:(NSString*)searchString;
/// 获取字符数量
- (int)wordsCount;
/// 获取内容字符长度          通过分别计算中文和其他字符来计算长度
- (NSUInteger)getContentLength:(NSString*)content;

/// URL编码(UTF-8)
- (NSString *)URLEncodedString;
/// URL解码(UTF-8)
- (NSString *)URLDecodedString;

/// URL
- (NSURL *)URL;
/// 文件URL
- (NSURL *)fileURL;

/// MD5加密
- (NSString *)MD5String;

/// 是否全是数字
- (BOOL)isNumber;
/// 是否全是英文字母
- (BOOL)isEnglishWords;
/// 是否全是中文汉字
- (BOOL)isChineseWords;

/// 是否为邮箱
- (BOOL)isEmail;
/// 是否为网络链接
- (BOOL)isURL;
/// 是否为电话号码
- (BOOL)isPhoneNumber;
/// 是否为手机号码
- (BOOL)isMobilePhoneNumber;
/// 是否为身份证号码(15或18位)
- (BOOL)isIdentifyCardNumber;
/// 是否为组织机构代码
- (BOOL)isOrganizationCode;

/// 验证密码(6—18位, 只能包含字符、数字和下划线)
- (BOOL)isValidPassword;
/// 验证名称(只能由中英文、数字、下划线组成)
- (BOOL)isValidName;


/// 字符串转时间
/// @param dateFormat 时间字符串
- (NSDate *)dateWithFormat:(NSString *)dateFormat;


/// 计算文字的高度
/// @param font 字体(默认为系统字体)
/// @param width 约束宽度
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/// 计算文字的宽度
/// @param font  字体(默认为系统字体)
/// @param height 约束高度
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/// 计算文字的大小
/// @param font 字体(默认为系统字体)
/// @param width 约束宽度
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/// 计算文字的大小
/// @param font  字体(默认为系统字体)
/// @param height 约束高度
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/// 计算文字高度，可以处理计算带行间距的等属性
/// @param size
/// @param paragraphStyle <#paragraphStyle description#>
/// @param font 字体
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font;
/// 计算文字高度，可以处理计算带行间距的
/// @param size size description
/// @param font 字体
/// @param lineSpacing 行间距
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;
/// 计算固定行数的文字高度，可以处理计算带行间距的
/// @param size
/// @param font 字体
/// @param lineSpacing 行间距
/// @param maxLines 最大行数
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

/// 计算是否超过一行
/// @param size CGSize(固定宽度值,CGFLOAT_MAX)        不限制高度,才能判断行数
/// @param font 字体
/// @param lineSpacing 行间距
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;
/// 计算行数
/// @param size  CGSize(固定宽度值,CGFLOAT_MAX) 不限制高度, 计算行数
/// @param font 字体
/// @param lineSpacing 行间距
- (NSInteger)boundingRectNumberOfLineWithSize:(CGSize)size font:(UIFont*)font lineSpacing:(CGFloat)lineSpacing;


@end
