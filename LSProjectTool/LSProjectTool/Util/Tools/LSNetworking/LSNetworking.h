//
//  LSNetworking.h
//  Tedddd
//
//  Created by Xcode on 16/7/4.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
//AFN 3.0版本现在正式支持的iOS 7， Mac OS X的10.9， watchOS 2 ， tvOS 9 和Xcode 7
//从AFNetworking 3.0后UIAlertView的类目因过时而被废弃

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

//NSUInteger是无符号的，即没有负数,NSInteger是有符号的
///网络状态(NSUInteger是无符号的，即没有负数,NSInteger是有符号的)
typedef NS_ENUM(NSInteger, LSNetworkStatus) {
    /// 未知网络
    LSNetworkStatusUnknow             = -1,    // 未知网络
    /// 网络无法链接
    LSNetworkStatusNotReachable       = 0,      // 网络无法链接
    /// 2，3，4G网络
    LSNetworkStatusReachableViaWWAN   = 1,       // 2，3，4G网络
    /// WIFI网络
    LSNetworkStatusReachableViaWiFi   = 2       // WIFI网络
};

///网络请求状态
typedef NS_ENUM(NSUInteger, LSServerRequestsStatus) {
    /// 请求失败
    LSServerRequestsStatusFail              = 0,        // 请求失败
    /// 请求成功
    LSServerRequestsStatusSuccess           = 1,        // 请求成功
    /// 无法连接
    LSServerRequestsStatusNotConnected      = 2,        // 无法连接
    /// 请求超时
    LSServerRequestsStatusconnectedTimeOut  = 3         // 请求超时
};
/*
 GET 从服务器获取一段内容（用HTTP术语来说，就是实体entity),不会导致服务器端的数据发生变化,GET请求通常不包括请求体,不过也可以包含
 
 POST 使用客户端提供的数据更新实体.POST请求通常会在请求体中加入应用服务器,  POST请求是非幂等(待查)的.这意味着如果处理多个请求，那么结果与处理单个请求是不同的
 
 HEAD 获取响应的元数据而无需检索响应的全部内容。该方法通常用于检查服务器最近的内容变化而无须检索全部内容
 
 PUT  使用客户端提供的数据添加实体。PUT请求通常将应用服务器所需的信息放在请求体中来创建新的实体.在通常情况下，PUT请求是幂等的，这意味着多个请求的处理会产生相同的结果
 
 DELETE  删除 根据URI的内容或客户端提供的请求体来删除实体。DELETE请求是REST服务接口中使用最为频繁的请求

 ///
PUT和POST极为相似，都是向服务器发送数据，但它们之间有一个重要区别，PUT通常指定了资源的存放位置，而POST则没有，POST的数据存放位置由服务器自己决定
 
 */
///请求方式
typedef NS_ENUM(NSUInteger, LSRequestMethod) {
///GET
    LSRequestMethodGet      = 0,       //GET
///POST
    LSRequestMethodPost     = 1,       //POST
///HEAD
    LSRequestMethodHead     = 2,       //HEAD
///PUT
    LSRequestMethodPut      = 3,       //PUT
///DELETE
    LSRequestMethodDelete   = 4,       //DELETE
///PATCH
    LSRequestMethodPatch    = 5        //PATCH
};

///请求优先级
typedef NS_ENUM(NSInteger, LSRequestPriority) {
    ///低
    LSRequestPriorityLow     = -4L,
    ///默认
    LSRequestPriorityDefault = 0,
    ///高
    LSRequestPriorityHigh    = 4,
};

///请求类型 请求格式
typedef NS_ENUM(NSUInteger, LSRequestType) {
    /// 默认JSON
    LSRequestTypeJSON         = 1,          //JSON
    /// 普通text/html
    LSRequestTypeHTTP         = 2,          //二进制格式
    ///plist(是一种特殊的XML,解析起来相对容易)
    LSRequestTypePropertyList = 3,           //plist
    
    LSRequestTypePlainText    = 4            // 普通text/html
};

///返回类型 返回格式
typedef NS_ENUM(NSUInteger, LSResponseType) {
    /// 默认JSON
    LSResponseTypeJSON         = 1,                      //JSON
    /// 二进制格式
    LSResponseTypeHTTP         = 2,                      //二进制格式
    /// XML,只能返回XMLParser,还需要自己通过代理方法解析
    LSResponseTypeXML          = 3,                      //XML
    /// plist
    LSResponseTypePropertyList = 4,                       //plist
 };



@class NSURLSessionTask;

#pragma mark - block
// 请勿直接使用NSURLSessionDataTask,以减少对第三方的依赖
// 所有接口返回的类型都是基类NSURLSessionTask，若要接收返回值
// 且处理，请转换成对应的子类类型
typedef NSURLSessionTask LSURLSessionTask;

/**************************************************************************************************************/
/******************************************      block     ****************************************************/
/**************************************************************************************************************/
////int64_t 是长度固定为64比特的有符号整型类型
//int_fast64_t指得是字长至少为64比特的快速有符号整型类型，
//int_fast64_t可以保证任何平台上的编译器总是选择字长不少于64比特的最快整型类型。
//typedef void(^LSLoadProgress)(int_fast64_t bytesRead, int_fast64_t totalBytesRead);
///成功
typedef void(^LSRequestSuccessCompletionBlock)(id response);
///失败
typedef void(^LSRequestFailureCompletionBlock)(NSError *error);
///进度
typedef void(^LSLoadProgressBlock)(NSProgress *);


///网络请求工具(对AFNetworking的封装)
/*!
 *  @author
 *
 *  基于AFNetworking的网络层封装类.
 *
 *  @note 这里只提供公共api
 */
@interface LSNetworking : NSObject
/// 网络状态
@property (nonatomic, assign) LSNetworkStatus ls_networkStats;
/// 请求的优先级 优先级高的请求会从请求队列中优先 出列
@property (nonatomic, assign) LSRequestPriority ls_requestPriority;
///
@property (nonatomic, readonly, getter=isCancelled) BOOL ls_cancelled;
///请求成功 block
@property (nonatomic, copy) LSRequestSuccessCompletionBlock ls_successCompletionBlock;
///请求失败 block
@property (nonatomic, copy) LSRequestFailureCompletionBlock ls_failureCompletionBlock;
///请求进度 block
@property (nonatomic, copy) LSLoadProgressBlock ls_progressBlock;
/// 请求的连接超时时间，默认为30秒
@property (nonatomic, assign) NSTimeInterval ls_requestTimeoutInterval;


/// 把block置nil来打破循环引用
- (void)ls_clearCompletionBlock;
/**
 *  单例
 */
+ (instancetype)sharedLSNetworking;

/**************************************************************************************************************/
/******************************************     网络状态    ****************************************************/
/**************************************************************************************************************/
#pragma mark -  检测当前网络
/**
 *  @berif 开启网络监测
 */
+ (void)startMonitoring;
/**
 *  获取网络状态
 */
+ (LSNetworkStatus)checkNetStatus;
///判断是否有网络 YES:有网络 NO:没有网络
- (BOOL)currentNetworkState;
/**
 *  检测当前网络是否可用  * 
 *  @return  Yes:有网络  NO:没有网络 
 */
+ (BOOL)activeNetwork;

/**************************************************************************************************************/
/****************************   重置AFHTTPSessionManager相关属性  ***********************************************/
/**************************************************************************************************************/
/**
 *  用于指定网络请求接口的基础url
 *  更新请求接口基础url(如果服务器地址有多个，可以调用更新)
 *  通常放在appdelegate就可以了
 *  @param baseUrl (网络)请求接口基础url
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;
///网络请求接口基础url
+ (NSString *)baseUrl;

/**
 *  设置请求超时时间,默认为30秒
 *
 *  @param timeout 超时时间
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)timeout DEPRECATED_MSG_ATTRIBUTE("使用属性 requestTimeoutInterval");

/**
 *  配置公共的请求头，用于区分请求来源,需要与服务器约定好,只调用一次即可，通常放在应用启动的时候配置就可以了
 *
 *  @param httpHeaders 只需要将与服务器商定的固定参数设置即可,如@{"client" : "iOS"}
 */
+ (void)configCommonHttpHeaders:(NSDictionary *)httpHeaders;

/*!
 *  @author
 *
 *  配置请求格式，默认为JSON。如果要求传XML或者PLIST，请在全局配置一下
 *
 *  @param requestType                       请求格式，默认为JSON
 *  @param responseType                      响应格式，默认为JSON，
 *  @param shouldAutoEncode                  YES/NO,默认为NO，是否自动编码 url
 *  @param shouldCallbackOnCancelRequest     当取消请求时，是否要回调，默认为YES
 */
+ (void)configRequestType:(LSRequestType)requestType
             responseType:(LSResponseType)responseType
      shouldAutoEncodeUrl:(BOOL)shouldAutoEncode
  callbackOnCancelRequest:(BOOL)shouldCallbackOnCancelRequest;

/**
 *	当检查到网络异常时，是否从从本地提取数据。默认为NO。一旦设置为YES,当设置刷新缓存时，
 *  若网络异常也会从缓存中读取数据。同样，如果设置超时不回调，同样也会在网络异常时回调，除非
 *  本地没有数据！
 *
 *	@param shouldObtain	YES/NO 是否获取
 */
+ (void)obtainDataFromLocalWhenNetworkUnconnected:(BOOL)shouldObtain;

/**
 *  是否打开网络状态转圈菊花:默认打开
 *
 *  @param open YES(打开), NO(关闭)
 */
+ (void)openNetworkActivityIndicator:(BOOL)open;

/***************************  缓存  **********************************/
/**
 *	@author
 *
 *	默认不缓存GET请求的数据，对于POST请求也是不缓存的。如果要缓存GET、POST获取的数据，需要手动调用设置
 *  对JSON类型数据有效，对于PLIST、XML不确定！
 *
 *	@param isCacheGet       缓存GET请求的数据,默认为YES
 *	@param shouldCachePost	缓存POST请求的数据,默认为NO
 */
+ (void)cacheGetRequest:(BOOL)isCacheGet shoulCachePost:(BOOL)shouldCachePost;

/**
 *	@author
 *
 *	获取缓存总大小/bytes
 *
 *	@return 缓存大小
 */
+ (unsigned long long)totalCacheSize;

/**
 *	@author
 *
 *	清除缓存
 */
+ (void)clearCaches;

/***************************  取消请求  **********************************/
/**
 *	@author
 *
 *	取消所有请求
 */
+ (void)cancelAllRequest;

/**
 *	@author
 *
 *	取消某个请求。如果是要取消某个请求，最好是引用接口所返回来的LSURLSessionTask对象，
 *  然后调用对象的cancel方法。如果不想引用对象，这里额外提供了一种方法来实现取消某个请求
 *
 *	@param url	URL，可以是绝对URL，也可以是path（也就是不包括baseurl）
 */
+ (void)cancelRequestWithURL:(NSString *)url;


/**************************************************************************************************************/
/******************************************   网络请求方法   ****************************************************/
/**************************************************************************************************************/
#pragma mark - 数据请求
#pragma mark - GET请求
///基础GET请求
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                                success:(void (^)(id response))success
                                   fail:(void (^)(NSError *error))fail;
///多了一个Parameters参数
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                             Parameters:(NSDictionary *)parameters
                                success:(void (^)(id response))success
                                failure:(void (^)(NSError *error))failure;
//int64_t 是长度固定为64比特的有符号整型类型
//int_fast64_t指得是字长至少为64比特的快速有符号整型类型，
//int_fast64_t可以保证任何平台上的编译器总是选择字长不少于64比特的最快整型类型。
//typedef void(^LSLoadProgress)(int_fast64_t bytesRead, int_fast64_t totalBytesRead);
///多一个progress 进度回调 bytesRead:已下载的大小,totalBytesRead:文件总大小
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                             Parameters:(NSDictionary *)Parameters
                               progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                success:(void (^)(id response))success
                                   fail:(void (^)(NSError *error))fail;
///可以设置多久之后显示提示语
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                             Parameters:(NSDictionary *)Parameters
                              graceTime:(CGFloat)graceTime
                               progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                success:(void (^)(id response))success
                                   fail:(void (^)(NSError *error))fail;
/**
 *  可以设置显示的提示语内容
 *
 *  GET请求,若不指定baseurl，可传完整的url
 *
 *  @param url              接口路径，
 *  @param refreshCache     是否刷新缓存。由于请求成功也可能没有数据，对于业务失败，只能通过人为手动判断
 *  @param parameters       接口中所需要的拼接参数，
 *  @param graceTime        几秒之后显示提示语
 *  @param markedWords      提示语内容
 *  @param success          接口成功请求到数据的回调
 *  @param failure          接口请求数据失败的回调
 *
 *  @return       返回的对象中有可取消请求的API
 */
+ (__kindof LSURLSessionTask *)getDataWithUrlStr:(NSString *)urlStr
                           refreshCache:(BOOL)refreshCache
                             Parameters:(NSDictionary *)Parameters
                              graceTime:(CGFloat)graceTime
                            markedWords:(NSString *)markedWords
                               progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                success:(void (^)(id response))success
                                   fail:(void (^)(NSError *error))fail;



#pragma mark - POST请求
///基础
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr
                          refreshCache:(BOOL)refreshCache
                            parameters:(NSDictionary *)parameters
                               success:(void (^)(id response))success
                               failure:(void (^)(NSError *error))failure ;
///多一个progress进度条 bytesRead:已下载的大小,totalBytesRead:文件总大小
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr
                            refreshCache:(BOOL)refreshCache
                              parameters:(NSDictionary *)parameters
                                progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                 success:(void (^)(id response))success
                                    fail:(void (^)(NSError *error))fail;
///可以设置多久之后显示提示语
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr
                            refreshCache:(BOOL)refreshCache
                              parameters:(NSDictionary *)parameters
                               graceTime:(CGFloat)graceTime
                                progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                 success:(void (^)(id response))success
                                    fail:(void (^)(NSError *error))fail;
/**
 *  可以设置显示的提示语内容
 *
 *  POST请求接口，若不指定baseurl，可传完整的url
 *
 *  @param url           接口路径
 *  @param refreshCache  是否刷新缓存
 *  @param Parameters    接口中所需的参数
 *  @param graceTime     几秒之后显示提示语
 *  @param markedWords   提示语内容
 *  @param success       接口成功请求到数据的回调
 *  @param failure       接口请求数据失败的回调
 *
 *  @return   返回的对象中有可取消请求的API
 */
+ (__kindof LSURLSessionTask *)postDataWithUrlStr:(NSString *)urlStr
                            refreshCache:(BOOL)refreshCache
                              parameters:(NSDictionary *)parameters
                               graceTime:(CGFloat)graceTime
                             markedWords:(NSString *)markedWords
                                progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progress
                                 success:(void (^)(id response))success
                                    fail:(void (^)(NSError *error))fail;

#pragma mark - 上传
#pragma mark - 上传头像的方法(上传单个图片) 使用NSData数据流传图片
/**
 *	上传图片的方法(上传单个图片) 使用NSData数据流传图片
 *	图片上传接口，若不指定baseurl，可传完整的url
 *
 *  @berif               上传图片少或者数量多都没关系,速度也很快
 *	@param image		 图片对象,要上传的图片image（直接给图片，转换方法在里面）
 *	@param urlStr		 上传图片的接口路径
 *	@param imageKey		 要上传的头像image 对应的key值字符串,与指定的图片相关联的名称，这是由后端写接口的人指定的
 *	@param parameters	 参数（除了image之外的参数）
 *	@param progress		 上传进度 bytesWritten:已上传大小,otalBytesWritten:总上传大小
 *	@param success		 上传成功的回调
 *	@param fail			 上传失败的回调
 *
 *	@return
 */
+ (__kindof LSURLSessionTask *)uploadWithImage:(UIImage *)image
                               urlStr:(NSString *)urlStr
                             imageKey:(NSString *)imageKey
                           parameters:(NSDictionary *)parameters
                             progress:(void (^)(int64_t bytesWritten, int64_t totalBytesWritten))progress
                              success:(void (^)(id response))success
                                  ail:(void (^)(NSError *error))fail;



#pragma mark - 上传头像的方法(可以上传多个图片) 使用NSData数据流传图片
/**
 *  @author Link-Start
 *
 *  @brief 上传头像的方法(可以上传多个图片) 使用NSData数据流传图片
 *  上传图片少或者数量多都没关系,速度也很快
 *
 *  @param images     装有 要上传的头像 image 的数组
 *  @param urlString  上传图片的接口路径
 *  @param parameters 参数（除了image之外的参数）
 *  @param imageKey   要上传的头像image 对应的key值字符串,与指定的图片相关联的名称，这是由后端写接口的人指定的
 *  @param success    上传成功的回调
 *  @param fail       上传失败的回调
 *  @return
 *  @since
 */
+ (__kindof LSURLSessionTask *)uploadWithImages:(NSArray<UIImage *> *)images
                          urlStr:(NSString *)urlString
                        parameters:(NSDictionary *)parameters
                          imageKey:(NSString *)imageKey
                           success:(void (^)(id response))success
                              fail:(void (^)(NSError *error))fail;

#pragma mark - 使用Base64字符串上传图片
/**
 *  适合上传图片数量比较少的，比如上传头像，上传图片数量多的话，速度会慢些
 */
+ (void)uploadImagesBase64:(UIImage *)image toURL:(NSString *)urlString parameters:(NSDictionary*)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure;
#pragma mark - 上传语音 通过文件路径
/**
 *  @author Link-Start
 *
 *  @brief 上传语音
 *
 *  @param audioPath  要上传的语音文件的路径
 *  @param urlStr     服务器网址
 *  @param parameters 参数
 *  @param audioKey   要上传的语音对应的key值字符串,与指定的语音相关联的名称，这是由后端写接口的人指定的
 *  @param success    上传成功的回调
 *  @param fail       上传失败的回调
 *  @return
 *  @since
 */
+ (__kindof LSURLSessionTask *)uploadWithAudioPath:(NSString *)audioPath
                                   urlStr:(NSString *)urlStr
                               parameters:(NSDictionary *)parameters
                                 audioKey:(NSString *)audioKey
                                  success:(void(^)(id responseData))success
                                     fail:(void(^)(NSError *error))fail;

#pragma mark - 上传文件
/**
 *  上传文件
 *
 *	@param urlStr			上传文件路径
 *	@param uploadingFile	待上传文件的路径
 *	@param progress			上传进度 bytesWritten:已上传大小,otalBytesWritten:总上传大小
 *	@param success			上传成功回调
 *	@param fail				上传失败回调
 *	@return                 NSURLSessionTask
 */
+ (__kindof LSURLSessionTask *)uploadFileWithUrlStr:(NSString *)urlStr
                             uploadingFile:(NSString *)uploadingFile
                                  progress:(void (^)(int64_t bytesWritten, int64_t totalBytesWritten))progress
                                   success:(void (^)(id response))success
                                      fail:(void (^)(NSError *error))fail;

#pragma mark - 下载
/*!
 *  下载文件
 *
 *  @param url              下载文件URL
 *  @param saveToPath       下载到哪个路径下
 *  @param progressBlock    下载进度 bytesRead:已下载的大小,totalBytesRead:文件总大小
 *  @param success          下载成功后的回调
 *  @param failure          下载失败后的回调
 */
+ (__kindof LSURLSessionTask *)downloadWithUrlStr:(NSString *)urlStr
                              saveToPath:(NSString *)saveToPath
                                progress:(void (^)(int64_t bytesRead, int64_t totalBytesRead))progressBlock
                                 success:(void (^)(id response))success
                                 failure:(void (^)(NSError *error))failure;



@end
