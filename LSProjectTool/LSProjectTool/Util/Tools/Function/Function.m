//
//  Function.m
//  Test
//
//  Created by Xcode on 16/5/19.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "Function.h"
//判断机型
#import <sys/utsname.h>
//获取运营商信息
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>



@implementation Function

//*********************************************************
#pragma mark - 单利
//方式1、使用线程锁
static Function *ls_function = nil;

//创建单例方法使用加号的原因:在创建之前无法存在一个实例对象去调用
+ (Function *)defaultFunction {

//为了线程安全(添加线程锁):控制某一时间只允许一个进程访问初始化方法
    @synchronized (self) {
        if (!ls_function) {
            ls_function = [[self alloc] init];
        }
    }
    return ls_function;
}

//方式2、考虑线程安全 GCD
////dispatch_once这个函数， 它可以保证整个应用程序生命周期中某段代码只被执行一次！
+ (Function *)shareFunction {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_function = [[self alloc] init];
    });
    return ls_function;
}

//方式3 代码的优化
//很多时候，项目的工程量很大，还有可能会很多开发者同时参与一个项目的开发，
//为了安全与管理代码的方便，也为了给不是这个单例的创作者但会用到这个单例的开发人员一些提示，我们通常会重写一些方法：
//--1首先我们自己实现一个alloc方法
+ (instancetype)myAlloc {
    return [super allocWithZone:nil];
}
//--2将我们的单例实现方法略作修改
+ (Function *)sharedInstanceFunction {
    if (ls_function == nil) {
        ls_function = [[Function myAlloc] init];
    }
    return ls_function;
}
//--3将一些视图实例化对象的方法重写
//注意：这里的alloc使用了断言，让任何视图通过alloc创建对象的程序段断在此处，给程序员提示。
//copy方法这里只是简单的返回了原对象，并未做任何处理，打印信息给程序员提示。
+(instancetype)alloc {
    NSAssert(0, @"这是一个单例对象，请使用+(Function *)shareFunction1方法");
    return nil;
}
+(instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self alloc];
}
-(id)copy {
    NSLog(@"这是一个单例对象，copy将不起任何作用");
    return self;
}
+(instancetype)new {
    return  [self alloc];
}

//方式4  摘抄自CRM
//+ (Function *)sharedInstance { //第二步：实例构造检查静态实例是否为nil
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        ls_function = [[self alloc] init];
//    });
//    return ls_function;
//}
//+ (id) allocWithZone:(NSZone *)zone { //第三步：重写allocWithZone方法
//    @synchronized (self) {
//        if (ls_function == nil) {
//            ls_function = [super allocWithZone:zone];
//            return ls_function;
//        }
//    }
//    return nil;
//}
//- (id) copyWithZone:(NSZone *)zone { //第四步
//    return self;
//}

//*********************************************************
#pragma mark - 正则表达式
//字符组（Character classes）相当于一组字符中匹配单个字符。字符组出现在中括号[ 和 ]之间。
//   ^用在一行的开始
//   $ 用在一行的结束
//   \d代替[0-9]
/**
 *  @berif   regex 正则表达式
 *
 *  用正则表达式匹配手机号 验证是否为手机号
 *
 *  @param mobileNum 手机号字符串
 *
 *  竖线字符（|）执行的是或操作、反斜线（\）转义、
 *
 *  @return 如果是正确的手机号格式，返回YES，否则 返回NO
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum {
    if (mobileNum.length != 11)
    {
        return NO;
    }
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 17[6, 7, 8], 18[0-9], 170[0-9]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     * 联通号段: 130,131,132,155,156,185,186,145,176,1709
     * 电信号段: 133,153,180,181,189,177,1700
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705
     */
    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478])\\d{8}$)|(^1705\\d{7}$)";
    /**
     * 中国联通：China Unicom
     * 130,131,132,155,156,185,186,145,176,1709
     */
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|7[6]|8[56])\\d{8}$)|(^1709\\d{7}$)";
    /**
     * 中国电信：China Telecom
     * 133,153,180,181,189,177,1700
     */
    NSString *CT = @"(^1(33|53|77|8[019])\\d{8}$)|(^1700\\d{7}$)";
    
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    } else {
        return NO;
    }
}

///简单匹配是否是 手机号码 如果是正确的手机号格式，返回YES，否则 返回NO
+ (BOOL)judgeMobileNumber:(NSString *)mobileNum {
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|8[0-9]|70)\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    return [regextestmobile evaluateWithObject:mobileNum];
}

///是否是有效的正则表达式
+ (BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    return [predicate evaluateWithObject:strDestination];
}

//验证email
+ (BOOL)isValidateEmail:(NSString *)email {
    ////[ ] 输入数据类型 { }对应号码长度范
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    BOOL rt = [self isValidateRegularExpression:email byExpression:strRegex];
    return rt;
}

//验证电话号码
+ (BOOL)isValidateTelNumber:(NSString *)number {
    ////[0-9] 输入数据类型 {1,11}对应号码长度范围
    NSString *strRegex = @"[0-9]{1,20}";
    BOOL rt = [self isValidateRegularExpression:number byExpression:strRegex];
    return rt;
}
//*********************************************************
#pragma mark - 获取运营商信息
-(void)getcarrierName{
    
    CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = [telephonyInfo subscriberCellularProvider];
    NSString *currentCountry=[carrier carrierName];
    NSLog(@"[carrier isoCountryCode]==%@,[carrier allowsVOIP]=%d,[carrier mobileCountryCode=%@,[carrier mobileCountryCode]=%@",[carrier isoCountryCode],[carrier allowsVOIP],[carrier mobileCountryCode],[carrier mobileNetworkCode]);
}

//*********************************************************
#pragma mark - 获取iPhone型号
/// 获取iPhone型号
+ (NSString *)stringiPhoneDeviceVersion {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPod7,1"])   return @"iPod Touch 6G";
    
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    if ([platform isEqualToString:@"iPad4,7"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,8"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad4,9"])   return @"iPad Mini 3G";
    if ([platform isEqualToString:@"iPad5,1"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,2"])   return @"iPad Mini 4G";
    if ([platform isEqualToString:@"iPad5,3"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad5,4"])   return @"iPad Air 2";
    if ([platform isEqualToString:@"iPad6,3"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,4"])   return @"iPad Pro (9.7 inch)";
    if ([platform isEqualToString:@"iPad6,7"])   return @"iPad Pro (12.9 inch)";
    if ([platform isEqualToString:@"iPad6,8"])   return @"iPad Pro (12.9 inch)";
    
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    return platform;
}

#pragma mark - 解析网络上的数据
// 解析网络上的数据 data数据转字典、数组
+ (nullable id)getDicFromResponseObject:(nullable id)responseObject {
    
    // 如果是data数据
    if ([responseObject isKindOfClass:[NSData class]]) {
        return [self objectWithJSONData:responseObject options:NSJSONReadingMutableContainers];
    }
    // 如果是字典
    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        return responseObject;
    }
    // 如果是其他
    return nil;
}

///二进制数据转成字典、数组
+ (nullable id)objectWithJSONData:(nonnull NSData *)JSONData options:(NSJSONReadingOptions)option {
    
    NSError *error;
    //二进制数据转成字典
    id JSONObject = [NSJSONSerialization JSONObjectWithData:JSONData options:option error:&error];
    
    if (error != nil) {
        NSLog(@"json转换字典/数组出错:%@", error);
        return nil;
    } else if (JSONObject == nil) {
        NSLog(@"json转换字典/数组 结果为空");
        return nil;
    } else {
        return JSONObject;
    }
}
#pragma mark - json字符串转字典、数组
+ (nullable id)objectWithJSONString:(nonnull NSString *)JSONString {
    //字符串转变为二进制流 data数据
    NSData *data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    //data数据转换为字典或者数组
    return [self objectWithJSONData:data options:NSJSONReadingMutableContainers];
}

// 从字典里面取出一个安全的value值
+ (id)getValueFromDic:(NSDictionary *)dic withKey:(NSString *)key {
    //如果字典的key值对应的value不为空，并且字典不为空
    if (![dic[key] isKindOfClass:[NSNull class]] && dic.allKeys > 0) {
        return [self ergodicValueFromDic:dic withKey:key];
    }
    
    NSLog(@"%@是空", key);
    return nil;
}

/**
 *  遍历字典根据key值取出数据
 *
 *  @param dic 字典
 *  @param key key
 *
 *  @return 数据
 */
+ (id)ergodicValueFromDic:(NSDictionary *)dic withKey:(NSString *)key {
    for (NSString *miniKey in dic) {
        if ([miniKey isEqualToString:key]) {
            return dic[key];
        }
    }
    return nil;
}

#pragma mark - 字典转json格式字符串：
// 字典/数组 转json格式字符串：
+ (nullable NSString *)arrayOrDictionaryToJsonData:(nullable id)value {
    
    //isValidJSONObject判断对象是否可以转换为JSON数据
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSLog(@"The JSONObject is not JSON Object(对象不能转换为JSON数据)");
        return nil;
    }
    
    NSError *parseError = nil;
    //字典转成二进制数据
    //NSJSONWritingPrettyPrinted：的意思是将生成的json数据格式化输出，这样可读性高，不设置则输出的json字符串就是一整行。
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:value options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (parseError != nil) {
        NSLog(@"字典或数组转Json数据出错：%@", parseError);
    }
    
    //二进制流转变为字符串
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
//NSJSONReadingMutableContainers = (1UL << 0), 最外层是可变的字典和数组
//NSJSONReadingMutableLeaves = (1UL << 1),     里面的字符串也是可变的,iOS7 目前在iOS 7上测试不好用，应该是个bug
//NSJSONReadingAllowFragments = (1UL << 2)     最外层既不是字典也不是数组(允许JSON字符串最外层既不是NSArray也不是NSDictionary，
                                               //但必须是有效的JSON Fragment。例如使用这个选项可以解析 @“123” 这样的字符串。)
//NSJSONWritingPrettyPrinted：的意思是将生成的json数据格式化输出，这样可读性高，不设置则输出的json字符串就是一整行。
//kNilOptions     什么也不做

#/////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark - 系统时间戳
///获取系统时间戳 精确到秒
+ (long long)getSystemTimeStampAccurateToSeconds {
    NSDate *localDate = [NSDate date]; //获取当前时间
    long ls_time = (long)[localDate timeIntervalSince1970];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", ls_time]; //转化为UNIX时间戳
    NSLog(@"精确到秒timeSp:%@",timeSp); //时间戳的值
    return  ls_time;
}

///获取系统时间戳 精确到毫秒
+ (long long)getSystemTimeStampAccurateToMilliseconds {
    //dateWithTimeIntervalSinceNow:(NSTimeInterval)seconds
    //创建并返回一个NSDate对象设置为给定的当前日期和时间的秒数。
    //seconds 如果该值为整数,则表示以后的日期,如果为负数则表示以前的日期
    //返回一个NSDate的日期对象
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval ls_time = [date timeIntervalSince1970] * 1000; // *1000 是精确到毫秒，不乘就是精确到秒
    NSString *timeString = [NSString stringWithFormat:@"%f", ls_time]; //转为字符型
    // 注：不想有小数点用%.0f​就OK啦
    NSLog(@"精确到毫秒timeString:%@",timeString); //时间戳的值
    return ls_time;
}

///将系统时间戳转换成时间数据
+ (void)convertingSystemTimeStampToTimeData {
    // 2016-08-01 12:11:42 +0000
    //dateWithTimeIntervalSince1970:(NSTimeInterval)secs
    //创建并返回一个NSDate对象设置为给定的秒数从1970年1月1日就是UTC
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:([self getSystemTimeStampAccurateToSeconds] + 28800)];
    NSLog(@"精确到秒,时间戳转成时间data: = %@",confromTimesp); //之后就可以对NSDate进行格式或处理
    
    //2016-08-01 12:11:42 +0000
    NSDate *confromTimesp2 = [NSDate dateWithTimeIntervalSince1970:([self getSystemTimeStampAccurateToMilliseconds] / 1000 + 28800)];
    NSLog(@"精确到毫秒,时间戳转成时间data: = %@",confromTimesp2);
}

///将字符串转换为 NSDate 日期
+ (NSDate *)getDateFromString:(NSString *)string {
    // 日期格式化类
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    // 设置日期格式
    [inputFormatter setDateFormat:@"yyyyMMddHHmmss"];
    // NSString * -> NSDate *
    NSDate *inputDate = [inputFormatter dateFromString:string];
    NSLog(@"字符串转换后得到的date = %@", inputDate);
    
    return inputDate;
}

//判断一个日期 是否在 两个日期之间
+ (BOOL)isBetweenFrom:(NSString *)fromString to:(NSString *)toString {
    
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置日期时间格式
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    //字符串转换为时间 NSDate
    NSDate *startDate = [formatter dateFromString:fromString];
    NSDate *endDate = [formatter dateFromString:toString];
    
    //NSOrderedAscending:升序, 越往右边越大
    //NSOrderedDescending:降序, 越往右边越小
    if (([currentDate compare:startDate] == NSOrderedDescending) && ([currentDate compare:endDate] == NSOrderedAscending)) {
         NSLog(@"当前 %@ 时间在%@ 和 %@ 之间！",currentDate, startDate, endDate);
        
        return YES;
    }
    
    return NO;
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
+ (NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    // 生成当天的component
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    // 根据resultCalendar和resultComps生成日期
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierChinese];
    
    NSLog(@"dddddddddd%@", [resultCalendar dateFromComponents:resultComps]);
    
    return [resultCalendar dateFromComponents:resultComps];
}


//IOS中的唯一标识符
+ (NSString *)getUUIDString {
    
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (__bridge_transfer NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    
    return uuidString;
}

//*********************************************************
////单个文件的大小
- (long long)fileSizeAtPath:(NSString *)filePath {
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
//设置folderPath为cache路径。
- (float)folderSizeAtPath:(NSString *)folderPath {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath])  {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    return folderSize / (1024.0 * 1024.0);//得到缓存大小M
}

///*********** 清理缓存 方法 1 *****************/
//使用SDWebImage清理缓存

/*********** 清理缓存 方法 2 *****************/
//2 Library，存储程序的默认设置或其它 状态信息
+ (void)clearCache {
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    
    NSString *path = [paths lastObject];
    
    NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:path];
    
    for (NSString *p in files) {
        
        NSError *error;
        
        NSString *Path = [path stringByAppendingPathComponent:p];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:Path]) {
            
            [[NSFileManager defaultManager] removeItemAtPath:Path error:&error];
        }
    }
}
/*********** 清理缓存 方法 3 *****************/
//3 NSCachesDirectory 存放缓存文件
+ (void)clearCaches {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        NSLog(@"%@", cachPath);
        
        NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
        
        NSLog(@"files :%d",[files count]); //文件夹的数量
        
        for (NSString *p in files) {
            
            NSError *error;
            
            NSString *path = [cachPath stringByAppendingPathComponent:p];
            
            if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                
                [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
            }
        }
        [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
    });
}

- (void)clearCacheSuccess {
    
    NSLog(@"清理成功");
}


@end

