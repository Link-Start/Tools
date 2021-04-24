//
//  LSYTKRequest.h
//  YzzApp
//
//  Created by 刘晓龙 on 2019/12/13.
//  Copyright © 2019 LF. All rights reserved.
//  来源:https://blog.csdn.net/thelittleboy/article/details/83895624

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@class LSYTKRequest;

typedef void(^LSYTKRequestCompletionSuccessBlock)(__kindof LSYTKRequest *request, NSDictionary *result, BOOL success);
typedef void(^LSYTKRequestCompletionFailureBlock)(__kindof LSYTKRequest *request, NSString *errorInfo);


@protocol LSYTKRequestDelegate <NSObject>

- (void)LSYTKRequestCompletionSuccess:(__kindof LSYTKRequest *)request result:(NSDictionary *)result success:(BOOL)success;
- (void)LSYTKRequestCompletionFail:(__kindof LSYTKRequest *)request error:(NSString *)errorInfo;

@end


@interface LSYTKRequest : YTKRequest

///请求的URL地址
@property (nonatomic, copy) NSString *requestUrl;

///请求参数
@property (nonatomic, strong) id requestArgument;

///错误提示
@property (nonatomic, copy) NSString *errorInfo;

///请求类型
@property (nonatomic, assign) YTKRequestSerializerType ytk_requestSerializerType;

///是否校验json数据格式 默认no
@property (nonatomic, assign) BOOL verifyJSONFormat;

///开始请求数据
- (void)startWithCompletionBlockWithSuccess:(nullable LSYTKRequestCompletionSuccessBlock)success
                                    failure:(nullable LSYTKRequestCompletionFailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
