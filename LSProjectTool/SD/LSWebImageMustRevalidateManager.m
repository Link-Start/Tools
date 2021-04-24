//
//  LSWebImageMustRevalidateManager.m
//  YzzApp
//
//  Created by 刘晓龙 on 2020/1/8.
//  Copyright © 2020 LF. All rights reserved.
//

#import "LSWebImageMustRevalidateManager.h"
#import "LSWebImageMustRevalidateDownloader.h"


@implementation LSWebImageMustRevalidateManager

+ (nonnull instancetype)sharedManager {

    static dispatch_once_t once;
    static id instance;

    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

//+ (id<SDImageLoader>)defaultImageLoader {
//    return [LSWebImageMustRevalidateDownloader sharedDownloader];
//}

@end
