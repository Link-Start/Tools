//
//  DefineColor.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/26.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

//颜色

#ifndef DefineColor_h
#define DefineColor_h

///rgb颜色转换（16进制->10进制） UIColorFromRGB(0xeef0f2)
#define UIColorFromRGB(rgbValue)         [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                         green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                          blue:((float)(rgbValue & 0xFF))/255.0 \
                                                         alpha:1.0]

// rgb颜色转换（16进制->10进制）
#define UIColorFromRGBA(rgbValue, alpha)      [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                              green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                               blue:((float)(rgbValue & 0xFF))/255.0 \
                                                              alpha:alpha]

///设置颜色 - RGBA  (R:红, G:绿, B:蓝, A:透明度) 利用这种方法设置颜色和透明值，可不影响子视图背景色
#define kRGBA(R, G, B, A)                     [UIColor colorWithRed:(R)/255.0f \
                                                              green:(G)/255.0f \
                                                               blue:(B)/255.0f \
                                                              alpha:(A)]
#define RGB(r,g,b) kRGBA(r,g,b,1.0f)

// 取色值相关的方法
#define RGBs(r,g,b)          [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:1.f]

#define RGBA(r,g,b,a)       [UIColor colorWithRed:(r)/255.f \
                                            green:(g)/255.f \
                                             blue:(b)/255.f \
                                            alpha:(a)]

#define RGBOF(rgbValue)     [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                             blue:((float)(rgbValue & 0xFF))/255.0 \
                                            alpha:1.0]

#define RGBA_OF(rgbValue)   [UIColor colorWithRed:((float)(((rgbValue) & 0xFF000000) >> 24))/255.0 \
                                             green:((float)(((rgbValue) & 0x00FF0000) >> 16))/255.0 \
                                              blue:((float)(rgbValue & 0x0000FF00) >> 8)/255.0 \
                                             alpha:((float)(rgbValue & 0x000000FF))/255.0]

#define RGBAOF(v, a)        [UIColor colorWithRed:((float)(((v) & 0xFF0000) >> 16))/255.0 \
                                            green:((float)(((v) & 0x00FF00) >> 8))/255.0 \
                                             blue:((float)(v & 0x0000FF))/255.0 \
                                            alpha:a]

//#define UIColorHex(_hex_)   [UIColor colorWithHexString:((__bridge NSString *)CFSTR(#_hex_))]

//清除背景色
#define kClearColor [UIColor clearColor]

///UIView背景色 偏蓝
#define UIViewDefaultBackgroundColor UIColorFromRGB(0xF0F1F5)
///细线的颜色
#define lineViewColor UIColorFromRGB(0xe8e8e8)


/**
 宏与const 的使用:
 
 很多小伙伴在定义一个常量字符串，都会定义成一个宏，最典型的例子就是服务器的地址。在此所有用宏定义常量字符的小伙伴以后就用const来定义吧！为什么呢 ？我们看看：
 
 宏的用法： 一般字符串抽成宏，代码抽成宏使用。
 
 const用法：一般常用的字符串定义成const（对于常量字符串苹果推荐我们使用const）。
 
 宏与const区别：
 
 1.编译时刻不同，宏属于预编译 ，const属于编译时刻
 
 2.宏能定义代码，const不能，多个宏对于编译会相对时间较长，影响开发效率，调试过慢，const只会编译一次，缩短编译时间。
 
 3.宏不会检查错误，const会检查错误
 
 通过以上对比，我们以后在开发中如果定义一个常量字符串就用const，定义代码就用宏
 
 我们创建一个类只要在.h和.m中包含#import <Foundation/Foundation.h>就可以，然后再.h文件声明一个字符串，在.m中实现就可以了，最后把这个类导入PCH文件中
 
 
 */


#endif /* DefineColor_h */
