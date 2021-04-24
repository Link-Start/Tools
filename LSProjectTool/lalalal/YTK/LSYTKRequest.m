//
//  LSYTKRequest.m
//  YzzApp
//
//  Created by 刘晓龙 on 2019/12/13.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LSYTKRequest.h"
#import "YTKNetworkConfig.h"

@implementation LSYTKRequest

- (instancetype)init {
    self = [super init];
    if (self) {
        [YTKNetworkConfig sharedConfig].debugLogEnabled = YES;//开机debug模式
        
        self.verifyJSONFormat = NO;
    }
    return self;
}

- (NSString *)baseUrl {
    return @"http://api.yzzgroup.cn/";
}

- (NSTimeInterval)requestTimeoutInterval {
    return 10;
}

- (id)jsonValidator {
    if (self.verifyJSONFormat) {
        return @{
            @"Data":[NSObject class],
            @"State":[NSNumber class],
            @"Message":[NSString class]
        };
    } else {
        return nil;
    }
}

//开始请求数据
- (void)startWithCompletionBlockWithSuccess:(LSYTKRequestCompletionSuccessBlock)success
                                    failure:(LSYTKRequestCompletionFailureBlock)failure {
    
    [super startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary *result = [request responseJSONObject];
        BOOL isSuccess = YES;
        //校验格式
        if (self.verifyJSONFormat) {
            isSuccess = [[result objectForKey:@"success"] boolValue];
        }
        
        if (success) {
            success(request, result, isSuccess);
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSLog(@"错误信息：%@", self.description);
        if (failure) {
            failure(request, self.errorInfo);
        }
    }];
}


//打印信息
- (NSString *)description {
    //打印信息
        return [NSString stringWithFormat:@"%@ \n statusCode:%ld\n responseJSONObject:\n%@",super.description,self.responseStatusCode,self.responseJSONObject];
    
}

//错误信息提示
- (NSString *)errorInfo {
    NSString *info = @"";
    if (self && self.error) {
        if (self.error.code == NSURLErrorNotConnectedToInternet) {
            info = @"请检查网络";
        } else if (self.error.code==NSURLErrorTimedOut) {
            info = @"请求超时,请重试!";
        } else if (self.responseStatusCode == 401) {
            info = @"401";
        } else if (self.responseStatusCode == 403) {
            info = @"403";
        } else if (self.responseStatusCode == 404) {
            info = @"服务器错误(404),请稍后再试!";
        } else if (self.responseStatusCode == 500) {
            info = @"服务器报错(500),请稍后再试!";
        } else {
            info = @"获取数据失败,请重试!";
        }
    }
    
    return info;
}


@end
