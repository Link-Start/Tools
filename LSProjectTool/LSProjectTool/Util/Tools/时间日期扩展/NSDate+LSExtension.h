//
//  NSDate+LSExtension.h
//  LSProjectTool
//
//  Created by Xcode on 16/9/7.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
/*
 时间主要有以下几种类：
 NSDate -- 表示一个绝对的时间点
 NSTimeZone -- 时区信息NSLocale -- 本地化信息
 NSDateComponents -- 一个封装了具体年月日、时秒分、周、季度等的类
 NSCalendar -- 日历类，它提供了大部分的日期计算接口，并且允许您在NSDate和NSDateComponents之间转换
 NSDateFormatter -- 用来在日期和字符串之间转换
 */
#import <Foundation/Foundation.h>

@interface NSDate (LSExtension)

/** 获获取当前客户端的逻辑日历  @return 当前客户端的逻辑日历 */
+ (NSCalendar *)currentCalendar;
/** 将日期转换为当前时区的日期  @param forDate 要转换的日期 @return 转换过的日期 */
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate;

#pragma mark - 相对日期
/** 现在的日期  @return 现在的日期 */
+ (NSDate *)dateNow;
/** 明天的日期  @return 明天的日期 */
+ (NSDate *)dateTomorrow;
/** 昨天的日期  @return 昨天日期 */
+ (NSDate *)dateYesterday;
/** 从现在起向后推几天的日期 @param days 向后推的天数  @return 后推得到的日期 */
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
/** 从现在起向前推几天的日期 @param days 向前推的天数 @return 前推得到的日期 */
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
/** 从现在起向后推几小时的日期 @param days 向后推的小时数 @return 后推得到的日期 */
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours;
/** 从现在起向前推几小时的日期 @param days 向前推的小时数 @return 前推得到的日期 */
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours;
/** 从现在起向后推几分钟的日期 @param days 向后推的分钟数 @return 后推得到的日期 */
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes;
/** 从现在起向前推几分钟的日期 @param days 向前推的分钟数 @return 前推得到的日期 */
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes;

#pragma mark - 日期转字符串
/** 通过系统自带的时间风格 来得到字符串 
    @param dateStyle 日期格式 年月日 @param timeStyle 时间格式 时分秒 @return 得到最终的字符串 */
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;
/*** 通过format格式将当前日期转换为String格式 @param format 格式样式  @return 转换后得到的String */
- (NSString *)stringWithFormat:(NSString *)format;

/*** 5/5/15, 10:48 AM      @return 相应格式的日期+时间 */
@property (nonatomic, readonly, copy) NSString *shortString;
/*** 5/5/15                @return 响应格式的日期 */
@property (nonatomic, readonly, copy) NSString *shortDateString;
/*** 10:48 AM              @return 相应格式的时间 */
@property (nonatomic, readonly, copy) NSString *shortTimeString;
/*** May 5, 2015, 10:35:23 AM           @return 相应格式的日期+时间 */
@property (nonatomic, readonly, copy) NSString *mediumString;
/*** May 5, 2015           @return 相应格式的日期 */
@property (nonatomic, readonly, copy) NSString *mediumDateString;
/*** 10:35:23 AM           @return 相应格式的时间 */
@property (nonatomic, readonly, copy) NSString *mediumTimeString;
/*** May 5, 2015 at 10:35:23 AM GMT+8   @return 相应格式的日期+时间 */
@property (nonatomic, readonly, copy) NSString *longString;
/*** 10:35:23 AM GMT+8     @return 相应格式的日期 */
@property (nonatomic, readonly, copy) NSString *longDateString;
/*** May 5, 2015           @return 相应格式的时间 */
@property (nonatomic, readonly, copy) NSString *longTimeString;

#pragma mark - 日期比较
/***抛弃时间外 日期是否相等 精确到天的范围内  @param aDate 比较的date   @return YES 相等 NO 不相等 */
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate;
/************** 日 *****************/
/***日期是不是今天   @return YES 是 NO 不是 */
- (BOOL)isToday;
/***日期是不是明天   @return YES 是 NO 不是 */
- (BOOL)isTomorrow;
/***是不是昨天      @return YES 是 NO 不是 */
- (BOOL)isYesterday;

/************** 周 *****************/
/***判断和指定日期是否是同一个星期内的  @param aDate 相比较的日期  @return YES 是 NO 不是 */
- (BOOL)isSameWeekAsDate:(NSDate *)aDate;
/***判断是不是本周   @return YES 是 NO 不是 */
- (BOOL)isThisWeek;
/***判断是不是下周   @return YES 是 NO  不是 */
- (BOOL)isNextWeek;
/***判断是不是上周   @return YES 是 NO 不是 */
- (BOOL)isLastWeek;

/************** 月 *****************/
///判断是不是同一个月       aDate 比较的日期  YES 是 NO 不是
- (BOOL)isSameMonthAsDate:(NSDate *)aDate;
///判断是不是本月     YES 是 NO 不是
- (BOOL)isThisMonth;
///判断是不是下个月   YES 是 NO 不是
- (BOOL)isNextMonth;
///判断是不是上个月   YES 是 NO 不是
- (BOOL)isLastMonth;

/************** 年 *****************/
///判断是不是同一年        aDate 比较的日期  YES:是 NO:不是
- (BOOL)isSameYearAsDate:(NSDate *)aDate;
///是否为今年        YES 是 NO 不是
- (BOOL)isThisYear;
///判断是不是下一年   YES 是 NO 不是
- (BOOL)isNextYear;
///判断是不是上一年   YES 是 NO 不是
- (BOOL)isLastYear;

///判断是不是比指定日期早   aDate 指定的日期   YES 早 NO 不早
- (BOOL)isEarlierThanDate:(NSDate *)aDate;
///判断是不是比指定日期晚   aDate 指定的日期   YES 晚 NO 不晚
- (BOOL)isLaterThanDate:(NSDate *)aDate;

///判断一个日期是不是在将来  YES 是 NO 不是
- (BOOL)isInFuture;
///判断一个日期是不是在过去  YES 是 NO 不是
- (BOOL)isInPast;

#pragma mark - 日期规则
///是不是工作日  YES 是 NO 不是
- (BOOL)isTypicallyWorkday;
///是不是周六日  YES 是 NO 不是
- (BOOL)isTypicallyWeekend;

#pragma mark - 调整日期
///指定日期后推几年得到的日期            dYears 后推的年数
- (NSDate *)dateByAddingYears:(NSInteger)dYears;
///指定日期前推几年得到的日期            dYears 前推的年数
- (NSDate *)dateBySubtractingYears:(NSInteger)dYears;
///指定日期后推几个月得到的日期          dMonths 后推的月数
- (NSDate *)dateByAddingMonths:(NSInteger)dMonths;
///指定日期前推几个月得到的日期          dMonths 前推的月数
- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths;
///指定日期后推几天得到的日期            dDays 后推的天数
- (NSDate *)dateByAddingDays:(NSInteger)dDays;
///指定日期前推几天的到的日期            dDays 前推的天数
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays;
///指定日期后推几小时得到的日期          dHours 后推的几个小时
- (NSDate *)dateByAddingHours:(NSInteger)dHours;
///指定日期前推几小时得到的日期          dHours 前推的小时数
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours;
///指定日期后推几分钟得到的日期          dMinutes 后推的分钟数
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes;
///指定日期前推几分钟得到的日期          dMinutes 前推的分钟数
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes;

#pragma mark - 极端日期
///得到指定日期这一天的开始日期
- (NSDate *)dateAtStartOfDay;
///得到指定日期这一天的结束日期
- (NSDate *)dateAtEndOfDay;

#pragma mark - 日期间隔
///得到当前日期在给定日期之后的分钟数      aDate 给定的日期
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
///得到当前日期在给定日期之前的分钟数      aDate 给定的日期
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
///得到当前日期在给定日期之后的小时数      aDate 给定的日期
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
///得到当前日期在给定日期之前的小时数      aDate 给定的日期
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
///得到当前日期在给定日期之后的天数        aDate 给定的日期
- (NSInteger)daysAfterDate:(NSDate *)aDate;
///得到当前日期在给定日期之前的天数        aDate:给定的日期
- (NSInteger)daysBeforeDate:(NSDate *)aDate;
///当前的日期和给定的日期之间相差的天数     anotherDate:给定的日期
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

#pragma mark - 分解日期
///距离当前时间最近的小时 比如9：55 就是10：00 9：25就是9：00
@property (readonly) NSInteger nearestHour;
///当前日期的小时
@property (readonly) NSInteger hour;
///当前日期的分钟
@property (readonly) NSInteger minute;
///当前日期的秒
@property (readonly) NSInteger seconds;
///当前日期的几号
@property (readonly) NSInteger day;
///当前日期的几月
@property (readonly) NSInteger month;
///当前月的第几周
@property (readonly) NSInteger weekOfMonth;
///当前年的第几周
@property (readonly) NSInteger weekOfYear;
///当前日期所在周的第几天
@property (readonly) NSInteger weekday;
///当前日期所在年的第几季度
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
///当前日期的年
@property (readonly) NSInteger year;

@end
