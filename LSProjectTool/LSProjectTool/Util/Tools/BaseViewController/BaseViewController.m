//
//  NetworkRequest.m
//  LALA
//
//  Created by Xcode on 16/5/27.
//  Copyright © 2016年 Link+Start. All rights reserved.
//


#import "BaseViewController.h"

@implementation BaseViewController

#pragma mark - GET请求
//GET请求
- (void)GETDataByUrl:(NSString*)url withParameters:(NSDictionary*)parameters completed:(void(^)(id json))finish failure:(void(^)( NSError *error))failure {
    
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    [MBProgressHUD showMessage:@"加载中..."];
    ////1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //开始请求
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        // 这里可以获取到目前的数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        // 请求成功，解析数据
        [self tryToParseData:responseObject];
        
        //显示成功
        //        [MBProgressHUD showSuccess:@"成功"];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull   error) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        // 请求失败
        NSLog(@"请求失败:%@", [error localizedDescription]);
        
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        
        if (failure) {
            failure(error);
        }
        
        //显示失败
        //        [MBProgressHUD showError:@"失败"];
    }];
}

#pragma mark - POST请求
//请求数据
- (void)POSTDataByUrl:(NSString *)url withParameters:(NSDictionary *)parameters completed:(void(^)(id json))finish failure:(void(^)(NSError *))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    [MBProgressHUD showMessage:@"加载中..."];
    ////1.创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //申明返回的结果,不加上这句话，会报“Request failed: unacceptable content-type: text/plain”错误，因为我们要获取text/plain类型数据
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 10.f;
    //开始请求
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
        
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        
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
- (void)uploadImage:(UIImage *)image toURL:(NSString *)urlString imageKey:(NSString *)imageKey parameters:(NSDictionary *)parameters completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    [MBProgressHUD showMessage:@"正在上传"];
    
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
        
        //请求成功
        //NSLog(@"请求成功：%@",responseObject);
        
        //解析数据
        [self tryToParseData:responseObject];
        
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
- (void)uploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure {
    //判断网络是否可用 如果不可用直接返回
    if (![self activeNetwork]) {
        return;
    }
    //显示加载中
    [MBProgressHUD showMessage:@"正在上传"];
    //要保存在服务器上的[文件名]
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [self returnWithATimeStampAsFileName]];
    //1。创建管理者对象
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //设置请求超时的时间
    manager.requestSerializer.timeoutInterval = 30.f;
    //2.上传文件
    [manager POST:urlString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 拼接data到请求体，这个block的参数是遵守AFMultipartFormData协议的。
        //上传文件参数
        for (UIImage *image in images) {
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
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //打印 上传进度
        NSLog(@"上传进度：%lf",1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        
        //解析数据
        finish([self tryToParseData:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //手动关闭MBProgressHUD
        [MBProgressHUD hideHUD];
        //根据错误代码显示提示信息
        [self showFailMarkedWordsWithError:error];
        
        //请求失败
        NSLog(@"失败：%@",error);
        failure(error);
    }];
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
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers | NSJSONReadingMutableLeaves | NSJSONReadingAllowFragments error:&error];
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


#pragma mark - 监测当前网络状态（网络监听）
#pragma mark - 检查网络连接
/**
 *  检查当前网络连接 有网络:yes  无网络:no
 */
- (BOOL)currentNetworkStatus {
    
    //需要在didFinishLaunchingWithOptions中开启网络监听 [GLobalRealReachability startNotifier];
    
    //是否有网络
    __block BOOL canCheckNetwork  = NO;
    //触发实时网络状态查询代
    [GLobalRealReachability reachabilityWithBlock:^(ReachabilityStatus status) {
        switch (status) {
            case RealStatusUnknown: {
                NSLog(@"未知网络状态");
                canCheckNetwork  = NO;
                break;
            }
            case RealStatusNotReachable: {
                NSLog(@"网络连接已断开，请检查您的网络");
                canCheckNetwork  = NO;
                break;
            }
            case RealStatusViaWWAN: {
                NSLog(@"蜂窝数据网");
                {
                    //查询当前实际网络连接类型
                    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
                    switch (accessType) {
                        case WWANTypeUnknown: {
                            NSLog(@"未知网络状态,可能是iOS6");
                            break;
                        }
                        case WWANType4G: {
                            NSLog(@"4G网络");
                            break;
                        }
                        case WWANType3G: {
                            NSLog(@"3G网络");
                            break;
                        }
                        case WWANType2G: {
                            NSLog(@"2G网络");
                            break;
                        }
                        default:
                            break;
                    }
                }
                canCheckNetwork = YES;
                break;
            }
            case RealStatusViaWiFi: {
                NSLog(@"WiFi网络");
                canCheckNetwork = YES;
                break;
            }
            default:
                break;
        }
    }];
    return canCheckNetwork;
}

/**
 *  当前网络是否活跃
 *
 *  @return  YES:活跃  NO:不活跃
 */
- (BOOL)activeNetwork {
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusViaWiFi || status == RealStatusViaWWAN ||  status == RealStatusUnknown) {
        return YES;
    }
    return NO;
}

#pragma mark - 监测当前网络状态（网络监听）
/**
 *  监测当前网络状态（网络监听） 使用通知监听
 */
- (void)checkNetworkStatus:(NSNotification *)notification {
    
    RealReachability *reachability = (RealReachability *)notification.object;
    ReachabilityStatus status = [reachability currentReachabilityStatus];
    ReachabilityStatus previousStatus = [reachability previousReachabilityStatus];
    NSLog(@"networkChanged, currentStatus:%@, previousStatus:%@", @(status), @(previousStatus));
    
    if (status == RealStatusNotReachable)
    {
         NSLog(@"网络连接已断开，请检查您的网络");
    }
    
    if (status == RealStatusViaWiFi)
    {
         NSLog(@"WiFi网络");
    }
    
    if (status == RealStatusViaWWAN)
    {
         NSLog(@"蜂窝数据网");
    }
    
     //查询当前实际网络连接类型
    WWANAccessType accessType = [GLobalRealReachability currentWWANtype];
    
    if (status == RealStatusViaWWAN)
    {
        if (accessType == WWANType2G)
        {
             NSLog(@"2G网络");
        }
        else if (accessType == WWANType3G)
        {
             NSLog(@"3G网络");
        }
        else if (accessType == WWANType4G)
        {
             NSLog(@"4G网络");
        }
        else
        {
            NSLog(@"未知网络状态,可能是iOS6");
        }
    }
}

#pragma mark - 检查网络连接
/**
 *  检查网络连接  //这个可以测出网络状态
 */
- (BOOL)AFNetworkStatus {
    //是否正在检查网络
    __block BOOL canCheckNetwork  = NO;
    
    //1..检查网络连接(苹果公司提供的检查网络的第三方库 Reachability)
    //AFN 在 Reachability基础上做了一个自己的网络检查的库, 基本上一样
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        canCheckNetwork = YES;
    }];
    
    //网络只有在startMonitoring完成后才可以使用检查网络状态
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //监听网络变化通知：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kRealReachabilityChangedNotification object:nil];
    
    ReachabilityStatus status = [GLobalRealReachability currentReachabilityStatus];
    
    if (status == RealStatusNotReachable) {
        NSLog(@"网络连接已断开，请检查您的网络");
    } else if (status == RealStatusViaWiFi) {
        NSLog(@"WiFi网络");
    } else if (status == RealStatusViaWWAN) {
        NSLog(@"蜂窝数据网");
    }
    
    //自定义返回按钮
    if (self.navigationController.viewControllers.count > 1) {
        
        //    返回按钮
        UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"3注册-返回"] style:UIBarButtonItemStyleDone target:self action:@selector(leftButtonItemAction:)];

        self.navigationItem.leftBarButtonItem = leftButtonItem;
        
//        UIImage *backButtonImage = [[UIImage imageNamed:@"icon_tabbar_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        self.navigationController.navigationBar.backIndicatorImage = backButtonImage;
//        self.navigationController.navigationBar.backIndicatorTransitionMaskImage = backButtonImage;

    }
    
    
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    //将prefersLargeTitles 属性设置为ture，navigation bar就会在整个APP中显示大标题
    if (@available(iOS 11.0, *)) {
        //如果想要在控制不同页面大标题的显示，可以通过设置当前页面的navigationItem的largeTitleDisplayMode属性
        //iOS11之后如果设置了prefersLargeTitles = YES导航栏 高度为96pt，默认情况下还是64pt
        self.navigationController.navigationBar.prefersLargeTitles = NO;
    } else {
        // Fallback on earlier versions
    }
    
//    self.tableView.estimatedRowHeight = 0;
//    self.tableView.estimatedSectionHeaderHeight = 0;
//    self.tableView.estimatedSectionFooterHeight = 0;
}

//返回按钮点击事件
- (void)leftButtonItemAction:(UIBarButtonItem *)sender {
    [self judge];
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

//只要日志没有打印出来，说明内存得不到释放，就需要学会分析内存引用问题了
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"进入控制器：%@", [[self class] description]);
}
- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
