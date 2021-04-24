//
//  LSWebImageMustRevalidateDownloader.m
//  YzzApp
//
//  Created by 刘晓龙 on 2020/1/8.
//  Copyright © 2020 LF. All rights reserved.
//

#import "LSWebImageMustRevalidateDownloader.h"

@implementation LSWebImageMustRevalidateDownloader

+ (nonnull instancetype)sharedDownloader {

    static dispatch_once_t once;
    static LSWebImageMustRevalidateDownloader * instance;

    dispatch_once(&once, ^{
        instance = [self new];
        [instance setValue:@"must-revalidate" forHTTPHeaderField:@"Cache-Control"];
    });
    return instance;
}

@end
