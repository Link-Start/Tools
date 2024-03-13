//
//  LSHandleNetworkRequest.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/1/16.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LSHTTPCodeStatus) {
    LSHTTPCodeStatusUnknown,
    
    LSHTTPCodeStatusBadRequest = 400,
    LSHTTPCodeStatusUnauthorized = 401,
};

static NSString * const _Nonnull LSHTTPCodeStatusStringMap[] = {
    [LSHTTPCodeStatusUnknown] = @"未知编码",
    [LSHTTPCodeStatusBadRequest] = @"服务器错误",
    [LSHTTPCodeStatusUnauthorized] = @"用户身份未验证",
};









/// 处理网络请求数据
@interface LSHandleNetworkRequest : NSObject

/// 根据错误代码显示提示信息
+ (void)showFailMarkedWordsWithError:(NSError *)error;


@end

NS_ASSUME_NONNULL_END
