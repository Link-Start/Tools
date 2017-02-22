//
//  NetworkRequest.m
//  LALA
//
//  Created by Xcode on 16/5/27.
//  Copyright © 2016年 Link+Start. All rights reserved.
//



/**
 要使用常规的AFN网络访问
 
 1. AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
 
 所有的网络请求,均有manager发起
 
 2. 需要注意的是,默认提交请求的数据是二进制的,返回格式是JSON
 
 1> 如果提交数据是JSON的,需要将请求格式设置为AFJSONRequestSerializer
 2> 如果返回格式不是JSON的,
 
 3. 请求格式
 
 AFHTTPRequestSerializer            二进制格式
 AFJSONRequestSerializer            JSON
 AFPropertyListRequestSerializer    PList(是一种特殊的XML,解析起来相对容易)
 
 4. 返回格式
 
 AFHTTPResponseSerializer           二进制格式
 AFJSONResponseSerializer           JSON
 AFXMLParserResponseSerializer      XML,只能返回XMLParser,还需要自己通过代理方法解析
 AFXMLDocumentResponseSerializer (Mac OS X)
 AFPropertyListResponseSerializer   PList
 AFImageResponseSerializer          Image
 AFCompoundResponseSerializer       组合
 */

#import "NetworkRequest.h"

@implementation NetworkRequest

#pragma mark - GET请求
//GET请求
+ (void)GETDataByUrl:(NSString*)url withParameters:(NSDictionary*)parameters completed:(void(^)(id json))finish failure:(void(^)( NSError *error))failure {
    
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    
        //显示加载中
//        [MBProgressHUD showMessage:@""];

    
    ////1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 30.f;
    
    NSURLSessionTask *sessionTask = nil;
    //开始请求
    sessionTask = [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        
        ////这种可以打印中文
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // 请求成功，解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        

        // 请求失败
        NSLog(@"请求失败:%@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
 
    }];
}

#pragma mark - POST请求
//请求数据
+ (void)POSTDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters completed:(void(^)(id json))finish failure:(void(^)(NSError *))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    
    //如果hud 隐藏了
    if ([MBProgressHUD shareHud].hidden) {
        //显示加载中
        [MBProgressHUD showMessage:@""];
    }
    
    ////1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果,不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 10.f;
    //开始请求
    /*
     第一个参数：请求路径：NSString类型
     第二个参数：要上传的非文件参数
     第三个参数：block回调
     在该回调中，需要利用formData拼接即将上传的二进制数据
     第三个参数：上传成功的block回调
                      task：dataTask(任务)
                      responseObject:服务器返回的数据
     第四个参数：上传失败的block回调
               error：错误信息，如果上传文件失败，那么error里面包含了错误的描述信息
     */
     [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动关闭MBProgressHUD(必须写在这个位置，不然不会关闭)
        [MBProgressHUD hideHUD];
        // 请求成功，解析数据
        [self tryToParseData:responseObject];
        //显示成功
        //        [MBProgressHUD showSuccess:@"数据请求成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        // 请求失败
        NSLog(@"请求失败:%@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
        
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        
    }];
}

#pragma mark - AFN3.0上传方法
#pragma mark - 使用NSData数据流传图片
/**
 *  上传头像的方法(上传单个图片) 使用NSData数据流传图片 (以文件流的格式)
 *
 *  @param images   要上传的头像 image（直接给图片，转换方法在里面）
 *  @param url      url地址
 *  @param imageKey 要上传的头像image 对应的key值字符串
 *  @param param    参数（除了image之外的参数）
 *  @param finish   成功
 *  @param failure  失败
 */
+ (void)uploadImage:(UIImage *)image toURL:(NSString *)urlString imageKey:(NSString *)imageKey parameters:(NSDictionary *)parameters completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
//    [MBProgressHUD showMessage:@""];
    
    //要保存在服务器上的[文件名]
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 10.f;
    //2.上传文件
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        //上传文件参数
        NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
        /*
         此方法参数
         1. 要上传的[二进制数据]
         2. 对应网站上[upload.php中]处理文件的[字段"file"] ++ 参数对应的key值
         3. 要保存在服务器上的[文件名]
         4. 上传文件的类型 [mimeType]
         */
        //服务器上传文件的字段和类型 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:imageKey fileName:fileName mimeType:@"image/png/file/jpg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印 上传进度
        NSLog(@"上传进度：%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        
        NSLog(@"%@", responseObject);
        
        //请求成功
        //NSLog(@"请求成功：%@",responseObject);
        
       //解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
        
        
        //显示成功
        //[MBProgressHUD showSuccess:@"成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败：%@",error);
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        

        if (failure) {
            failure(error);
        }
        
    }];
}

/**
 *  上传头像的方法(可以上传多个图片) 使用NSData数据流传图片 (以文件流的格式)
 *
 *  @param images   装有 要上传的头像 image 的数组
 *  @param url      服务器网址
 *  @param param    参数（除了image之外的参数）
 *  @param finish   成功
 *  @param failure  失败
 */
+ (void)uploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
//    [MBProgressHUD showMessage:@""];
    //要保存在服务器上的[文件名]
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //2.上传文件
    
    for (UIImage *image in images) {
        
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        //上传文件参数
        
            //在实际使用过程中,比较发现: UIImagePNGRepresentation(UIImage* image) 要比UIImageJPEGRepresentation(UIImage* image, 1.0) 返回的图片数据量大很多.
            //UIImageJPEGRepresentation函数需要两个参数:图片的引用和压缩系数
            //如果对图片的清晰度要求不高,还可以通过设置 UIImageJPEGRepresentation函数的第二个参数,大幅度降低图片数据量.
            //因此,在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小.
            NSData *imageData = UIImageJPEGRepresentation(image, 0.1);
            /*
             此方法参数
             1. FileData:  要上传的[二进制数据] +++ image转换成的data数据
             2. name:      对应网站上[upload.php中]处理文件的[字段"file"] +++ 参数image 对应的key值
             3. fileName:  要保存在服务器上的[文件名] ++++ 可以随便写
             4. mimeType:  上传文件的类型[mimeType] +++
             */
            //服务器上传文件的字段和类型 上传图片，以文件流的格式
//            [formData appendPartWithFileData:imageData name:imageKey fileName:fileName mimeType:@"image/png/file/jpg"];
        
        [formData appendPartWithFormData:imageData name:fileName];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印 上传进度
        NSLog(@"上传进度：%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        
        NSLog(@"dddddddddddddddddttttt%@", responseObject);
        
        //解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];

        //请求失败
        NSLog(@"失败：%@",error);
        if (failure) {
            failure(error);
        }
        
    }];
        }
}

#pragma mark - 第二种 通过URL来获取路径，进入沙盒或者系统相册等等
/**
 *  上传语音的方法(可以上传多个语音) 使用 地址 上传语音
 *
 *  @param audioArray    装有 要上传的语音audio路径的数组
 *  @param url           服务器网址
 *  @param parameters    参数（除了audio之外的参数）
 *  @param audioKey      对应网站上处理文件的[字段"file"]
 *  @param finish        成功
 *  @param failure       失败
 */
+ (void)uploadAudio:(NSArray *)audioArray toURL:(NSString *)urlString parameters:(NSDictionary*)parameters audioKey:(NSString *)audioKey completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    [MBProgressHUD showMessage:@""];
    
    /// 要保存在服务器上的[文件名] -- 以当时的时间为文件名
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //2.上传文件
    for (NSString *filePath in audioArray) {
        
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        ///上传文件参数
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        
            
            /**
             *  appendPartWithFileURL   //  指定上传的文件
             *  name                    //  指定在服务器中获取对应文件或文本时的key
             *  fileName                //  指定上传文件的原始文件名
             *  mimeType                //  指定商家文件的MIME类型
             */
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:audioKey fileName:fileName mimeType:@"application/octet+stream" error:nil];
       
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印下上传进度
        NSLog(@"%lf",1.0 *uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSLog(@"请求成功：%@",responseObject);
        //隐藏提示
        [MBProgressHUD hideHUD];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败：%@",error.domain);
        //隐藏提示
        [MBProgressHUD hideHUD];
        
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        
        //如果调用了failure
        if (failure) {
            failure(error);
        }
     }];
         }
}

///返回时间戳
+ (NSString *)returnWithATimeStampAsFileName {
    //文件上传时，文件不允许被覆盖，不允许重名
    // 可以在上传时使用当前系统时间作为文件名
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    //获取当前时间
    NSString *str = [formatter stringFromDate:[NSDate date]];
    
    return str;
}

/**
 *  解析数据
 *
 *  @param responseData 服务器返回的数据
 *
 *  @return 解析后的数据
 */
+ (id)tryToParseData:(id)responseData {
    
    //如果是NSData 类型
    if ([responseData isKindOfClass:[NSData class]]) {
        // 尝试解析成JSON
        //如果数据是空
        if (responseData == nil) {
            return responseData;
            
        } else {
            NSError *error = nil;
            //使用缓冲区数据来解析 解析json数据
            //NSJSONReadingMutableContainers：返回可变容器,NSMutableDictionary或NSMutableArray
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
            
            //如果有错误 直接返回原数据,如果没有错误 返回解析后的数据
//            return (error ? responseData : response);
            
            ////如果 有错误
            if (error != nil) {
                //直接返回 原数据
                return responseData;
            } else {
                //如果没有错误 返回解析后的数据
                return response;
            }
        }
        //如果不是NSData类型
    } else {
        //返回原数据
        return responseData;
    }
}

///根据错误代码显示提示信息
+ (void)showFailMarkedWordsWithError:(NSError *)error {
    switch (error.code) {
        case -404:
            [MBProgressHUD qucickTip:@"服务器错误"];
            break;
        case -999:
            [MBProgressHUD qucickTip:@"取消请求"];
            break;
        case -1001:
            [MBProgressHUD qucickTip:@"请求超时"];
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
        default:
            [MBProgressHUD qucickTip:[NSString stringWithFormat:@"%ld数据请求错误", (long)error.code]];
            break;
    }
}


#pragma mark - 监测当前网络状态（网络监听）
#pragma mark - 检查网络连接
/**
 *  检查当前网络连接 有网络:yes  无网络:no
 */
+ (void)currentNetworkStatus {
    
    //需要在didFinishLaunchingWithOptions中开启网络监听 [GLobalRealReachability startNotifier];
    
    //这里使用 static BOOL canCheckNetwork  = NO; 在block里面获取不了状态
    
    //触发实时网络状态查询代
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status) {
            case RealStatusUnknown: {
                NSLog(@"监测当前网络状态：未知网络状态");
                
                break;
            }
            case RealStatusNotReachable: {
                NSLog(@"监测当前网络状态：网络连接已断开，请检查您的网络");
               
                break;
            }
            case RealStatusViaWWAN: {
                NSLog(@"监测当前网络状态：蜂窝数据网");
                {
                    //查询当前实际网络连接类型
                    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
                    switch (accessType) {
                        case WWANTypeUnknown: {
                            NSLog(@"监测当前网络状态：未知网络状态,可能是iOS6");
                            break;
                        }
                        case WWANType4G: {
                            NSLog(@"监测当前网络状态：4G网络");
                            break;
                        }
                        case WWANType3G: {
                            NSLog(@"监测当前网络状态：3G网络");
                            break;
                        }
                        case WWANType2G: {
                            NSLog(@"监测当前网络状态：2G网络");
                            break;
                        }
                        default:
                            break;
                    }
                }
                
                break;
            }
            case RealStatusViaWiFi: {
                NSLog(@"监测当前网络状态：WiFi网络");
                
                break;
            }
            default:
                break;
        }
    }];
   
}

/**
 *  当前网络是否活跃
 *
 *  @return  YES:活跃  NO:不活跃
 */
+ (BOOL)activeNetwork {
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusViaWiFi || status == RealStatusViaWWAN ||  status == RealStatusUnknown) {
        return YES;
    }
    [MBProgressHUD qucickTip:@"没有网络!"];
    return NO;
}

#pragma mark - AFNetworking 检测网络状态
/**
 *  检查网络连接  //这个可以测出网络状态
 */
- (BOOL)AFNetworkStatus {
    //是否正在检查网络
    __block BOOL canCheckNetwork  = NO;
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    //网络只有在startMonitoring完成后才可以使用检查网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        canCheckNetwork = YES;
    }];
    
    //只能在监听完善之后才可以调用
    //有网络
    BOOL isOK = [[AFNetworkReachabilityManager sharedManager] isReachable];
    //网络有问题
    if(isOK == NO && canCheckNetwork == YES){
        //NSError *error = [NSError errorWithDomain:@"网络错位" code:100 userInfo:nil];
        NSLog(@"没有网络");
        //提示没有网络
        [MBProgressHUD qucickTip:@"没有网络"];
        return NO;
    }
    return YES;
}


@end
