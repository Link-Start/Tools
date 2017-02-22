//
//  ClassExtension.m
//  Tractor
//
//  Created by Xcode on 16/6/24.
//  Copyright © 2016年 mc. All rights reserved.
//

#import "ClassExtension.h"

@implementation ClassExtension

@end

//*********************************************************  NSString
#pragma mark - 类扩展

#pragma mark - NSString 扩展
//NSString 扩展
@implementation NSString (Extension)
//返回字符串所占用的尺寸.
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

/// UTF8 编码 
- (NSString *)URLEncodingUTF8String { //如果其中含有已转义的%等符号时,又会再次转义而导致错误,所以使用方法
    
    NSString *resultStr = nil;
#if __has_feature(objc_arc)
// ARC
    resultStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)self,NULL,CFSTR("!*'();:@&=+$,/?%#[]"),kCFStringEncodingUTF8));
#else
// MRC
    resultStr = (NSString *)CFURLCreateStringByAddingPercentEscapes
    (kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8);
    
#endif
    return resultStr;
}

/// UTF8 解码
- (NSString *)URLDecodingUTF8String {
    NSString *resultStr = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,(CFStringRef)self,CFSTR(""),kCFStringEncodingUTF8));
    return resultStr;
}





@end

//*********************************************************  UIColor
#pragma mark - UIColor 扩展
@implementation UIColor (Extension)
#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *)colorWithHexString:(NSString *)color {
    //去掉前后空格换行符
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    //字符 应该6 - 8 位之间
    // String should be 6 or 8 characters
    //如果 < 6
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // 如果 以 0x 开头
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
        //substringFromIndex表示从指定位置开始截取字符串到最后，所截取位置包含该指定位置。
        cString = [cString substringFromIndex:2];
    // 如果 以 # 开头 那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    
    // 如果 != 6
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    //位置
    range.location = 0;
    //长度
    range.length = 2;
    
    //substringWithRange 需要传进来NSRange类型，
    //表示从哪里开始截取 和 截取的长度，返回字符串类型
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // 获取r g b 值
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    //返回 UIColor 颜色
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:1.0f];
}

/// IOS中十六进制的颜色转换为UIColor
+ (instancetype)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    hexString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner scanHexInt:&rgbValue];
    
    return [[self class] colorWithR:((rgbValue & 0xFF0000) >> 16) G:((rgbValue & 0xFF00) >> 8) B:(rgbValue & 0xFF) A:1.0];
}
+ (instancetype)colorWithR:(CGFloat)red G:(CGFloat)green B:(CGFloat)blue A:(CGFloat)alpha {
    return [[self class] colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}


@end

//********************************************************* NSDictionary
#pragma mark - NSDictionary
@implementation NSDictionary (Extension)
#if DEBUG
- (NSString *)descriptionWithLocale:(nullable id)locale {
    
    //111111111111
    NSString *logString;
    @try {
        logString=[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
        
    } @catch (NSException *exception) {
        
        NSString *reason = [NSString stringWithFormat:@"reason:%@",exception.reason];
        logString = [NSString stringWithFormat:@"转换失败:\n%@,\n转换终止,输出如下:\n%@",reason,self.description];
        
    } @finally {
        
    }
    return logString;
    
    //222222222222222222222222
//    NSArray *allKeys = [self allKeys];
//      NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"{\t\n "];
//        for (NSString *key in allKeys) {
//              id value= self[key];
//             [str appendFormat:@"\t \"%@\" = %@,\n",key, value];
//        }
//      [str appendString:@"\t}"];
//    
//      return str;
}

///根据key值 取出一个安全的value
- (id)getSafeValueWithKey:(id)key {
    
    if (self == nil) {
        return @"";
    }
    if (key == nil) {
        return @"";
    }
    id object = [self objectForKey:key];
    if (object == nil) {
        return @"";
    }
    if (object == NULL) {
        return @"";
    }
    if (object == [NSNull null]) {
        return @"";
    }
    if ([object isKindOfClass:[NSNumber class]]) {
        return [object stringValue];
    }
    if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@"(null)"]) {
        return @"";
    }
    return [self objectForKey:key];
}


- (BOOL)boolObjectOfData:(id)key {
    
    if (self == nil) {
        return NO;
    }
    if (key == nil) {
        return NO;
    }
    id object = [self objectForKey:key];
    if (object == nil) {
        return NO;
    }
    if (object == NULL) {
        return NO;
    }
    if (object == [NSNull null]) {
        return NO;
    }
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *arr = (NSArray *)object;
        if (arr.count == 0) {
            return NO;
        }
    }
    if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@"(null)"]) {
        return NO;
    }
    if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@"<null>"]) {
        return NO;
    }
    if ([object isKindOfClass:[NSString class]] && [object isEqualToString:@""]) {
        return NO;
    }
    return YES;
}


#endif

//一行代码解决服务器传回的参数为null的情况
//一，创建字典的类别
#define checkNull(__X__)       (__X__) == [NSNull null] || (__X__) == nil ? @"" : [NSString stringWithFormat:@"%@", (__X__)]

-(NSString *)safeNullWithKey:(NSString *)key {
    
    return checkNull([self objectForKey:key]);
}


@end

//********************************************************* NSArray
#pragma mark - NSArray
@implementation NSArray (Extension)
// 判断数组是否为空的方法
+ (BOOL)isEmptyArray:(NSArray *)array
{
    // 如果数组存在并且数组元素个数 > 0
    if (array && array.count > 0) {
        return NO;// 返回NO
    }
    
    // 其他情况返回YES
    return YES;
}

//本地化字符串
//NSArray 和 NSDictionary 分类重写时候用，这样在打印的时候本地化显示元素内容
//根据设置的locale 进行连接数组
#if DEBUG
- (NSString *)descriptionWithLocale:(id)locale {


////        1111111111111111
//    // 遍历数组中的所有内容，将内容拼接成一个新的字符串返回
//    NSMutableString *strM = [NSMutableString string];
//    
//    [strM appendString:@"[\n"];
//    // 遍历数组,self就是当前的数组
//    for (id obj in self) {
//        // 在拼接字符串时，会调用obj的description方法
//        [strM appendFormat:@"\t%@,\n", obj];
//    }
//    
//    [strM appendString:@"\t\t]"];
//    return strM;
    
    
    //2222222222222222
    NSMutableString *str = [NSMutableString stringWithFormat:@"%lu (\n", (unsigned long)self.count];
    
    for (id obj in self) {
        [str appendFormat:@"\t%@, \n", obj];
    }
    
    [str appendString:@")"];
    
    return str;
}
#endif
@end
//*********************************************************


















