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
#define kTimeoutInterval 30.0f
@implementation NetworkRequest

#pragma mark - GET请求
+ (void)GETDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)( NSError *error))failure {
    [self GETDataByUrl:url withParameters:parameters graceTime:graceTime markedWords:@"加载中..." completed:finish failure:failure];
}
//GET请求
+ (void)GETDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime markedWords:(NSString *)markedWords completed:(void (^)(id))finish failure:(void (^)(NSError *))failure {
    
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    //显示提示语
    hud.labelText = markedWords;
    
    ////1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    //开始请求
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动关闭MBProgressHUD
        [self hiddenHud:hud];
        
        ////这种可以打印中文
        //NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // 请求成功，解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        //手动关闭MBProgressHUD
        [self hiddenHud:hud];
        // 请求失败
        NSLog(@"请求失败:%@", [error localizedDescription]);
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - POST请求
//请求数据
+ (void)POSTDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    
    MBProgressHUD *hud = [MBProgressHUD shareHud];
    //如果hud 隐藏了
    if (hud.hidden) {
        //显示加载中
        hud = [MBProgressHUD hud:graceTime];
    }
    
    ////1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果,不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
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
        [self hiddenHud:hud];
        
        // 请求成功，解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
        //显示成功
        //        [MBProgressHUD showSuccess:@"数据请求成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //手动关闭MBProgressHUD
        [self hiddenHud:hud];
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        // 请求失败
        NSLog(@"请求失败:%@", [error localizedDescription]);
        if (failure) {
            failure(error);
        }
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
+ (void)uploadImage:(UIImage *)image toURL:(NSString *)urlString imageKey:(NSString *)imageKey parameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    
    //要保存在服务器上的[文件名]
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
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
        [self hiddenHud:hud];
        //解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //请求失败
        NSLog(@"请求失败：%@",error);
        //手动关闭MBProgressHUD
        [self hiddenHud:hud];
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
+ (void)uploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    //要保存在服务器上的[文件名]
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    for (UIImage *image in images) {
        //2.上传文件
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
            [self hiddenHud:hud];
            // 请求成功，解析数据
            if (finish) {
                finish([self tryToParseData:responseObject]);
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //手动关闭MBProgressHUD
            [self hiddenHud:hud];
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

//有时也会不按照顺序上传
+ (void)async_uploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
//    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    //要保存在服务器上的[文件名]
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
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
                                                         nil];
    

    //创建信号量，参数：信号量的初值，如果小于0则会返回NULL
    dispatch_semaphore_t ls_semaphore_t = dispatch_semaphore_create(1);
    
    for (int i = 0; i < images.count; i++) {
        //等待降低信号量
        //只要信号量值不大于等于1，就会一直等待，知道>=1，再进行操作
        dispatch_semaphore_wait(ls_semaphore_t, DISPATCH_TIME_FOREVER);
            //2.上传文件
            [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
                //上传文件参数
                //在实际使用过程中,比较发现: UIImagePNGRepresentation(UIImage* image) 要比UIImageJPEGRepresentation(UIImage* image, 1.0) 返回的图片数据量大很多.
                //UIImageJPEGRepresentation函数需要两个参数:图片的引用和压缩系数
                //如果对图片的清晰度要求不高,还可以通过设置 UIImageJPEGRepresentation函数的第二个参数,大幅度降低图片数据量.
                //因此,在读取图片数据内容时,建议优先使用UIImageJPEGRepresentation,并可根据自己的实际使用场景,设置压缩系数,进一步降低图片数据量大小.
                NSData *imageData = UIImageJPEGRepresentation(images[i], 0.1);
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
                
                ////完操作完，让信号量计数+1，这样下次有线程要访问，就可以访问
                dispatch_semaphore_signal(ls_semaphore_t);
                
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                //打印 上传进度
                NSLog(@"上传进度%d：%lf",i, 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSLog(@"第%d张图片上传成功:%@", i + 1, responseObject);
                //手动关闭MBProgressHUD
//                [self hiddenHud:hud];
                // 请求成功，解析数据
                if (finish) {
                    finish([self tryToParseData:responseObject]);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //手动关闭MBProgressHUD
//                [self hiddenHud:hud];
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

//尽管异步请求的返回先后顺序没有一定，很可能后发出的请求先返回；但是最后回调的时候，请求返回的结果必须要按请求发出的顺序排列
+ (void)yuploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    
    // 准备保存结果的数组，元素个数与上传的图片个数相同，先用 NSNull 占位
    NSMutableArray *result = [NSMutableArray array];
    for (NSInteger i = 0; i < images.count; i++) {
        [result addObject:[NSNull null]];
    }
    
    dispatch_group_t group = dispatch_group_create();
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        dispatch_group_enter(group);
        
        //2.上传文件
        [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
            //上传文件参数
            //UIImageJPEGRepresentation(image, 1.0) 返回的图片数据较小.
            NSData *imageData = UIImageJPEGRepresentation(images[i], 0.1);
            //要保存在服务器上的[文件名]
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
            /*
             此方法参数
             1. FileData:  要上传的[二进制数据] +++ image转换成的data数据
             2. name:      对应网站上[upload.php中]处理文件的[字段"file"] +++ 参数image 对应的key值
             3. fileName:  要保存在服务器上的[文件名] ++++ 可以随便写
             4. mimeType:  上传文件的类型[mimeType] +++
             */
            //服务器上传文件的字段和类型 上传图片，以文件流的格式
            [formData appendPartWithFileData:imageData name:imageKey fileName:fileName mimeType:@"image/png/file/jpg"];
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            //打印 上传进度
            NSLog(@"上传进度：%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //手动关闭MBProgressHUD
            [self hiddenHud:hud];
            // 请求成功，解析数据
            if (finish) {
                finish([self tryToParseData:responseObject]);
            }
            
            NSLog(@"第%d张图片上传成功:%@", (NSInteger)i + 1, responseObject);
            @synchronized (result) { // NSMutableArray 是线程不安全的，所以加个同步锁
                result[i] = responseObject;
            }
            dispatch_group_leave(group);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //手动关闭MBProgressHUD
            [self hiddenHud:hud];
            //根据错误代码显示提示信息
            [self showFailMarkedWordsWithError:error];
            //请求失败
            NSLog(@"失败：%@",error);
            if (failure) {
                failure(error);
            }
            
            NSLog(@"第%d张图片上传失败：%@", (NSInteger)i + 1, error);
            dispatch_group_leave(group);
        }];
    }
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"上传完成!");
        for (id response in result) {
            NSLog(@"%@", response);
        }
    });
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
    
    [self POSTDataByUrl:urlString withParameters:param graceTime:graceTime completed:finish failure:failure];
    
}

#pragma mark -- image转化成Base64位
+ (NSString *)imageChangeBase64: (UIImage *)image{
    
    NSData   *imageData = nil;
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

//+  (BOOL)imageHasAlpha:(UIImage *)image{
//
//    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(image.CGImage);
//    return (alpha == kCGImageAlphaFirst ||
//            alpha == kCGImageAlphaLast ||
//            alpha == kCGImageAlphaPremultipliedFirst ||
//            alpha == kCGImageAlphaPremultipliedLast);
//
//}


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
}

- (id )resultsWithResponseObject:(id)json {
    
    if (!json || json == (id)kCFNull) {
        NSLog(@"原数据为nil，返回nil");
        return nil;
    }
    
    NSData *jsonData = nil;
    id jsonResults = nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        NSLog(@"返回原字典");
    } else if ([json isKindOfClass:[NSArray class]]) {
        NSLog(@"返回原数组");
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding : NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    
    if (jsonData) {
        
        jsonResults = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        
        if ([jsonResults isKindOfClass:[NSDictionary class]]) {
            NSLog(@"JSON数据返回字典");
        } else if ([jsonResults isKindOfClass:[NSArray class]]) {
            NSLog(@"JSON数据返回数组");
        } else if ([jsonResults isKindOfClass:[NSString class]]) {
            NSLog(@"JSON数据返回字符串");
        } else if (jsonResults == nil && [json isKindOfClass:[NSString class]]) {
            NSLog(@"返回原字符串");
            return json;
        } else if (jsonResults == nil && [json isKindOfClass:[NSData class]]) {
            // 不是数组，不是字典，还不是字符串吗？
            NSString *string = [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
            return string;
        } else {
            // 未识别
            NSLog(@"未识别防止解析报错，原数据返回nil");
            NSLog(@"未识别原数据：%@",json);
            return nil;
        }
        
        return jsonResults;
    }
    
    return json;
}

//隐藏hud  移除hud
+ (void)hiddenHud:(MBProgressHUD *)hud {
    if (hud != nil) {
        hud.taskInProgress = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        [hud removeFromSuperview];
    }
}

///根据错误代码显示提示信息
+ (void)showFailMarkedWordsWithError:(NSError *)error {
    
    //    NSLog(@"error = %@",error);
    //    NSLog(@"error.code = %d", error.code);//错误代码
    //    NSLog(@"error.description = %@", error.description);
    //    NSLog(@"error.localizedDescription = %@", error.localizedDescription); //错误信息
    //    NSLog(@"error.userInfo = %@", error.userInfo);
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

#pragma mark - params --->string 把参数转变成字符串
+ (NSString *)returnStringFromParams:(NSDictionary *)params {
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

@end
