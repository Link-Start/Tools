//
//  LSNetworking.m
//  Tedddd
//
//  Created by Xcode on 16/7/4.
//  Copyright © 2016年 Link+Start. All rights reserved.
//



#import "LSNetworking.h"

#import "Tools.h"

//判断文件是否存在，再导入使用
#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>
#else
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#endif
#import "AFHTTPSessionManager+RetryPolicy.h"



///装有任务的数组
static NSMutableArray *ls_requestTasks;
///返回的类型  默认JSON
static LSResponseType ls_responseType = LSResponseTypeJSON;
///请求的类型(格式)  默认JSON
static LSRequestType   ls_requestType = LSRequestTypeJSON;
///网络状态    默认未知网络
static LSNetworkStatus ls_networkStatus = LSNetworkStatusUnknow;
///网络请求接口基础url
static NSString *ls_baseUrl = nil;
/// 请求头
static NSDictionary *ls_httpHeaders = nil;
///请求超时时间   默认30秒
static NSTimeInterval ls_timeout = 30.0f;
///缓存get 数据  默认NO 不缓存
static BOOL ls_cacheGet = NO;
///缓存post 数据 默认NO 不缓存
static BOOL ls_cachePost = NO;
///应该自动编码
static BOOL ls_shouldAutoEncode = NO;
///应取消请求的回调
static BOOL ls_shouldCallbackOnCancelRequest = YES;
/// 当无连接的时候应获取本地数据
static BOOL ls_shouldObtainLocalWhenUnconnected = NO;
///最大缓存
static int ls_cacheMaxSize = 10485760;


@implementation LSNetworking
//默认不缓存GET请求的数据，对于POST请求也是不缓存的。如果要缓存GET、POST获取的数据，需要手动调用设置
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost {
    ls_cacheGet = isCacheGet;
    ls_cachePost = shouldCachePost;
}
///网络请求接口基础url
+ (NSString *)baseUrl {
    return ls_baseUrl;
}
///更新网络请求接口基础url
+ (void)updateBaseUrl:(NSString *)baseUrl {
    ls_baseUrl = baseUrl;
}

///请求超时时间 默认为30秒
+ (void)setRequestTimeoutInterval:(NSTimeInterval)timeout {
    ls_timeout = timeout;
}
/// 请求的连接超时时间，默认为30秒
- (void)setLs_requestTimeoutInterval:(NSTimeInterval)ls_requestTimeoutInterval {
    _ls_requestTimeoutInterval = ls_requestTimeoutInterval;
    ls_timeout = _ls_requestTimeoutInterval;
}

///当检查到网络异常时，是否从从本地提取数据。默认为NO。一旦设置为YES,当设置刷新缓存时
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain {
    ls_shouldObtainLocalWhenUnconnected = shouldObtain;
}

+ (void)openNetworkActivityIndicator:(BOOL)open {
    !open ? [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:NO] : nil ;
}


///应该自动编码
+ (BOOL)shouldEncode {
    return ls_shouldAutoEncode;
}
///配置公共的请求头，用于区分请求来源,需要与服务器约定好,只调用一次即可，通常放在应用启动的时候配置就可以了
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders {
    ls_httpHeaders = httpHeaders;
}

- (void)setLs_requestPriority:(LSRequestPriority)ls_requestPriority {
    _ls_requestPriority = ls_requestPriority;
    _ls_requestPriority = LSRequestPriorityDefault;
}

//inline 它的意思是告诉编译器这个函数是一个静态的内联函数
static inline NSString *cachePath() {
    /**
     *  返回Documents目录路径 (苹果建议将程序中创建的或在程序中浏览到的文件数据保存在该目录下)
     *  NSHomeDirectory():获得应用的根目录(获取沙盒路径),也就是Documents的上级目录,当然也是tmp目录的上级目录
     */
    return [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/LSNetworkingCaches"];
}

///清除缓存
+ (void)clearCaches {
    //获取Documents下的文件路径
    NSString *directoryPath = cachePath();
    
    //如果 directoryPath 是文件
    if ([[NSFileManager defaultManager] fileExistsAtPath:directoryPath isDirectory:nil]) {
        NSError *error = nil;
        //删除文件
        [[NSFileManager defaultManager] removeItemAtPath:directoryPath error:&error];
        
        //如果有错误
        if (error) {
            NSLog(@"缓存清除错误(文件删除错误!) error: %@", error);
        } else {
            NSLog(@"缓存清除成功(文件删除成功!)");
        }
    }
}

///计算缓存大小
+ (unsigned long long)totalCacheSize {
    //获取Documents下的文件路径
    NSString *directoryPath = cachePath();
    //创建文件管理器
    NSFileManager *fm = [NSFileManager defaultManager];
    // isDir判断是否为文件夹
    BOOL isDir = NO;
    //记录文件大小
    unsigned long long total = 0;
        
    ////判断文件是否存在，这个方法也可以判断目录是否存在，这要后面的参数设置位YES
    if ([fm fileExistsAtPath:directoryPath isDirectory:&isDir]) {//fileExistsAtPath判断返回NO
        
        if (isDir) {
            //
            NSError *error = nil;
            //获得指定路径path的所有内容(文件和文件夹)
            NSArray *array = [fm contentsOfDirectoryAtPath:directoryPath error:&error];
            
            //如果错误 为空
            if (error == nil) {
                
                for (NSString *subpath in array) {
                    //拼接全路径
                    NSString *path = [directoryPath stringByAppendingPathComponent:subpath];
                    //获得文件属性
                    NSDictionary *dict = [fm attributesOfItemAtPath:path error:&error];
                    //如果没有错误
                    if (!error) {
                        total += [dict[NSFileSize] unsignedIntegerValue];
                    }
                }
            }
        }
    }
    
    //返回文件大小
    return total;
}

///单利
+ (instancetype)sharedLSNetworking {
    static LSNetworking *ls_networking = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ls_networking = [[LSNetworking alloc] init];
    });
    return ls_networking;
}
///单利
+ (LSURLSessionTask *)shareSessionTask {
    static LSURLSessionTask *sessionTask = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sessionTask = [[LSURLSessionTask alloc] init];
    });
    return sessionTask;
}

///装有任务的数组
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (ls_requestTasks == nil) {
            ls_requestTasks = [NSMutableArray arrayWithCapacity:1];
        }
    });
    return ls_requestTasks;
}

///取消所有的请求
+ (void)cancelAllRequest {
    @synchronized(self) { //为了线程安全(添加线程锁)
        [[self allTasks] enumerateObjectsUsingBlock:^(__kindof LSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[LSURLSessionTask class]]) {
                [task cancel];
            }
        }];
        
        [[self allTasks] removeAllObjects];
    };
}

///取消某个请求
+ (void)cancelRequestWithURL:(NSString *)url {
    if (url == nil) {
        return;
    }
    @synchronized(self) { //为了线程安全(添加线程锁)
        [[self allTasks] enumerateObjectsUsingBlock:^(__kindof LSURLSessionTask * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[LSURLSessionTask class]]
                && [task.currentRequest.URL.absoluteString hasSuffix:url]) {
                [task cancel];
                [[self allTasks] removeObject:task];
                *stop = YES;
                return;
            }
        }];
    };
}

///配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
+ (void)configRequestType:(LSRequestType)requestType
             responseType:(LSResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest {
    ls_requestType = requestType;
    ls_responseType = responseType;
    ls_shouldAutoEncode = shouldAutoEncode;
    ls_shouldCallbackOnCancelRequest = shouldCallbackOnCancelRequest;
}

///网址判断拼接 如果设置了基础网址url 将基础url和传入的字符串拼接 返回
+ (NSString *)absoluteUrlWithPath:(NSString *)path {
    
    //如果传入的网址path为空 或者 path长度为0  返回 空字符串(零长度字符串往往指的是空串)
    if (path == nil || path.length == 0) {
        NSLog(@"🔥🔥🔥 传入的网址path为空 或者 path长度为0 🔥🔥🔥");
        return @"";
    }
    
    //检查地址中是否有中文
//    path = [NSURL URLWithString:path] ? path : [path stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    //如果没有设置基础网址(基础网址baseUrl为空) 或者 基础网址长度为0 返回传入的网址路径
    if ([self baseUrl] == nil || [self baseUrl].length == 0) {
        return path;
    }
    
    //下面的情况都是基于设置了 基础url 进行的 没有设置基础url的 在上面一步就返回了
    //绝对网址
    NSString *absouluteUrl = path;
    
    //如果传入的网址 不是以http:// 或者 https:// 开头
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"https://"]) {
        
        //如果设置的基础url中含有 /
        if ([[self baseUrl] hasSuffix:@"/"]) {
            //如果传入的网址以 / 开头
            if ([path hasPrefix:@"/"]) {
                NSMutableString *mutablePath = [NSMutableString stringWithString:path];
                //将开头的 / 删除
                [mutablePath deleteCharactersInRange:NSMakeRange(0, 1)];
                //将基础url和 删除 / 后的字符串 拼接起来
                absouluteUrl = [NSString stringWithFormat:@"%@%@", [self baseUrl], mutablePath];
                
            } else {
                //如果传入的网址的开头没有 / 直接将基础url和传入的网址路径拼接起来
                absouluteUrl = [NSString stringWithFormat:@"%@%@", [self baseUrl], path];
            }
            
            //如果设置的基础url中没有 /
        } else {
            
            //如果传入的网址路径 以 / 开头
            if ([path hasPrefix:@"/"]) {
                //直接将基础url和传入的网址路径拼接起来
                absouluteUrl = [NSString stringWithFormat:@"%@%@", [self baseUrl], path];
                
                //如果传入的网址路径不是以 / 开头
            } else {
                //将基础url和传入的网址路径 中间加个 / 一起拼接起来
                absouluteUrl = [NSString stringWithFormat:@"%@/%@", [self baseUrl], path];
            }
        }
    }
    //返回拼接后的网址
    return absouluteUrl;
}
///使用UTF8 编码字符串
+ (NSString *)encodeUrl:(NSString *)urlStr {
    //使用系统方法对 字符串进行UTF+8编码
    NSString *newString = @"";
//    if (@available(iOS 9.0, *)) {
//        //对url中的中文进行转码
//        newString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
//    } else {
//        newString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    }
    
    if ([[NSString alloc] respondsToSelector:@selector(stringByAddingPercentEncodingWithAllowedCharacters:)]) {
        //对url中的中文进行转码
        newString = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    } else {
        newString = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    
    
    //如果编码成功 字符串不为空 返回编码后的字符串
    if (newString) {
        return newString;
    }
    //如果编码不成功 返回原来的字符串
    NSLog(@"字符串编码失败!");
    return urlStr;
}

#pragma mark + Private 私有方法
+ (AFHTTPSessionManager *)ls_manager {
    // 开启转圈圈        
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    //创建管理者对象
    AFHTTPSessionManager *manager = nil;;
    if ([self baseUrl] != nil) { //如果设置了基础url
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    } else {
        manager = [ AFHTTPSessionManager manager];
    }
    
    //配置数据类型
    [self configDataType:manager];
    
    //设置支持https
//    manager.securityPolicy = [self customSecurityPolicy];
    
    //用于序列化的字符串的编码参数
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    //请求头
    for (NSString *key in ls_httpHeaders.allKeys) {
        if (ls_httpHeaders[key] != nil) {
            [manager.requestSerializer setValue:ls_httpHeaders[key] forHTTPHeaderField:key];
        }
    }
    //可接受的内容类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:
                                                         @"application/json",
                                                         @"text/html",
                                                         @"text/json",
                                                         @"text/plain",
                                                         @"text/javascript",
                                                         @"text/xml",
                                                         @"image/*",
                                                         @"application/octet+stream",
                                                         @"application/zip",
                                                         nil
                                                         ];
    //设置请求超时时间
    manager.requestSerializer.timeoutInterval = ls_timeout;
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    //如果 当无连接的时候应获取本地数据  并且 (默认缓存Get数据或者Post数据)
    if (ls_shouldObtainLocalWhenUnconnected && (ls_cacheGet || ls_cachePost)) {
        //检测网络
        [self startMonitoring];
    }
    
    //每次网络请求的时候，检查此时磁盘中的缓存大小，如果超过阈值，则清理所有缓存
    //未来优化点：1、这里到时会做进一步优化，到时会有两种清理策略，一种基于时间维度，一种基于缓存大小,
    //          2、清理也不会清理全部，会采取LRU算法来淘汰在磁盘中价值最低的缓存
    if ([self totalCacheSize] > ls_cacheMaxSize) {
        
        [self clearCaches];
    }
    
    return manager;
}

///配置数据类型
+ (void)configDataType:(AFHTTPSessionManager *)manager {
    //请求数据类型 请求格式 默认JSON
    switch (ls_requestType) {
        case LSRequestTypeJSON: { //JSON
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        }
        case LSRequestTypeHTTP: { //二进制格式
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        case LSRequestTypePropertyList: { //plist
            manager.requestSerializer = [AFPropertyListRequestSerializer serializer];
            break;
        }
        case LSRequestTypePlainText: { // 普通text/html
            manager.requestSerializer = [AFHTTPRequestSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    ///返回的数据类型  返回格式 默认JSON
    switch (ls_responseType) {
        case LSResponseTypeJSON: { //JSON
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case LSResponseTypeHTTP: { //二进制格式
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        }
            
        case LSResponseTypeXML: { //xml
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case LSResponseTypePropertyList: { //plist
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
}

/**
 AFNetworking的请求AFHTTPSessionManager 有一个专门的属性来处理加密策略，AFSecurityPolicy
 创建一个AFSecurityPolicy
 AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
 传入参数表示https验证模式，一共三种选项
 typedef NS_ENUM(NSUInteger, AFSSLPinningMode) {
     //不验证
     AFSSLPinningModeNone,
     //只验证公钥
     AFSSLPinningModePublicKey,
     //验证证书
     AFSSLPinningModeCertificate,
 };
 // AFSecurityPolicy还有三个重要属性
 //可以去匹配服务端证书验证的证书
 @property (nonatomic, strong, nullable) NSSet <NSData *> *pinnedCertificates;
 //是否支持非法的证书（例如自签名证书）
 @property (nonatomic, assign) BOOL allowInvalidCertificates;
 //是否去验证证书域名是否匹配
 @property (nonatomic, assign) BOOL validatesDomainName;
 */

///支持https
+ (AFSecurityPolicy *)customSecurityPolicy {
    
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"你的证书名字" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    
    
//    //设置非校验证书模式
//    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];//设置证书模式
//    manager.securityPolicy.allowInvalidCertificates = YES;//客户端是否信任非法证书
//    [manager.securityPolicy setValidatesDomainName:NO];//是否在证书域字段中验证域名
    
    
    return securityPolicy;
}

#pragma mark + Get请求
///基础
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                                success:(void (^)(id response))success
                                   fail:(void (^)(NSError *error))fail {
    return [self getDataWithUrlStr:urlStr
                      refreshCache:refreshCache
                        Parameters:nil
                           success:success
                           failure:fail];
}
///带参数
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr refreshCache:(BOOL)refreshCache Parameters:(NSDictionary *)parameters success:(void (^)(id response))success failure:(void (^)(NSError *error))failure {
    return [self getDataWithUrlStr:urlStr refreshCache:refreshCache Parameters:parameters progress:nil success:success fail:failure];
}
///有进度 回调
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr refreshCache:(BOOL)refreshCache Parameters:(NSDictionary *)Parameters progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress success:(void (^)(id response))success fail:(void (^)(NSError *error))fail {
    return [self getDataWithUrlStr:urlStr refreshCache:refreshCache Parameters:Parameters graceTime:0.5 progress:progress success:success fail:fail];
}
///设置多久之后显示提示语
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                             Parameters:(NSDictionary *)Parameters
                              graceTime:(CGFloat)graceTime
                               progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                success:(void (^)(id response))success
                                   fail:(void (^)(NSError *error))fail {
    return [self getDataWithUrlStr:urlStr refreshCache:refreshCache Parameters:Parameters graceTime:graceTime markedWords:@"加载中..." progress:progress success:success fail:fail];
}
///可以设置显示的提示语内容
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                             Parameters:(NSDictionary *)Parameters
                              graceTime:(CGFloat)graceTime
                            markedWords:(NSString *)markedWords
                               progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                success:(void (^)(id response))success
                                   fail:(void (^)(NSError *error))fail {
   return [self ls_requestWithUrlStr:urlStr refreshCache:refreshCache httpMedth:0 Parameters:Parameters graceTime:graceTime markedWords:markedWords progress:progress success:success fail:fail];
}
///GET
+ (__kindof LSURLSessionTask *)ls_requestWithUrlStr:(NSString *)urlStr
                              refreshCache:(BOOL)refreshCache
                                 httpMedth:(NSUInteger)httpMethod
                                Parameters:(NSDictionary *)Parameters
                                 graceTime:(CGFloat)graceTime
                               markedWords:(NSString *)markedWords
                                  progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                   success:(void (^)(id response))success
                                      fail:(void (^)(NSError *error))fail {
    
     __weak __typeof(self)weakSelf = self;
    
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    //提示语
//    hud.labelText = markedWords;
    hud.label.text = markedWords;
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [self ls_manager];
    
    //处理网址
    NSString *absoluteUrlStr = [self createPublicBasicSettingsWithurlString:urlStr];
        
    //创建任务 开始请求数据
    LSURLSessionTask *sessionTask = [manager GET:absoluteUrlStr parameters:Parameters headers:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /*********1.直接返回原始数据**********/
        //数据请求解析成功, 解析数据
//        [self successResponse:responseObject callback:success hideHud:hud];
        //从数组中移除任务
        [[self allTasks] removeObject:sessionTask];
        
        
        /*********2.服务器返回统一类型数据,根据接口进行数据处理 再返回**********/
        //手动关闭MBProgressHUD
        [self hiddenHud:hud];
        NSDictionary *dict = [self tryToParseData:responseObject];
        if ([dict[@"success"] boolValue]) {
            if (success) {
                success(dict[@"data"]);
            }
            return;
        }
        
        [MBProgressHUD qucickTip:[NSString stringWithFormat:@"%@", dict[@"message"]]];
        if (fail) {
            NSDictionary *errorUserInfo = @{NSLocalizedFailureReasonErrorKey:dict[@"message"]?:@""};
            NSInteger ls_code = [[[dict[@"code"] stringByReplacingOccurrencesOfString:@"_" withString:@"0"] stringByReplacingOccurrencesOfString:@"-" withString:@"0"] integerValue];
            fail([NSError errorWithDomain:@"lsError" code:ls_code userInfo:errorUserInfo]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //从数组中移除任务
        [[self allTasks] removeObject:task];
        // 数据请求失败 返回错误
        [self handleCallbackWithError:error fail:fail hideHud:hud];
    }];
    
    // 设置请求的优先级
    [weakSelf ls_configRequestPriority:sessionTask];
    
    //开始启动任务
    [sessionTask resume];
    
    //把任务加入数组中
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

///设置请求的优先级
- (void)ls_configRequestPriority:(__kindof LSURLSessionTask *)sessionTask {
    
     __weak __typeof(self)weakSelf = self;
    
    if ([sessionTask respondsToSelector:@selector(priority)]) {
        
        switch (weakSelf.ls_requestPriority) {
            case LSRequestPriorityHigh:
                sessionTask.priority = NSURLSessionTaskPriorityHigh;
                break;
            case LSRequestPriorityLow:
                sessionTask.priority = NSURLSessionTaskPriorityLow;
                break;
            case LSRequestPriorityDefault:
                sessionTask.priority = NSURLSessionTaskPriorityDefault;
            default:
                sessionTask.priority = NSURLSessionTaskPriorityDefault;
                break;
        }
    }
}

///公共基本设置(对网址字符串urlStr的一些判断处理)
+ (NSString *)createPublicBasicSettingsWithurlString:(NSString *)urlString {
    //经过处理后的网址
    NSString *absoluteUrlStr = [self absoluteUrlWithPath:urlString];
    //如果没有设置基础url
    if ([self baseUrl] == nil) {
        //检查地址中是否有中文 ++ 如果传入的字符串url不能转换为 NSURL 类型()
        if ([NSURL URLWithString:urlString] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            
            ls_shouldAutoEncode = YES;//自动UTF+8编码
            return nil;
        }
    } else {
        //如果 拼接后的字符串absoluteUrl不能转换为NSURL 类型
        if ([NSURL URLWithString:absoluteUrlStr] == nil) {
            NSLog(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
            
            ls_shouldAutoEncode = YES;//自动UTF+8编码
            return nil;
        }
    }
    //如果需要对网址字符串进行编码
    if ([self shouldEncode]) {
        //对字符串进行编码
        absoluteUrlStr = [self encodeUrl:absoluteUrlStr];
    }
    
    return absoluteUrlStr;
}

///数据请求成功的回调方法
+ (void)successResponse:(id)responseData callback:(void (^)(id response))success hideHud:(MBProgressHUD *)hud {
    //手动关闭MBProgressHUD
    [self hiddenHud:hud];
    
    //如果调用了block
    if (success) {
        //block
        success([self tryToParseData:responseData]);
    }
}

///数据请求失败的回调方法(错误处理回调)
+ (void)handleCallbackWithError:(NSError *)error fail:(void (^)(NSError *error))fail hideHud:(MBProgressHUD *)hud {
    
    //手动关闭MBProgressHUD
    [self hiddenHud:hud];
    
    if ([error code] == NSURLErrorCancelled) { //如果错误代码 是请求取消
        if (ls_shouldCallbackOnCancelRequest) { //如果 取消请求的回调 = yes
            //如果调用了block
            if (fail) {
                fail(error);
            }
        }
        
    } else {
        //如果调用了block
        if (fail) {
            fail(error);
        }
    }
    
    //根据错误代码显示提示信息
    [self showFailMarkedWordsWithError:error];
}

/** 尝试解析数据
 *  解析数据
 *
 *  @param responseData 服务器返回的数据
 *
 *  @return 解析后的数据
 */
+ (id)tryToParseData:(id)responseData {
    
    ////这种可以打印中文
    //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    
    //NSNull:数组中元素的占位符，数据中的元素不能为nil（可以为空，也就是NSNull），
    //原因：nil 是数组的结束标志
    //kCFNull: NSNull的单例
    if (!responseData || responseData == (id)kCFNull) {
        NSLog(@"原数据为nil， 返回nil");
        return nil;
    }
    
    NSData *jsonData = nil;
    id jsonResults = nil;
    
    if ([responseData isKindOfClass:[NSDictionary class]]) {//如果是字典
        NSLog(@"返回原字典");
        return responseData;
    } else if ([responseData isKindOfClass:[NSArray class]]) {//如果是数组
        NSLog(@"返回原数组");
        return responseData;
    } else if ([responseData isKindOfClass:[NSString class]]) {//如果是NSString类型
        NSLog(@"字符串类型");
        jsonData = [(NSString *)responseData dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([responseData isKindOfClass:[NSData class]]) {//如果是NSData 类型
        jsonData = responseData;
    }
    
    if (jsonData) {
        NSError *error = nil;
        //使用缓冲区数据来解析 解析json数据
        //NSJSONReadingMutableContainers：返回可变容器,NSMutableDictionary或NSMutableArray
        jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments | kNilOptions error:&error];
        if (error != nil) {
            NSLog(@"有错误, 返回原数据");
            return responseData;
        } else {
            if ([jsonResults isKindOfClass:[NSDictionary class]]) {
                NSLog(@"JSON数据返回字典");
            } else if ([jsonResults isKindOfClass:[NSArray class]]) {
                NSLog(@"JSON数据返回数组");
            } else if ([jsonResults isKindOfClass:[NSString class]]) {
                NSLog(@"JSON数据返回字符串");
            } else if (jsonResults == nil && [responseData isKindOfClass:[NSString class]]) {
                NSLog(@"返回原字符串");
                return responseData;
            } else if (jsonResults == nil && [responseData isKindOfClass:[NSData class]]) {
                // 不是数组，不是字典，还不是字符串吗？
                NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                return string;
            } else {
                // 未识别
                NSLog(@"未识别防止解析报错，原数据返回nil");
                NSLog(@"未识别原数据：%@",responseData);
                return nil;
            }
        }
        return jsonResults;
    }
    //返回原数据
    return responseData;
    
    
    //如果是NSData类型的数据
    if ([responseData isKindOfClass:[NSData class]]) {
        //尝试解析为JSON
        if (responseData == nil) { //如果数据为空,直接返回
            return responseData;
        } else {
            
            NSError *error = nil;
            //使用缓冲区数据来解析 解析json数据
            //NSJSONReadingMutableContainers：返回可变容器,NSMutableDictionary或NSMutableArray
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
            //如果 有 错误error
            if (error != nil) {
                return responseData; //返回原来的数据
                
            } else { //如果没有错误 返回解析后的数据
                return response;
            }
            
//            return (error != nil) ? responseData : response;
        }
        
    } else { //如果不是NSData类型的数据,直接返回 原来的数据
        return responseData;
    }
}


#pragma mark + POST请求
///基础
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr refreshCache:(BOOL)refreshCache parameters:(NSDictionary *)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    return [self postDataWithUrlStr:urlStr refreshCache:refreshCache parameters:parameters progress:nil success:success fail:failure];
}
///有进度 回调
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr refreshCache:(BOOL)refreshCache parameters:(NSDictionary *)parameters progress:(void (^)(int64_t, int64_t))progress success:(void (^)(id))success fail:(void (^)(NSError *))fail {
    return [self postDataWithUrlStr:urlStr refreshCache:refreshCache parameters:parameters graceTime:0.6 progress:progress success:success fail:fail];
}
///可以设置多久之后显示提示语
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr
                            refreshCache:(BOOL)refreshCache
                              parameters:(NSDictionary *)parameters
                               graceTime:(CGFloat)graceTime
                                progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                 success:(void (^)(id response))success
                                    fail:(void (^)(NSError *error))fail {
    return [self postDataWithUrlStr:urlStr refreshCache:refreshCache parameters:parameters graceTime:graceTime markedWords:@"加载中..." progress:progress success:success fail:fail];
}
/// 可以设置显示的提示语内容
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr
                            refreshCache:(BOOL)refreshCache
                              parameters:(NSDictionary *)parameters
                               graceTime:(CGFloat)graceTime
                             markedWords:(NSString *)markedWords
                                progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                 success:(void (^)(id response))success
                                    fail:(void (^)(NSError *error))fail {
    return [self ls_requestWithUrlStr:urlStr refreshCache:refreshCache httpMedth:1 parameters:parameters graceTime:graceTime markedWords:markedWords progress:progress success:success fail:fail];
}
///POST
+ (__kindof LSURLSessionTask *)ls_requestWithUrlStr:(NSString *)urlStr
                              refreshCache:(BOOL)refreshCache
                                 httpMedth:(NSUInteger)httpMethod
                                parameters:(NSDictionary *)parameters
                                 graceTime:(CGFloat)graceTime
                               markedWords:(NSString *)markedWords
                                  progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                   success:(void (^)(id response))success
                                      fail:(void (^)(NSError *))fail {
    
     __weak __typeof(self)weakSelf = self;
    
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    //提示语
//    hud.labelText = markedWords;
    hud.label.text = markedWords;
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [self ls_manager];
    //处理网址
    NSString *absoluteUrlStr = [self createPublicBasicSettingsWithurlString:urlStr];
//    [manager POST:@"" parameters:nil headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        [formData appendPartWithHeaders:nil body:[NSData data]];//这个body里面换成你的data数据
//    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) { } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) { }];
    
    //创建任务 开始请求数据
    LSURLSessionTask *sessionTask = [manager POST:absoluteUrlStr parameters:parameters headers:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //数据请求解析成功, 解析数据
        [self successResponse:responseObject callback:success hideHud:hud];
        //从数组中移除任务
        [[self allTasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //从数组中移除任务
        [[self allTasks] removeObject:task];
        // 数据请求失败 返回错误
        [self handleCallbackWithError:error fail:fail hideHud:hud];
    } retryCount:3 retryInterval:3 progressive:NO fatalStatusCodes:@[@(401)]];
    
    // 设置请求的优先级
    [weakSelf ls_configRequestPriority:sessionTask];
    
    //启动任务
    [sessionTask resume];
    
    //将任务添加到数组
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark + 上传图片的方法 NSData 数据流
#pragma mark + 单个图片 NSData 数据流
+ (__kindof LSURLSessionTask *)uploadWithImage:(UIImage *)image urlStr:(NSString *)urlStr imageKey:(NSString *)imageKey parameters:(NSDictionary *)parameters progress:(void (^)(int64_t, int64_t))progress success:(void (^)(id))success ail:(void (^)(NSError *))fail {
    
     __weak __typeof(self)weakSelf = self;
    
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:0.6];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [self ls_manager];
    //处理网址
    NSString *absoluteUrlStr = [self createPublicBasicSettingsWithurlString:urlStr];
    //创建任务 开始上传图片
    LSURLSessionTask *sessionTask = [manager POST:absoluteUrlStr parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //可以在上传时使用当前系统时间作为文件名
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnsTheCurrentSystemTimeStamp]];
        
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        /* 此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"] ++ 参数对应的key值
         3. 要保存在服务器上的[文件名]
         4. 上传文件的类型 [mimeType]
         */
        //服务器上传文件的字段和类型 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:imageKey fileName:fileName mimeType:@"image/png/file/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //如果调用了progress
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
        //打印 上传进度
        NSLog(@"上传进度：%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //数据请求解析成功, 解析数据
        [self successResponse:responseObject callback:success hideHud:hud];
        //从数组中移除任务
        [[self allTasks] removeObject:sessionTask];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        //从数组中移除任务
        [[self allTasks] removeObject:task];
        // 数据请求失败 返回错误
        [self handleCallbackWithError:error fail:fail hideHud:hud];
    }];
    
    // 设置请求的优先级
    [weakSelf ls_configRequestPriority:sessionTask];
    
    //开始启动任务
    [sessionTask resume];
    //将任务添加到数组
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}
#pragma mark + 多张图片上传 NSData 数据流
+ (__kindof LSURLSessionTask *)uploadWithImages:(NSArray<UIImage *> *)images urlStr:(NSString *)urlString parameters:(NSDictionary *)parameters imageKey:(NSString *)imageKey success:(void (^)(id))success fail:(void (^)(NSError *))fail {
    
     __weak __typeof(self)weakSelf = self;
    
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:0.7];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [self ls_manager];
    //处理网址
    NSString *absoluteUrlStr = [self createPublicBasicSettingsWithurlString:urlString];
    //创建任务 开始上传图片
    LSURLSessionTask *sessionTask = nil;
    
    for (UIImage *image in images) {
    sessionTask = [manager POST:absoluteUrlStr parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            //可以在上传时使用当前系统时间作为文件名
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnsTheCurrentSystemTimeStamp]];
            
            // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
            //UIImageJPEGRepresentation(UIImage* image, 1.0) 返回的图片数据量比较小
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            /* 此方法参数
             1. 要上传的[二进制数据]
             2. 对应网站上[upload.php中]处理文件的[字段"file"] ++ 参数对应的key值
             3. 要保存在服务器上的[文件名]
             4. 上传文件的类型 [mimeType]
             */
            //服务器上传文件的字段和类型 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:imageKey fileName:fileName mimeType:@"image/png/file/jpg"];
        
        // 这样也可以传
//        for (NSData *filedata in filedatas) {
//          NSString *fileName = [NSString stringWithFormat:@"chosedFile%d.jpg",[filedatas indexOfObject:filedata]];
//          [formData appendPartWithFileData:filedata name:@"file" fileName:fileName mimeType:@"image/jpeg"];
//        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印 上传进度
        NSLog(@"上传进度：%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSLog(@"%@", responseObject);
            //数据请求解析成功, 解析数据
            [self successResponse:responseObject callback:success hideHud:hud];
            //从数组中移除任务
            [[self allTasks] removeObject:sessionTask];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            //从数组中移除任务
            [[self allTasks] removeObject:task];
            // 数据请求失败 返回错误
            [self handleCallbackWithError:error fail:fail hideHud:hud];
        }];
    }
    // 设置请求的优先级
    [weakSelf ls_configRequestPriority:sessionTask];
    
    //开始启动任务
    [sessionTask resume];
    //将任务添加到数组
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

///处理image
+ (NSData *)imageData:(UIImage *)image {
    NSData *data = UIImageJPEGRepresentation(image, 1.0);
    if (data.length > 100 * 1000) {
        if (data.length > 1000 * 1000) { // 1M 以上
            data = UIImageJPEGRepresentation(image, 0.1);
            
        } else if (data.length > 512 * 1000) { // 0.5M~1M
            data = UIImageJPEGRepresentation(image, 0.5);
            
        } else if (data.length > 256 * 1000) { // 0.25~1M
            data = UIImageJPEGRepresentation(image, 0.9);
        }
    }
    return data;
}

#pragma mark - 使用Base64字符串上传图片
/**
 *  适合上传图片数量比较少的，比如上传头像，上传图片数量多的话，速度会慢些
 */
+ (void)uploadImagesBase64:(UIImage *)image toURL:(NSString *)urlString parameters:(NSDictionary*)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    NSString *imageBase64Str = [self imageChangeBase64:image];
    
    NSDictionary *param = @{
                            @"对应的参数":imageBase64Str
                            };
    [self postDataWithUrlStr:urlString refreshCache:NO parameters:param success:finish failure:failure];
}

#pragma mark -- image转化成Base64位
+ (NSString *)imageChangeBase64: (UIImage *)image{
    
    NSData *imageData = nil;
    //方法1
    if (UIImagePNGRepresentation(image) == nil) {
        imageData = UIImageJPEGRepresentation(image, 1.0);
    } else {
        imageData = UIImagePNGRepresentation(image);
    }
    
    //方法2
    //NSString *mimeType  = nil;
    //    if ([self imageHasAlpha:image]) {
    //
    //        imageData = UIImagePNGRepresentation(image);
    //        //mimeType = @"image/png";
    //    }else{
    //
    //        imageData = UIImageJPEGRepresentation(image, 0.3f);
    //        //mimeType = @"image/jpeg";
    //    }
    
    return [NSString stringWithFormat:@"%@",[imageData base64EncodedStringWithOptions: 0]];
}

// base64 转图片
- (UIImage *)base64ChangeImage:(NSString *)string {
    
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    UIImage *img = [UIImage imageWithData:imageData];
    return img;
}


//+  (BOOL)imageHasAlpha:(UIImage *)image{
//
//    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
//    return (alpha == kCGImageAlphaFirst ||
//            alpha == kCGImageAlphaLast ||
//            alpha == kCGImageAlphaPremultipliedFirst ||
//            alpha == kCGImageAlphaPremultipliedLast);
//
//}


#pragma mark + 上传语音 通过URL来获取路径，进入沙盒或者系统相册等等
#pragma mark + 上传 通过文件路径
+ (__kindof LSURLSessionTask *)uploadWithAudioPath:(NSString *)audioPath urlStr:(NSString *)urlStr parameters:(NSDictionary *)parameters audioKey:(NSString *)audioKey success:(void(^)(id responseData))success fail:(void(^)(NSError *error))fail {
    
     __weak __typeof(self)weakSelf = self;
    
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:0.6];
    
    //创建管理者对象
    AFHTTPSessionManager *manager = [self ls_manager];
    //要保存在服务器上的[文件名] ++ 以当时的时间为文件名
    NSString *fileName = [NSString stringWithFormat:@"%@", [self returnsTheCurrentSystemTimeStamp]];
    //处理网址
    NSString *absoluteUrlStr = [self createPublicBasicSettingsWithurlString:urlStr];
    //创建任务 开始上传 
    LSURLSessionTask *sessionTask = [manager POST:absoluteUrlStr parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /*  appendPartWithFileURL   //  指定上传的文件路径
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  要保存在服务器上的[文件名] ++++ 可以随便写
         *  mimeType                //  指定上传文件的MIME类型
         *  error                   //  第五个参数：错误信息，传地址
         */
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:audioPath] name:audioKey fileName:fileName mimeType:@"application/octet+stream" error:nil];
        
//        1.文件上传拼接数据的第一种方式
//        [formData appendPartWithFileData:data name:@"file" fileName:@"Image.png" mimeType:@"application/octet+stream"];
//        2.文件上传拼接数据的第二种方式
//        [formData appendPartWithFileURL:fileUrl name:@"file" fileName:@"Image2.png" mimeType:@"application/octet+stream" //error:nil];
//        3.文件上传拼接数据的第三种方式
        //说明：AFN内部自动获得路径URL地址的最后一个节点作为文件的名称，内部调用C语言的API获得文件的类型
//        [formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        //从数组中移除任务
        [[self allTasks] removeObject:sessionTask];
        //数据请求解析成功, 解析并返回数据
        [self successResponse:responseObject callback:success hideHud:hud];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //从数组中移除任务
        [[self allTasks] removeObject:task];
        // 数据请求失败 返回错误
        [self handleCallbackWithError:error fail:fail hideHud:hud];

    }];
    
    // 设置请求的优先级
    [weakSelf ls_configRequestPriority:sessionTask];
    
    //开始启动任务
    [sessionTask resume];
    //将任务添加到数组
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark + 上传文件
+ (__kindof LSURLSessionTask *)uploadFileWithUrlStr:(NSString *)urlStr uploadingFile:(NSString *)uploadingFile progress:(void (^)(int64_t, int64_t))progress success:(void (^)(id))success fail:(void (^)(NSError *))fail {
    
    //如果 待上传文件的路径 不能转换为 NSURL类型 返回空
    if ([NSURL URLWithString:uploadingFile] == nil) {
        NSLog(@"uploadingFile无效，无法生成URL。请检查待上传文件是否存在");
        return nil;
    }
    
     __weak __typeof(self)weakSelf = self;
    
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:0.6];
    
    //上传地址
    NSURL *uploadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self createPublicBasicSettingsWithurlString:urlStr]]];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [self ls_manager];
    //创建请求对象
    NSURLRequest *request = [NSURLRequest requestWithURL:uploadURL];
    //创建任务开始请求
    LSURLSessionTask *sessionTask = [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        //如果调用了block
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {

        //从数组中移除任务
        [[self allTasks] removeObject:sessionTask];
        //数据请求解析成功, 解析并返回数据
        [self successResponse:responseObject callback:success hideHud:hud];
        //如果有错误
        if (error) {
            // 数据请求失败 返回错误
            [self handleCallbackWithError:error fail:fail hideHud:hud];
        }
    }];
//    [manager uploadTaskWithRequest:<#(nonnull NSURLRequest *)#> fromData:<#(nullable NSData *)#> progress:<#^(NSProgress * _Nonnull uploadProgress)uploadProgressBlock#> completionHandler:<#^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)completionHandler#>]
//    [manager uploadTaskWithStreamedRequest:<#(nonnull NSURLRequest *)#> progress:<#^(NSProgress * _Nonnull uploadProgress)uploadProgressBlock#> completionHandler:<#^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error)completionHandler#>]
    
    // 设置请求的优先级
    [weakSelf ls_configRequestPriority:sessionTask];
    
    //开始启动任务
    [sessionTask resume];
    //将任务添加到数组
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

#pragma mark + 下载
+ (__kindof LSURLSessionTask *)downloadWithUrlStr:(NSString *)urlStr
                                       saveToPath:(NSString *)saveToPath
                                         progress:(void (^)(int64_t, int64_t))progressBlock
                                          success:(void (^)(id))success
                                          failure:(void (^)(NSError *))failure {
    
     __weak __typeof(self)weakSelf = self;
    
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:0.6];
    
    //下载地址
    NSURL *downloadURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self createPublicBasicSettingsWithurlString:urlStr]]];
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [self ls_manager];
    //创建请求对象
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:downloadURL];
    //创建任务开始请求
    LSURLSessionTask *sessionTask = [manager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        //回到主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
        //如果调用了block
        if (progressBlock) {
            progressBlock(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        // targetPath:默认下载地址,下载完成后,储存的临时文件会被清除
        
        //设置下载路径
        NSString *filePath = saveToPath;
        //如果路径不是NSString类型 或者 路径长度是0 或者路径是空
        if (![saveToPath isKindOfClass:[NSString class]] || saveToPath.length == 0 || saveToPath == nil) {
            //设置下载路径,将下载文件保存在缓存路径中 通过沙盒获取缓存地址
            //拼接缓存目录
            filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"LSDownload"];
        } else {
            //拼接缓存目录
            filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:saveToPath];
        }
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        filePath = [filePath stringByAppendingPathComponent:response.suggestedFilename];
        // 返回文件位置的URL路径
        return [NSURL URLWithString:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {//服务器反馈:Response，已下载的文件位置:filePath 和错误信息 error。
        
        //手动关闭MBProgressHUD
        [MBProgressHUD hideAllHuds];
        
        //从数组中移除任务
        [[self allTasks] removeObject:sessionTask];
        
        //如果没有错误 返回
        if (error == nil) {
            //如果调用了block
            if (success) {
                //返回 路径
                success(filePath.absoluteString);
            }
        //有错误
        } else {
            // 数据请求失败 返回错误
            [self handleCallbackWithError:error fail:failure hideHud:hud];
        }
    }];
    
    // 设置请求的优先级
    [weakSelf ls_configRequestPriority:sessionTask];
    
    //开始下载
    [sessionTask resume];
    
    //将任务添加到数组
    if (sessionTask) {
        [[self allTasks] addObject:sessionTask];
    }
    
    return sessionTask;
}

///返回当前系统时间戳
+ (NSString *)returnsTheCurrentSystemTimeStamp {
    //文件上传时，文件不允许被覆盖，不允许重名
    // 可以在上传时使用当前系统时间作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    //获取当前时间
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    return str;
}

//隐藏hud  移除hud
+ (void)hiddenHud:(MBProgressHUD *)hud {
    if (hud != nil) {
//        hud.taskInProgress = NO;
        hud.removeFromSuperViewOnHide = YES;
//        [hud hide:YES];
        [hud hideAnimated:YES];
        [hud removeFromSuperview];
    }
}

#pragma mark - params --->string 把参数转变成字符串
- (NSString *)returnStringFromParams:(NSDictionary *)params {
    // 转变可变数组
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *key in params) {// 遍历参数字典 取出value  并加入数组
        // 取出当前参数
        NSString *currentString = [NSString stringWithFormat:@"%@=%@", key, params[key]];
        [array addObject:currentString];
    }
    // 🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥
    //将array数组转换为string字符串
    NSString *resultString = [array componentsJoinedByString:@"&"];
    NSLog(@"参数：%@", resultString);
    return resultString;
}

///根据错误代码显示提示信息
+ (void)showFailMarkedWordsWithError:(NSError *)error {
    
    //    NSLog(@"error = %@",error);
    //    NSLog(@"error.code = %d", error.code);//错误代码
    //    NSLog(@"error.description = %@", error.description);
    //    NSLog(@"error.localizedDescription = %@", error.localizedDescription); //错误信息
    //    NSLog(@"error.userInfo = %@", error.userInfo);
//    NSLog(@"error.userInfo[NSLocalizedFailureReasonErrorKey] = %@", error.userInfo[NSLocalizedFailureReasonErrorKey]);
    //    NSLog(@"error.domain = %@", error.domain);
    //    NSLog(@"error.localizedFailureReason = %@", error.localizedFailureReason);
    //    NSLog(@"error.localizedRecoverySuggestion = %@", error.localizedRecoverySuggestion);
    //    NSLog(@"error.localizedRecoveryOptions = %@", error.localizedRecoveryOptions);
    //    NSLog(@"error.recoveryAttempter = %@", error.recoveryAttempter);
    //    NSLog(@"error.helpAnchor = %@", error.helpAnchor);
    
    switch (error.code) {
        case -200:
        case -1016:
            [MBProgressHUD qucickTip:@"不支持的解析格式,请添加数据解析类型"];
            break;
        case -400:
            [MBProgressHUD qucickTip:@"参数传递错误"];
            break;
        case -401:
            [MBProgressHUD qucickTip:@"访问的页面没有授权"];
            break;
        case -404:
            [MBProgressHUD qucickTip:@"服务器错误"];
            break;
        case -405:
            //接口调用的方式或者参数不对
            [MBProgressHUD qucickTip:@"方法不被允许"];
            break;
        case -500:
            [MBProgressHUD qucickTip:@"服务器错误,服务暂不可用"];
            break;
        case -999:
            [MBProgressHUD qucickTip:@"取消请求"];
            break;
        case -1001:
            [MBProgressHUD qucickTip:@"请求超时"];
//            您当前网络状态不好,请检查您的网络连接
            break;
        case -1002:
            [MBProgressHUD qucickTip:@"URL地址需要utf-8编码"];
            break;
        case -1004:
            [MBProgressHUD qucickTip:@"无法连接到服务器"];
            break;
        case -1009:
            [MBProgressHUD qucickTip:@"已断开与互联网的连接"];
            break;
        case -1011:
            [MBProgressHUD qucickTip:@"请求头格式错误"];
            break;
        case -3840:
            [MBProgressHUD qucickTip:@"JSON数据格式错误"];
            break;
        default:
            [MBProgressHUD qucickTip:[NSString stringWithFormat:@"%ld数据请求错误", (long)error.code]];
            break;
    }
}

#pragma makr + 开始监听程序在运行中的网络连接变化
///检测网络
+ (void)startMonitoring {
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
   
     // 2.设置网络状态改变后的处理
    [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        // 当网络状态改变了, 就会调用这个block
        
        if (status == AFNetworkReachabilityStatusNotReachable){ // 没有网络(断网)
            ls_networkStatus = LSNetworkStatusNotReachable;
        }else if (status == AFNetworkReachabilityStatusUnknown){  // 未知网络
            ls_networkStatus = LSNetworkStatusUnknow;
        }else if (status == AFNetworkReachabilityStatusReachableViaWWAN){// 手机自带网络
            ls_networkStatus = LSNetworkStatusReachableViaWWAN;
        }else if (status == AFNetworkReachabilityStatusReachableViaWiFi){// WIFI
            ls_networkStatus = LSNetworkStatusReachableViaWiFi;
        }
    }];
    
     [reachabilityManager startMonitoring];
}

// 获取网络状态
+ (LSNetworkStatus)checkNetStatus {
    [self startMonitoring];
    
    if ([LSNetworking sharedLSNetworking].ls_networkStats == LSNetworkStatusReachableViaWiFi) {
        return LSNetworkStatusReachableViaWiFi;
    } else if ([LSNetworking sharedLSNetworking].ls_networkStats == AFNetworkReachabilityStatusNotReachable) {
        return LSNetworkStatusNotReachable;
    } else if ([LSNetworking sharedLSNetworking].ls_networkStats == AFNetworkReachabilityStatusReachableViaWWAN) {
        return LSNetworkStatusReachableViaWWAN;
    } else {
        return LSNetworkStatusUnknow;
    }
}

/// 把block置nil来打破循环引用
- (void)ls_clearCompletionBlock {
    self.ls_successCompletionBlock = nil;
    self.ls_failureCompletionBlock = nil;
    self.ls_progressBlock = nil;
}

- (void)dealloc {
     [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    
    //移除通知
    NSLog(@"控制器被dealloc: %@", [[self class] description]);
    NSLog(@"%s", __func__);

//NSURLSession对象的释放
    //在最后的时候应该把session释放，以免造成内存泄露
    // NSURLSession设置过代理后，需要在最后（比如控制器销毁的时候）调用session的invalidateAndCancel或者resetWithCompletionHandler，才不会有内存泄露
    // [self.session invalidateAndCancel];
//    [self.session resetWithCompletionHandler:^{
//        
//        NSLog(@"释放+++");
//    }];
}
@end
