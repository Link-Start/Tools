//
//  ClassExtension.h
//  Tractor
//
//  Created by Xcode on 16/6/24.
//  Copyright © 2016年 mc. All rights reserved.
//

/*
//类扩展 （Class Extension也有人称为匿名分类）
   //作用：
        //1.能为某个类附加额外的属性，成员变量，方法声明
        //2.一般的类扩展写到.m文件中
        //3.一般的私有属性写到类扩展
   //使用格式：
         //@interface Mitchell()     //类扩展(Extension)的小括号中没有名字
             //属性
             //方法
         //@end

//分类 (category) 又叫类目
     //作用：
           // 1.分类只能扩充方法，不能扩展属性和成员变量（如果包含成员变量会直接报错）[可以通过runtime去关联增加一个额外的属性]
           // 2.如果分类中声明了一个属性，那么分类只会生成这个属性的set、get方法声明，也就是不会有实现。
    //使用格式：
             //@interface 类名（分类名字）      //分类的小括号中必须有名字
                   //方法声明
             //@end
             //@implementation类名（分类名字）
                   //方法实现
             //@end

*/

#pragma mark - 类别、分类、类目 category 的小括号中必须有名字

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

///给类增加方法
@interface ClassExtension : NSObject

@end

//*********************************************************  NSString
#pragma mark - NSString 扩展
@interface NSString (Extension)
/**
 *  返回值是该字符串所占的大小(width, height)
 *
 *  @param
 *  @param font: 该字符串所用的字体(字体大小不一样,显示出来的面积也不同)
 *  @param maxSize : 为限制该字体的最大宽和高(如果显示一行,则宽高都设置为MAXFLOAT, 如果显示为多行,只需将宽设置一个有限定的值,高设置为MAXFLOAT)
 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

///UTF8 编码 也可以直接使用系统的方法
- (NSString *)URLEncodingUTF8String;//
///UTF8 解码
- (NSString *)URLDecodingUTF8String;//解码


@end

//*********************************************************  UIColor
#pragma mark - UIColor 扩展
@interface UIColor (Extension)
/**
 *  颜色转换 IOS中十六进制的颜色转换为UIColor
 *
 *  @param color 十六进制颜色值 支持@“#123456”、 @“0X123456”、 @“123456”三种格式
 *
 *  @return UIColol 颜色
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

///颜色转换 IOS中十六进制的颜色转换为UIColor
+ (instancetype)colorFromHexString:(NSString *)hexString;


@end

//*********************************************************
#pragma mark - NSDictionary 扩展
@interface NSDictionary (Extension)
/*
 NSLog打印 NSDictionary 时会自动进行如下操作,方便数组在线校验及格式化
 //1.自动补全缺失""
 //2.自动转换数组()转换为[]
 //3.自动转换unicode编码为中文
*/

//######################
//######################
/*!
*  @brief 根据key值 取出一个安全的value
*
*  @param key key
*
*  @return 如果所要取的对象为空,返回空字符串
*/
- (id)getSafeValueWithKey:(id)key;
@end

//*********************************************************
#pragma mark - NSArray 扩展
@interface NSArray (Extension)
// 判断数组是否为空的方法，数组为空返回YES,数组不为空返回NO
+ (BOOL)isEmptyArray:(NSArray *)array;

@end

//*********************************************************











