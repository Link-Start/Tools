//
//  LSYTKGetRequest.h
//  YzzApp
//
//  Created by 刘晓龙 on 2019/12/13.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LSYTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSYTKGetRequest : LSYTKRequest

/// get 请求
- (id)initWithRequestUrl:(NSString *)url argument:(nullable NSDictionary *)argument;

@end

NS_ASSUME_NONNULL_END
