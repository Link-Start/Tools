//
//  LSYTKGetRequest.m
//  YzzApp
//
//  Created by 刘晓龙 on 2019/12/13.
//  Copyright © 2019 LF. All rights reserved.
//

#import "LSYTKGetRequest.h"

@implementation LSYTKGetRequest

- (id)initWithRequestUrl:(NSString *)url argument:(NSDictionary *)argument {
    self = [super init];
    if (self) {
        self.requestUrl = url;
        self.requestArgument = argument;
    }
    return self;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
