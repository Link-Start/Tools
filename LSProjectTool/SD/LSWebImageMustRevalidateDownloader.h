//
//  LSWebImageMustRevalidateDownloader.h
//  YzzApp
//
//  Created by 刘晓龙 on 2020/1/8.
//  Copyright © 2020 LF. All rights reserved.
//
// 不缓存图片，每次都重新加载新的图片，不管图片url地址是否改变



#import "SDWebImageDownloader.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSWebImageMustRevalidateDownloader : SDWebImageDownloader

@end

NS_ASSUME_NONNULL_END
