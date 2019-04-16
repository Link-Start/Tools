//
//  DataConversion.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/2.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataConversion : NSObject

///将NSData转换成十六进制的字符串
+ (NSString *)convertDataToHexStr:(NSData *)data;
///十六进制字符串转换成NSData
+ (NSData *)convertHexStrToData:(NSString *)str;

///将NSString转换成十六进制的字符串
+ (NSString *)convertStringToHexStr:(NSString *)str;
///将NSString转换为十六进制的字符串
+ (NSString *)hexStringFromString:(NSString *)string;

///将十六进制的字符串转换成NSString
+ (NSString *)convertHexStrToString:(NSString *)str;

@end
