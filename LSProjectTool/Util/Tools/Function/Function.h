//
//  Function.h
//  Test
//
//  Created by Xcode on 16/5/19.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface Function : NSObject

//*********************************************************
#pragma mark - 单利
//单例的作用 顾名思义，单例，即是在整个项目中，这个类的对象只能被初始化一次。它的这种特性，可以广泛应用于某些需要全局共享的资源中，比如管理类，引擎类，也可以通过单例来实现传值。UIApplication、NSUserDefaults等都是IOS中的系统单例。
/**
 *  单利 1 使用线程锁
 */
+ (Function *)defaultFunction;
/**
*  单利 2 GCD 考虑线程安全
*/
+ (Function *)shareFunction;
/**
 *  单利 3 代码的优化
 */
+ (Function *)sharedInstanceFunction;

//*********************************************************
#pragma mark - 正则表达式
/**
 *  用正则表达式匹配手机号 验证是否为手机号
 *
 *  @param mobileNum 手机号字符串
 *
 *  @return 如果是正确的手机号格式，返回YES，否则 返回NO
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

///简单匹配是否是 手机号码
+ (BOOL)judgeMobileNumber:(NSString *)mobileNum;

/**
 *  是否是有效的正则表达式
 *
 *  @param Expression 要检测的字符串
 *  @param byExpression  正则表达式
 *
 *  @return 是:YES 否:NO
 */
+ (BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression;

/**
 *  //验证email
 *
 *  @param email
 *
 *  @return
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  //验证电话号码
 *
 *  @param number
 *
 *  @return
 */
+ (BOOL)isValidateTelNumber:(NSString *)number;

/**
 *  判断机型(获取iPhone型号)
 */
+ (NSString *)stringiPhoneDeviceVersion;

#pragma mark 检验银行卡
+ (BOOL)checkCardNo:(NSString *)cardNo;
#pragma mark - 根据银行卡号判断银行名称
+ (NSString *)getBankName:(NSString *)cardId;

//*********************************************************
#pragma mark - 解析网络上的数据
/// 解析网络上的数据
+ (nullable id)getDicFromResponseObject:(nullable id)responseObject;

/// 根据key值从字典里面取出一个安全的value值
+ (id)getValueFromDic:(NSDictionary *)dic withKey:(NSString *)key;
//*********************************************************
#pragma mark - 数组/字典转json格式字符串：
/**
 *  字典/数组 转json格式字符串：
 *
 *  @param value 数组/字典
 *
 *  @return Json字符串
 */
+ (nullable NSString *)arrayOrDictionaryToJsonData:(nullable id)value;

#pragma mark - json字符串转字典、数组
///json字符串转字典、数组
+ (nullable id)objectWithJSONString:(nonnull NSString *)JSONString;
#pragma mark - data数据转字典、数组
///data数据转字典、数组
+ (nullable id)objectWithJSONData:(nonnull NSData *)JSONData;
//*********************************************************
#pragma mark - 时间戳
///获取系统时间戳 精确到秒
+ (long long)getSystemTimeStampAccurateToSeconds;
///获取系统时间戳 精确到毫秒
+ (long long)getSystemTimeStampAccurateToMilliseconds;
///将字符串转换为 NSDate
+ ( NSDate *)getDateFromString:(NSString *)string;
///判断一个日期 是否在 两个日期之间
+ (BOOL)isBetweenFrom:(NSString *)fromString to:(NSString *)toString;
/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour;
//*********************************************************
/*********** 清理缓存 方法 2 *****************/
//2 清理Library文件夹
+ (void)clearCache;
/*********** 清理缓存 方法 3 *****************/
//3 清理Cache文件夹
+ (void)clearCaches;




@end
NS_ASSUME_NONNULL_END

//*********************************************************

//*********************************************************
