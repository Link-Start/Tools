//
//  LSWebImageMustRevalidateManager.h
//  YzzApp
//
//  Created by 刘晓龙 on 2020/1/8.
//  Copyright © 2020 LF. All rights reserved.
//
// 不缓存图片，没存都重新加载新的图片，不管图片url地址是否改变
// [cell.imgV sd_setImageWithURL:GET_SD_IMAGE_URL(kLS_GetString(data.PicUrl)) placeholderImage:nil options:SDWebImageRefreshCached context:@{SDWebImageContextCustomManager : [LSWebImageMustRevalidateManager sharedManager]}];

#import "SDWebImageManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LSWebImageMustRevalidateManager : SDWebImageManager

+ (nonnull instancetype)sharedManager;

@end

NS_ASSUME_NONNULL_END
