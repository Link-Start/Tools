//
//  NSDate+LSExtension.m
//  LSProjectTool
//
//  Created by Xcode on 16/9/7.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "NSDate+LSExtension.h"

#pragma mark - YYKit 时间分类
/******************** YYKit 时间分类 ***********************/
//#import "YYKitMacro.h"
#import <time.h>

/******************** YYKit 时间分类 ***********************/

#define D_MINUTE     60
#define D_HOUR       3600
#define D_DAY        86400
#define D_WEEK       604800
#define D_YEAR       31556926

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);


@implementation NSDate (LSExtension)

/**
 *  获获取当前客户端的逻辑日历
 *
 *  @return 当前客户端的逻辑日历
 */
+ (NSCalendar *)currentCalendar {
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar) {
        //获得NSCalendar对象
        //如果用autoupdatingCurrentCalendar，那么每次取得的值都会是当前系统设置的日历的值。
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
        
//        sharedCalendar = [NSCalendar currentCalendar];
    }
    return sharedCalendar;
}

/**

 *  一个NSDate对象就代表一个时间
 [NSDate date]返回的就是当前时间，注意此时间是世界标准时间，准确时间应加上当前时区与世界标准时间的偏移量
 NSDate *now = [NSDate date];  // 未偏移量的当前时间
 NSLog(@"now = %@", now);
 // 获取当前所处的时区
 NSTimeZone *zone = [NSTimeZone systemTimeZone];
 // 获取当前时区和指定时区的时间差
 NSInteger seconds = [zone secondsFromGMTForDate:now];
 // 得到准确时间
 NSDate *newDate = [now dateByAddingTimeInterval:seconds];
 NSLog(@"newDate = %@", newDate);
 */
/// 将日期转换为当前时区的日期
/// @param forDate 要转换的日期
/// @return 转换过的日期
+ (NSDate *)convertDateToLocalTime:(NSDate *)forDate {
    // 获取当前所处的时区
    NSTimeZone *nowTimeZone = [NSTimeZone localTimeZone];
    // 获取当前时区和指定时区的时间差
    NSInteger timeOffset = [nowTimeZone secondsFromGMTForDate:forDate];
    // 得到准确时间
    NSDate *newDate = [forDate dateByAddingTimeInterval:timeOffset];
    return newDate;
}


#pragma mark - 相对日期
/**
 *  从现在起向后推几天的日期
 *
 *  @param days 向后推的天数
 *
 *  @return 后推得到的日期
 */
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days {
    return [self convertDateToLocalTime:[[NSDate date] dateByAddingDays:days]];
}

/**
 *  从现在起向前推几天的日期
 *
 *  @param days 向前推的天数
 *
 *  @return 前推得到的日期
 */
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days {
    return [self convertDateToLocalTime:[[NSDate date] dateByAddingDays:days]];
    
    return [[NSDate date] dateBySubtractingDays:days];
}

/**
 *  从现在起向后推几小时的日期
 *
 *  @param days 向后推的小时数
 *
 *  @return 后推得到的日期
 */
+ (NSDate *)dateWithHoursFromNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self convertDateToLocalTime:newDate];
}

/**
 *  从现在起向前推几小时的日期
 *
 *  @param days 向前推的小时数
 *
 *  @return 前推得到的日期
 */
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self convertDateToLocalTime:newDate];
}

/**
 *  从现在起向后推几分钟的日期
 *
 *  @param days 向后推的分钟数
 *
 *  @return 后推得到的日期
 */
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self convertDateToLocalTime:newDate];
}

/**
 *  从现在起向前推几分钟的日期
 *
 *  @param days 向前推的分钟数
 *
 *  @return 前推得到的日期
 */
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self convertDateToLocalTime:newDate];
}

/**
 *  明天的日期
 *
 *  @return 明天的日期
 */
+ (NSDate *)dateTomorrow {
    return [self convertDateToLocalTime:[NSDate dateWithDaysFromNow:1]];
}

/**
 *  昨天的日期
 *
 *  @return 昨天日期
 */
+ (NSDate *)dateYesterday {
    return [self convertDateToLocalTime:[NSDate dateWithDaysBeforeNow:1]];
}
/**
 *  现在的日期
 *
 *  @return 现在的日期
 */
+ (NSDate *)dateNow {
   // [NSDate date]返回的就是当前时间，注意此时间是世界标准时间，准确时间应加上当前时区与世界标准时间的偏移量
    return [self convertDateToLocalTime:[NSDate date]];
}


#pragma mark -日期转换为String

/// 通过系统自带的时间风格 来得到字符串
/// @param dateStyle 日期格式 年月日
/// @param timeStyle 时间格式 时分秒
/// @return 得到最终的字符串
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.dateStyle = dateStyle;
    formatter.timeStyle = timeStyle;
    return [formatter stringFromDate:self];
}

/// 使用NSDateFormatter转换时间字符串时，默认的时区是系统时区，如我们使用一般都是北京时间(＋8)
/// 通过format格式将当前日期转换为String格式
/// @param format 格式样式
/// 转换后得到的String
- (NSString *)stringWithFormat:(NSString *)format {
    // 创建时间格式化
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 指定格式 yyyy：年 MM：月 dd：日 HH：24小时 hh：12小时 mm：分 ss：秒 Z：时区
    formatter.dateFormat = format;
    //格式化时间
    return [formatter stringFromDate:self];
}
/// NSDate --> NSString
+ (nullable NSString *)stringFromDate:(NSDate *)date dateFormat:(NSString *)dateFormat {
    return [self stringFormDate:date dateFormat:dateFormat timeZone:nil language:nil];
}
+ (nullable NSString *)stringFormDate:(NSDate *)date dateFormat:(NSString *)dateFormat timeZone:(nullable NSTimeZone *)timeZone language:(nullable NSString *)language {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // 设置日期格式
    dateFormatter.dateFormat = dateFormat;
    // 设置时区，不设置默认为系统时区
    if (timeZone) {
        dateFormatter.timeZone = timeZone;
    }
    if (!language) {
        language = [NSLocale preferredLanguages].firstObject;
    }
    dateFormatter.locale = [[NSLocale alloc]initWithLocaleIdentifier:language];
    NSString *dateString = [dateFormatter stringFromDate:date];

    return dateString;
}

/**
 *  5/5/15, 10:48 AM
 *
 *  @return 相应格式的日期+时间
 */
- (NSString *)shortString {
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
}

/**
 *  10:48 AM
 *
 *  @return 相应格式的时间
 */
- (NSString *)shortTimeString {
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterShortStyle];
}

/**
 *  5/5/15
 *
 *  @return 响应格式的日期
 */
- (NSString *)shortDateString {
    return [self stringWithDateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterNoStyle];
}

/**
 *  May 5, 2015, 10:35:23 AM
 *
 *  @return 相应格式的日期+时间
 */
- (NSString *)mediumString {
    return [self stringWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterMediumStyle ];
}

/**
 *  10:35:23 AM
 *
 *  @return 相应格式的时间
 */
- (NSString *)mediumTimeString {
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle ];
}

/**
 *  May 5, 2015
 *
 *  @return 相应格式的日期
 */
- (NSString *)mediumDateString {
    return [self stringWithDateStyle:NSDateFormatterMediumStyle  timeStyle:NSDateFormatterNoStyle];
}

/**
 *  May 5, 2015 at 10:35:23 AM GMT+8
 *
 *  @return 相应格式的日期+时间
 */
- (NSString *)longString {
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterLongStyle ];
}

/**
 *  10:35:23 AM GMT+8
 *
 *  @return 相应格式的日期
 */
- (NSString *)longDateString {
    return [self stringWithDateStyle:NSDateFormatterLongStyle timeStyle:NSDateFormatterNoStyle];
}

/**
 *  May 5, 2015
 *
 *  @return 相应格式的时间
 */
- (NSString *)longTimeString {
    return [self stringWithDateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterLongStyle ];
}

#pragma mark - 日期比较
/**
 *  抛弃时间外 日期是否相等 精确到天的范围内
 *
 *  @param aDate 比较的date
 *
 *  @return YES 相等 NO 不相等
 */
- (BOOL)isEqualToDateIgnoringTime:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    return ((components1.year == components2.year) && (components1.month == components2.month) && (components1.day == components2.day));
}

/**
 *  日期是不是今天
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isToday {
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}

/**
 *  日期是不是明天
 *
 *  @return YES  是 NO 不是
 */
- (BOOL)isTomorrow {
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

/**
 *  是不是昨天
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isYesterday {
    return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

/**
 *  判断和指定日期是否是同一个星期内的
 *
 *  @param aDate 相比较的日期
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isSameWeekAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:componentFlags fromDate:aDate];
    // Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
    //必须同一周。12/31和1/1将是一周的“1”，如果他们是在同一周
    if (components1.weekOfYear != components2.weekOfYear) return NO;
    // Must have a time interval under 1 week. Thanks @aclark
    //必须有一个1周以下的时间间隔。
    return (abs((int)[self timeIntervalSinceDate:aDate]) < D_WEEK);
}

/**
 *  判断是不是本周
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isThisWeek {
    return [self isSameWeekAsDate:[NSDate date]];
}

/**
 *  判断是不是下周
 *
 *  @return YES 是 NO  不是
 */
- (BOOL)isNextWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

/**
 *  判断是不是上周
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isLastWeek {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return [self isSameWeekAsDate:newDate];
}

/**
 *  判断是不是同一个月
 *
 *  @param aDate 比较的日期
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isSameMonthAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth fromDate:aDate];
    return ((components1.month == components2.month) && (components1.year == components2.year));
}

/**
 *  判断是不是本月
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isThisMonth {
    return [self isSameMonthAsDate:[NSDate date]];
}

/**
 *  判断是不是上个月
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isLastMonth {
    return [self isSameMonthAsDate:[[NSDate date] dateBySubtractingMonths:1]];
}

/**
 *  判断是不是下个月
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isNextMonth {
    return [self isSameMonthAsDate:[[NSDate date] dateByAddingMonths:1]];
}

/**
 *  判断是不是同一年
 *
 *  @param aDate 比较的日期
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isSameYearAsDate:(NSDate *)aDate {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:aDate];
    return (components1.year == components2.year);
}

/**
 *  判断是不是本年
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isThisYear {
    return [self isSameYearAsDate:[NSDate date]];
}

/**
 *  判断是不是下一年
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isNextYear {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year + 1));
}

/**
 *  判断是不是上一年
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isLastYear {
    NSDateComponents *components1 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:self];
    NSDateComponents *components2 = [[NSDate currentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]];
    
    return (components1.year == (components2.year - 1));
}

/**
 *  判断是不是比指定日期早
 *
 *  @param aDate 指定的日期
 *
 *  @return YES 早 NO 不早
 */
- (BOOL)isEarlierThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedAscending);
}

/**
 *  判断是不是比指定日期晚
 *
 *  @param aDate 指定的日期
 *
 *  @return YES 晚 NO 不晚
 */
- (BOOL)isLaterThanDate:(NSDate *)aDate {
    return ([self compare:aDate] == NSOrderedDescending);
}

/**
 *  判断一个日期是不是在将来
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isInFuture {
    return ([self isLaterThanDate:[NSDate date]]);
}

/**
 *  判断一个日期是不是在过去
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isInPast {
    return ([self isEarlierThanDate:[NSDate date]]);
}


#pragma mark - 星期内工作日
/**
 *  是不是周六日
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isTypicallyWeekend {
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    if ((components.weekday == 1) ||
        (components.weekday == 7))
        return YES;
    return NO;
}

/**
 *  是不是工作日
 *
 *  @return YES 是 NO 不是
 */
- (BOOL)isTypicallyWorkday {
    return ![self isTypicallyWeekend];
}

#pragma mark - 调整日期
/**
 *  指定日期后推几年得到的日期
 *
 *  @param dYears 后推的年数
 *
 *  @return 后推后得到的日期
 */
- (NSDate *)dateByAddingYears:(NSInteger)dYears {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setYear:dYears];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

/**
 *  指定日期前推几年得到的日期
 *
 *  @param dYears 前推的年数
 *
 *  @return 前推得到的日期
 */
- (NSDate *)dateBySubtractingYears:(NSInteger)dYears {
    return [self dateByAddingYears:-dYears];
}

/**
 *  指定日期后推几个月得到的日期
 *
 *  @param dMonths 后推的月数
 *
 *  @return 后推后得到的日期
 */
- (NSDate *)dateByAddingMonths:(NSInteger)dMonths {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setMonth:dMonths];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

/**
 *  指定日期前推几个月得到的日期
 *
 *  @param dMonths 前推的月数
 *
 *  @return 前推后得到的日期
 */
- (NSDate *)dateBySubtractingMonths:(NSInteger)dMonths {
    return [self dateByAddingMonths:-dMonths];
}

/**
 *  指定日期后推几天得到的日期
 *
 *  @param dDays 后推的天数
 *
 *  @return 后推得到的日期
 */
- (NSDate *)dateByAddingDays:(NSInteger)dDays {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:dDays];
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
    return newDate;
}

/**
 *  指定日期前推几天的到的日期
 *
 *  @param dDays 前推的天数
 *
 *  @return 前推得到的日期
 */
- (NSDate *)dateBySubtractingDays:(NSInteger)dDays {
    return [self dateByAddingDays:(dDays * -1)];
}

/**
 *  指定日期后推几小时得到的日期
 *
 *  @param dHours 后推的几个小时
 *
 *  @return 后推后的日期
 */
- (NSDate *)dateByAddingHours:(NSInteger)dHours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

/**
 *  指定日期前推几小时得到的日期
 *
 *  @param dHours 前推的小时数
 *
 *  @return 前推后得到的日期
 */
- (NSDate *)dateBySubtractingHours:(NSInteger)dHours {
    return [self dateByAddingHours:(dHours * -1)];
}

/**
 *  指定日期后推几分钟得到的日期
 *
 *  @param dMinutes 后推的分钟数
 *
 *  @return 后推得到的日期
 */
- (NSDate *)dateByAddingMinutes:(NSInteger)dMinutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

/**
 *  指定日期前推几分钟得到的日期
 *
 *  @param dMinutes 前推的分钟数
 *
 *  @return 前推得到的日期
 */
- (NSDate *)dateBySubtractingMinutes:(NSInteger)dMinutes {
    return [self dateByAddingMinutes:(dMinutes * -1)];
}

/**
 *  指定日期和给的日期之间相差的时间
 *
 *  @param aDate 比较的日期
 *
 *  @return 相差的时间
 */
- (NSDateComponents *)componentsWithOffsetFromDate:(NSDate *)aDate {
    NSDateComponents *dTime = [[NSDate currentCalendar] components:componentFlags fromDate:aDate toDate:self options:0];
    return dTime;
}

#pragma mark - 极端例子
/**
 *  得到指定日期这一天的开始日期
 *
 *  @return 得到的日期
 */
- (NSDate *)dateAtStartOfDay{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 0;
    components.minute = 0;
    components.second = 0;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

/**
 *  得到指定日期这一天的结束日期
 *
 *  @return 得到的日期
 */
- (NSDate *)dateAtEndOfDay{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    components.hour = 23; // Thanks Aleksey Kononov
    components.minute = 59;
    components.second = 59;
    return [[NSDate currentCalendar] dateFromComponents:components];
}

#pragma mark - 检索间隔
/**
 *  得到当前日期在给定日期之后的分钟数
 *
 *  @param aDate 给定的日期
 *
 *  @return 得到的分钟数
 */
- (NSInteger)minutesAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_MINUTE);
}

/**
 *  得到当前日期在给定日期之前的分钟数
 *
 *  @param aDate 给定的日期
 *
 *  @return 得到的分钟数
 */
- (NSInteger)minutesBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_MINUTE);
}

/**
 *  得到当前日期在给定日期之后的小时数
 *
 *  @param aDate 给定的日期
 *
 *  @return 得到的小时数
 */
- (NSInteger)hoursAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_HOUR);
}

/**
 *  得到当前日期在给定日期之前的小时数
 *
 *  @param aDate 给定的日期
 *
 *  @return 得到的小时数
 */
- (NSInteger)hoursBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_HOUR);
}

/**
 *  得到当前日期在给定日期之后的天数
 *
 *  @param aDate 给定的日期
 *
 *  @return 得到的天数
 */
- (NSInteger)daysAfterDate:(NSDate *)aDate {
    NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
    return (NSInteger)(ti / D_DAY);
}

/**
 *  得到当前日期在给定日期之前的天数
 *
 *  @param aDate 给定的日期
 *
 *  @return 得到的天数
 */
- (NSInteger)daysBeforeDate:(NSDate *)aDate {
    NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
    return (NSInteger)(ti / D_DAY);
}

/**
 *  当前的日期和给定的日期之间相差的天数
 *
 *  @param anotherDate 给定的日期
 *
 *  @return 相差的天数
 */
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay fromDate:self toDate:anotherDate options:0];
    return components.day;
}

#pragma mark - 日期分解
/**
 *  距离当前时间最近的小时 比如9：55 就是10：00 9：25就是9：00
 *
 *  @return 最近的小时
 */
- (NSInteger)nearestHour {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

/**
 *  当前日期的小时
 *
 *  @return 当前日期的小时
 */
- (NSInteger)hour {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

/**
 *  当前日期的分钟
 *
 *  @return 当前日期的分钟
 */
- (NSInteger)minute {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

/**
 *  当前日期的秒
 *
 *  @return 当前日期的秒
 */
- (NSInteger)seconds {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

/**
 *  当前日期的几号
 *
 *  @return 当前日期的几号
 */
- (NSInteger)day {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

/**
 *  当前日期的几月
 *
 *  @return 当前日期的几月
 */
- (NSInteger)month {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

/**
 *  当前月的第几周
 *
 *  @return 当前月的第几周
 */
- (NSInteger)weekOfMonth {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfMonth;
}

/**
 *  当前年的第几周
 *
 *  @return 当前年的第几周
 */
- (NSInteger)weekOfYear {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfYear;
}


/// 当前日期所在周的第几天，获取当前日期是周几
/// 1、2、3、4、5、6、7 分别对应 周日、周一、周二、周三、周四、周五、周六
- (NSInteger)ls_weekday {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}
- (NSInteger)ls_weekday_ {
    NSArray *tempWeek = @[@"7",@"1",@"2",@"3",@"4",@"5",@"6"];
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    //  1、2、3、4、5、6、7 分别对应 周日、周一、周二、周三、周四、周五、周六
    NSInteger week = [components weekday];
    NSLog(@"---%ld",week);
    //  调整后 1代表周一 , 0代表周日
    return [tempWeek[week-1] integerValue];
}

/**
 *  当前日期所在年的第几季度
 *
 *  @return 获得的季度
 */
- (NSInteger)nthWeekday {// e.g. 2nd Tuesday of the month is 2
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

/**
 *  当前日期的年
 *
 *  @return 当前日期的年
 */
- (NSInteger)year {
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}




- (NSDate *)previousMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    components.day = 15; // 定位到当月中间日子
    
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    
    NSDate *previousDate = [calendar dateFromComponents:components];
    
    return previousDate;
}

- (NSDate *)nextMonthDate {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    components.day = 15; // 定位到当月中间日子
    
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    
    NSDate *nextDate = [calendar dateFromComponents:components];
    
    return nextDate;
}

- (NSDate *)otherDayInMonth:(NSInteger)number {
    
    if (number < 1 || number > 31) {
        return nil;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:self];
    components.day = number;
    
    NSDate *otherDate = [calendar dateFromComponents:components];
    
    return otherDate;
}
/// 获取当前月份的天数
- (NSInteger)totalDaysInMonth {
    NSInteger totalDays = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self].length;
    return totalDays;
}
/// 获取指定月份的总 天数
- (NSInteger)totaldaysInThisMonth:(NSDate *)date {
    NSRange totaldaysInMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return totaldaysInMonth.length;
}

/// 获取当前月份的第一天是周几
- (NSInteger)firstWeekDayInMonth {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:self];
    components.day = 1; // 定位到当月第一天
    NSDate *firstDay = [calendar dateFromComponents:components];
    
    NSLog(@"第一天日期是：%@", firstDay);
    NSLog(@"第一天日期是：%@", [firstDay stringWithFormat:@"yyyy-MM-dd HH:mm:ss"]);
    
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    return firstWeekday;
}

/// 获取指定月份的第一天是周几
- (NSInteger)firstWeekdayInThisMonth:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    // NSDateComponent 可以获得日期的详细信息，即日期的组成
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [comp setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday - 1;
}



- (NSString *)lunarText {
    
    NSArray *dayArray  = @[@"初一", @"初二", @"初三", @"初四", @"初五", @"初六", @"初七", @"初八", @"初九", @"初十",@"十一", @"十二", @"十三", @"十四", @"十五", @"十六", @"十七", @"十八", @"十九", @"二十",@"廿一", @"廿二", @"廿三", @"廿四", @"廿五", @"廿六", @"廿七", @"廿八", @"廿九", @"三十"];
    
    NSArray *monthArray = @[@"正月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"冬月",@"腊月"];
    NSCalendar *localeCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    NSDateComponents *localeComp = [localeCalendar components:unitFlags fromDate:self];
    
    if (localeComp.day-1 == 0) {
        return monthArray[localeComp.month-1];
    }
    return dayArray[localeComp.day-1];
}


#pragma mark - 时间/时间戳，转换/格式化
///获取当前时间的时间戳 秒
- (long long)currentTimeStamp {
    return [[NSDate date] timeIntervalSince1970];
}
/// 获取当前时间戳
+ (long long)getCurrentTimeStamp {
    return [[NSDate date] timeIntervalSince1970];
}

///将时间转换为时间戳
- (long long)ls_timeStampFromDate:(NSDate *)date {
    return [date timeIntervalSince1970];
}

/// 将时间转换为时间戳
- (long long)ls_timeStampFromDateString:(NSString *)dateString {
    return [self ls_timeStampFromDateString:dateString withFormat:@"yyyy-MM-dd HH:mm"];
}

/// 将时间转换为时间戳
- (long long)ls_timeStampFromDateString:(NSString *)dateString withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:dateString];
    ///时间戳    毫秒
    long long timeStamp = (long)[dateFormatted timeIntervalSince1970] * 1000;
    return timeStamp;
}

#pragma mark -
- (NSString *)ls_messageString {

    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:self];
    NSDateFormatter *dateFmt = [[NSDateFormatter alloc] init];
    
    NSDateComponents *comp =  [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday
                                          fromDate:self];

    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy/MM/dd";
    } else {
        if (nowCmps.day == myCmps.day) {
            dateFmt.dateFormat = @"HH:mm";
        } else if ((nowCmps.day - myCmps.day) == 1) {
            dateFmt.AMSymbol = @"上午";
            dateFmt.PMSymbol = @"下午";
            dateFmt.dateFormat = @"昨天";
        } else {
            if ((nowCmps.day - myCmps.day) <= 7) {
                switch (comp.weekday) {
                    case 1:
                        dateFmt.dateFormat = @"星期日";
                        break;
                    case 2:
                        dateFmt.dateFormat = @"星期一";
                        break;
                    case 3:
                        dateFmt.dateFormat = @"星期二";
                        break;
                    case 4:
                        dateFmt.dateFormat = @"星期三";
                        break;
                    case 5:
                        dateFmt.dateFormat = @"星期四";
                        break;
                    case 6:
                        dateFmt.dateFormat = @"星期五";
                        break;
                    case 7:
                        dateFmt.dateFormat = @"星期六";
                        break;
                    default:
                        break;
                }
            } else {
                dateFmt.dateFormat = @"yyyy/MM/dd";
            }
        }
    }
    return [dateFmt stringFromDate:self];
}


#pragma mark - YYKit 时间分类
//- (NSInteger)year {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYear fromDate:self] year];
//}
//
//- (NSInteger)month {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMonth fromDate:self] month];
//}
//
//- (NSInteger)day {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitDay fromDate:self] day];
//}
//
//- (NSInteger)hour {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitHour fromDate:self] hour];
//}
//
//- (NSInteger)minute {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitMinute fromDate:self] minute];
//}
//
//- (NSInteger)second {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] second];
//}
//
//- (NSInteger)nanosecond {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitSecond fromDate:self] nanosecond];
//}
//
//- (NSInteger)weekday {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
//}
//
//- (NSInteger)weekdayOrdinal {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekdayOrdinal fromDate:self] weekdayOrdinal];
//}
//
//- (NSInteger)weekOfMonth {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfMonth fromDate:self] weekOfMonth];
//}
//
//- (NSInteger)weekOfYear {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekOfYear fromDate:self] weekOfYear];
//}
//
//- (NSInteger)yearForWeekOfYear {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitYearForWeekOfYear fromDate:self] yearForWeekOfYear];
//}
//
//- (NSInteger)quarter {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] quarter];
//}
//
//- (BOOL)isLeapMonth {
//    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
//}
//
//- (BOOL)isLeapYear {
//    NSUInteger year = self.year;
//    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
//}
//
//- (BOOL)isToday {
//    if (fabs(self.timeIntervalSinceNow) >= 60 * 60 * 24) return NO;
//    return [NSDate new].day == self.day;
//}
//
//- (BOOL)isYesterday {
//    NSDate *added = [self dateByAddingDays:1];
//    return [added isToday];
//}
//
//- (NSDate *)dateByAddingYears:(NSInteger)years {
//    NSCalendar *calendar =  [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [components setYear:years];
//    return [calendar dateByAddingComponents:components toDate:self options:0];
//}
//
//- (NSDate *)dateByAddingMonths:(NSInteger)months {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [components setMonth:months];
//    return [calendar dateByAddingComponents:components toDate:self options:0];
//}
//
//- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    [components setWeekOfYear:weeks];
//    return [calendar dateByAddingComponents:components toDate:self options:0];
//}
//
//- (NSDate *)dateByAddingDays:(NSInteger)days {
//    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
//    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//    return newDate;
//}
//
//- (NSDate *)dateByAddingHours:(NSInteger)hours {
//    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
//    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//    return newDate;
//}
//
//- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
//    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
//    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//    return newDate;
//}
//
//- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
//    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
//    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
//    return newDate;
//}
//
//- (NSString *)stringWithFormat:(NSString *)format {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    [formatter setLocale:[NSLocale currentLocale]];
//    return [formatter stringFromDate:self];
//}
//
//- (NSString *)stringWithFormat:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    if (timeZone) [formatter setTimeZone:timeZone];
//    if (locale) [formatter setLocale:locale];
//    return [formatter stringFromDate:self];
//}
//
//- (NSString *)stringWithISOFormat {
//    static NSDateFormatter *formatter = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        formatter = [[NSDateFormatter alloc] init];
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
//    });
//    return [formatter stringFromDate:self];
//}
//
//+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    return [formatter dateFromString:dateString];
//}
//
//+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format timeZone:(NSTimeZone *)timeZone locale:(NSLocale *)locale {
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:format];
//    if (timeZone) [formatter setTimeZone:timeZone];
//    if (locale) [formatter setLocale:locale];
//    return [formatter dateFromString:dateString];
//}
//
//+ (NSDate *)dateWithISOFormatString:(NSString *)dateString {
//    static NSDateFormatter *formatter = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        formatter = [[NSDateFormatter alloc] init];
//        formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//        formatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ssZ";
//    });
//    return [formatter dateFromString:dateString];
//}



@end
