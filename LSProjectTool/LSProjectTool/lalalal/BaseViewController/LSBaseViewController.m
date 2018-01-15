//
//  NetworkRequest.m
//  LALA
//
//  Created by Xcode on 16/5/27.
//  Copyright © 2016年 Link+Start. All rights reserved.
//


#define kTimeoutInterval 10

#import "LSBaseViewController.h"
#import "MBProgressHUD+Extension.h"


@implementation LSBaseViewController

#pragma mark - GET请求

//GET请求
- (void)GETDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)( NSError *error))failure {
    [self GETDataByUrl:url withParameters:parameters graceTime:graceTime markedWords:@"加载中..." completed:finish failure:failure];
}

- (void)GETDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime markedWords:(NSString *)markedWords completed:(void (^)(id))finish failure:(void (^)(NSError *))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![LSCheckoutNetworkState activeNetwork]) {
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
        
        // 请求成功，解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
        //显示成功
        //        [MBProgressHUD showSuccess:@"成功"];
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
- (void)POSTDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![LSCheckoutNetworkState activeNetwork]) {
        return;
    }
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    ////1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果,不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = kTimeoutInterval;
    //开始请求
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
- (void)uploadImage:(UIImage *)image toURL:(NSString *)urlString imageKey:(NSString *)imageKey parameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![LSCheckoutNetworkState activeNetwork]) {
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
        
        // 请求成功，解析数据
        if (finish) {
            finish([self tryToParseData:responseObject]);
        }
        
        
        //显示成功
        //[MBProgressHUD showSuccess:@"成功"];
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
- (void)uploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![LSCheckoutNetworkState activeNetwork]) {
        return;
    }
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    
    //要保存在服务器上的[文件名]
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 30.f;
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

//尽管异步请求的返回先后顺序没有一定，很可能后发出的请求先返回；但是最后回调的时候，请求返回的结果必须要按请求发出的顺序排列
//
- (void)yuploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![LSCheckoutNetworkState activeNetwork]) {
        return;
    }
    //显示加载中
    MBProgressHUD *hud = [MBProgressHUD hud:graceTime];
    
    //1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 30.f;
    
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

///返回时间戳
- (NSString *)returnWithATimeStampAsFileName {
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
- (id)tryToParseData:(id)responseData {
    
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
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&error];
            ////如果 错误不为空
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

//隐藏hud  移除hud
- (void)hiddenHud:(MBProgressHUD *)hud {
    if (hud != nil) {
        hud.taskInProgress = NO;
        hud.removeFromSuperViewOnHide = YES;
        [hud hide:YES];
        [hud removeFromSuperview];
    }
}

///根据错误代码显示提示信息
- (void)showFailMarkedWordsWithError:(NSError *)error {
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //自定义返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        //    返回按钮
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3注册-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonItemAction:)];
        
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

//返回按钮点击事件
- (void)leftButtonItemAction:(UIBarButtonItem *)sender {
    [self judge];
    
//    //或者
//    [self backOut];
}

///判断当前ViewController是push还是present的方式显示的
- (void)judge {
    
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    
    if (viewcontrollers.count > 1) {
        
        if ([viewcontrollers objectAtIndex:viewcontrollers.count - 1] == self) {
            //push方式
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } else {
        //present方式
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)backOut {
    //presentingViewController: present出来本视图控制器的视图控制器
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//返回到指定控制器
- (void)backToVC:(UIViewController *)VC {
    for (UIViewController *tempVc in self.navigationController.viewControllers) {
        if ([tempVc isKindOfClass:[VC class]]) {
            [self.navigationController popToViewController:tempVc animated:YES];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; //即使没有显示在window上，也不会自动的将self.view释放
    // Dispose of any resources that can be recreated.
    
    // 此处做兼容处理需要加上ios6.0的宏开关，保证是在6.0以上版本使用
    // 6.0以前屏蔽以下代码，否则会在下面使用self.view时自动加载viewDidUnLoad
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
        
        //需要注意的是self.isViewLoaded是必不可少的，其他方式访问视图会导致它加载,在WWDC视频也忽视这一点。
        if (self.isViewLoaded && !self.view.window) {// 是否是正在使用的视图
            
            self.view = nil;// 目的是再次进入时能够重新加载调用viewDidLoad函数。
        }
    }
}

//只要日志没有打印出来，说明内存得不到释放，就需要学会分析内存引用问题了
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"进入控制器：%@", [[self class] description]);
}
- (void)dealloc {
    //移除通知
    NSLog(@"控制器被dealloc: %@", [[self class] description]);
    NSLog(@"%s", __func__);
}


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
