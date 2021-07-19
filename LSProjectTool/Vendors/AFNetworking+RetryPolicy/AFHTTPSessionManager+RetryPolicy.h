//
// AFNetworking+RetryPolicy.h
//
// * Supporting version AFNetworking 3 and above.*
//
// - This library is open-sourced and maintained by Jakub Truhlar.
// - Based on Shai Ohev Zion's solution.
// - AFNetworking is owned and maintained by the Alamofire Software Foundation.
//
// - Copyright (c) 2016 Jakub Truhlar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFHTTPSessionManager.h>
/// 允许的总重试次数, 剩余重试次数, 间隔延迟修饰符
typedef int (^RetryDelayCalcBlock)(int, int, int); // int totalRetriesAllowed, int retriesRemaining, int delayBetweenIntervalsModifier

/**
 *  增加了设置重试间隔、重试计数和累进的功能（使用幂规则，例如间隔=3->3、9、27等）\ ,failure`的调用时间不早于'retryCount`=0，只有'fatalStatusCodes`提前完成请求。
 *  支持AF3及以上版本。
 *
 *  retryCount       重试次数。1表示原始呼叫+一次重试=2次尝试
 *  retryInterval     两次尝试之间的时间间隔（秒）(超时未运行，请求已延迟且尚未运行）。
 *  progressive      下一个间隔将比上一个间隔花费更多的时间
 *  fatalStatusCodes 停止使用这些状态码
 */
@interface AFHTTPSessionManager (RetryPolicy)

/**
 *   打开重试策略日志消息. 仅在 `DEBUG` 目标中. 默认值是 `false`.
 */
@property (nonatomic, assign) bool retryPolicyLogMessagesEnabled;

/**
 *   增加了设置重试间隔、重试计数和累进的功能（使用幂规则，例如间隔=3->3、9、27等）
 *   `failure`的调用时间不早于'retryCount`=0，只有'fatalStatusCodes`提前完成请求
 */
- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers progress:(nullable void (^)(NSProgress *))downloadProgress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 *   Adds the ability to set the retry interval, retry count and progressive (uses power rule e.g. interval = 3 -> 3, 9, 27 etc.). `failure` is called no earlier than `retryCount` = 0, only `fatalStatusCodes` finishes the request earlier.
 *   增加了设置重试间隔、重试计数和累进的功能（使用幂规则，例如间隔=3->3、9、27等） `failure`的调用时间不早于'retryCount`=0，只有'fatalStatusCodes`提前完成请求。
 */
- (nullable NSURLSessionDataTask *)HEAD:(NSString *)URLString parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers success:(nullable void (^)(NSURLSessionDataTask *task))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 *   Adds the ability to set the retry interval, retry count and progressive (uses power rule e.g. interval = 3 -> 3, 9, 27 etc.). `failure` is called no earlier than `retryCount` = 0, only `fatalStatusCodes` finishes the request earlier.
 */
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers progress:(nullable void (^)(NSProgress *))downloadProgress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 *   Adds the ability to set the retry interval, retry count and progressive (uses power rule e.g. interval = 3 -> 3, 9, 27 etc.). `failure` is called no earlier than `retryCount` = 0, only `fatalStatusCodes` finishes the request earlier.
 */
- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block progress:(nullable void (^)(NSProgress *))downloadProgress success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 *   Adds the ability to set the retry interval, retry count and progressive (uses power rule e.g. interval = 3 -> 3, 9, 27 etc.). `failure` is called no earlier than `retryCount` = 0, only `fatalStatusCodes` finishes the request earlier.
 */
- (nullable NSURLSessionDataTask *)PUT:(NSString *)URLString parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 *   Adds the ability to set the retry interval, retry count and progressive (uses power rule e.g. interval = 3 -> 3, 9, 27 etc.). `failure` is called no earlier than `retryCount` = 0, only `fatalStatusCodes` finishes the request earlier.
 */
- (nullable NSURLSessionDataTask *)PATCH:(NSString *)URLString parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

/**
 *   Adds the ability to set the retry interval, retry count and progressive (uses power rule e.g. interval = 3 -> 3, 9, 27 etc.). `failure` is called no earlier than `retryCount` = 0, only `fatalStatusCodes` finishes the request earlier.
 */
- (nullable NSURLSessionDataTask *)DELETE:(NSString *)URLString parameters:(nullable NSDictionary *)parameters headers:(nullable NSDictionary <NSString *, NSString *> *)headers success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure retryCount:(NSInteger)retryCount retryInterval:(NSTimeInterval)retryInterval progressive:(bool)progressive fatalStatusCodes:(NSArray<NSNumber *> *)fatalStatusCodes;

@end
