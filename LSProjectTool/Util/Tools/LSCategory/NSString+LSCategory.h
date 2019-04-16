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

/************** @brief 判断是否为空 **************/
- (BOOL)isNotEmpty;
/************** @brief 去除字符串空格和回车字符 **************/
- (NSString *)trimWhitespaceAndNewline;
/************** @brief 是否包含字符 YES:是 **************/
- (BOOL)containsCharacterSet:(NSCharacterSet *)set;
/************** @brief 是否包含字符串 YES:是 **************/
- (BOOL)containsString:(NSString *)string;
/************** @brief 获取字符数量 **************/
- (int)wordsCount;

/************** @brief URL编码(UTF-8) **************/
- (NSString *)URLEncodedString;
/************** @brief URL解码(UTF-8) **************/
- (NSString *)URLDecodedString;

/************** @brief URL **************/
- (NSURL *)URL;
/************** @brief 文件URL **************/
- (NSURL *)fileURL;

/************** @brief MD5加密 **************/
- (NSString *)MD5String;

/************** @brief 是否全是数字 **************/
- (BOOL)isNumber;
/************** @brief 是否全是英文字母 **************/
- (BOOL)isEnglishWords;
/************** @brief 是否全是中文汉字 **************/
- (BOOL)isChineseWords;

/************** @brief 是否为邮箱 **************/
- (BOOL)isEmail;
/************** @brief 是否为网络链接 **************/
- (BOOL)isURL;
/************** @brief 是否为电话号码 **************/
- (BOOL)isPhoneNumber;
/************** @brief 是否为手机号码 **************/
- (BOOL)isMobilePhoneNumber;
/************** @brief 是否为身份证号码(15或18位) **************/
- (BOOL)isIdentifyCardNumber;
/************** @brief 是否为组织机构代码 **************/
- (BOOL)isOrganizationCode;

/************** @brief 验证密码(6—18位, 只能包含字符、数字和下划线) **************/
- (BOOL)isValidPassword;
/************** @brief 验证名称(只能由中英文、数字、下划线组成) **************/
- (BOOL)isValidName;

/************** @brief 字符串转时间 **************/
- (NSDate *)dateWithFormat:(NSString *)format;

/**
 *  @brief 计算文字的高度
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的宽度
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGFloat)widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

/**
 *  @brief 计算文字的大小
 *
 *  @param font  字体(默认为系统字体)
 *  @param width 约束宽度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
/**
 *  @brief 计算文字的大小
 *
 *  @param font   字体(默认为系统字体)
 *  @param height 约束高度
 */
- (CGSize)sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;
/**
 * 计算文字高度，可以处理计算带行间距的等属性
 */
- (CGSize)boundingRectWithSize:(CGSize)size paragraphStyle:(NSMutableParagraphStyle *)paragraphStyle font:(UIFont*)font;
/**
 * 计算文字高度，可以处理计算带行间距的
 */
- (CGSize)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing;
/**
 * 计算最大行数文字高度，可以处理计算带行间距的
 */
- (CGFloat)boundingRectWithSize:(CGSize)size font:(UIFont*)font  lineSpacing:(CGFloat)lineSpacing maxLines:(NSInteger)maxLines;

/**
 *  计算是否超过一行
 */
- (BOOL)isMoreThanOneLineWithSize:(CGSize)size font:(UIFont *)font lineSpaceing:(CGFloat)lineSpacing;



@end
