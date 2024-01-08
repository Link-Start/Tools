//
//  UIImageView+YYWebImage.h
//  YYKit <https://github.com/ibireme/YYKit>
//
//  Created by ibireme on 15/2/23.
//  Copyright (c) 2015 ibireme.
//
//  This source code is licensed under the MIT-style license found in the
//  LICENSE file in the root directory of this source tree.
//

#import <UIKit/UIKit.h>

#if __has_include(<YYKit/YYKit.h>)
#import <YYKit/YYWebImageManager.h>
#else
#import "YYWebImageManager.h"
#endif

NS_ASSUME_NONNULL_BEGIN

/**
 UIImageView的Web图像方法。
 */
@interface UIImageView (YYWebImage)

#pragma mark - image

/**
 当前image的URL。Current image URL.
 
 @discussion 为此属性设置新值将取消以前的请求操作,并创建一个新的请求操作来获取图像.设为nil将清除image和imageURL
 */
@property (nullable, nonatomic, strong) NSURL *imageURL;

/// 使用指定的URL设置视图的图像
/// @param imageURL image的url地址 (远程或者本地文件路径) .
/// @param placeholder 占位图
- (void)setImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

/// 使用指定的URL设置视图的图像
/// @param imageURL 图像的url地址.
/// @param options 请求图像时要使用的选项
- (void)setImageWithURL:(nullable NSURL *)imageURL options:(YYWebImageOptions)options;

/// 使用指定的URL设置视图的图像
/// @param imageURL 图像url (远程或本地文件路径).
/// @param placeholder 占位图
/// @param options 请求图像时要使用的选项
/// @param completion 图片请求完成时调用的block(在主线程上)
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(nullable YYWebImageCompletionBlock)completion;

/// 使用指定的URL设置视图的图像
/// @param imageURL 图像地址（远程或本地文件路径）
/// @param placeholder 占位图
/// @param options 请求图像时要使用的选项
/// @param progress 在image请求期间调用的block（在主线程）
/// @param transform 这个block（在后台线程）用于执行额外的图像处理.
/// @param completion 图片请求完成时调用的block（在主线程上）.
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/// 使用指定的URL设置视图的图像
/// @param imageURL 图片地址(远程或本地文件路径)
/// @param placeholder 占位图
/// @param options 请求图像时要使用的选项
/// @param manager 用于创建图片请求操作的管理器
/// @param progress 在图片请求期间调用的block
/// @param transform 这个block（在后台线程）用于执行额外的图像处理
/// @param completion 图片请求完成时调用的block（在主线程）.
- (void)setImageWithURL:(nullable NSURL *)imageURL
               placeholder:(nullable UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(nullable YYWebImageManager *)manager
                  progress:(nullable YYWebImageProgressBlock)progress
                 transform:(nullable YYWebImageTransformBlock)transform
                completion:(nullable YYWebImageCompletionBlock)completion;

/// 取消当前的图片请求
- (void)cancelCurrentImageRequest;



#pragma mark - 高亮显示图片  highlight image

/**
 当前高亮显示图像URL
 
 @discussion 为此属性设置新值将取消以前的请求操作,并创建一个新的请求操作来获取图像.设置为nil将清除高亮显示的图像和图像URL
 */
@property (nullable, nonatomic, strong) NSURL *highlightedImageURL;

/// 使用指定的URL设置视图的 highlightedImage
/// @param imageURL 图像的url（远程或者本地文件路径）
/// @param placeholder 占位图
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL placeholder:(nullable UIImage *)placeholder;

/// 使用指定的URL设置视图的 highlightedImage
/// @param imageURL 图像的url（远程或者本地的文件路径）
/// @param options 请求图像时要使用的选项
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL options:(YYWebImageOptions)options;

/// 使用指定的URL设置视图的 highlightedImage
/// @param imageURL 图像的 url（远程或者本地的文件路径）
/// @param placeholder 占位图
/// @param options 请求图像时要使用的选项
/// @param completion 图片请求完成时调用的block（在主线程上）
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                           completion:(nullable YYWebImageCompletionBlock)completion;

/// 使用指定的URL设置视图的 highlightedImage
/// @param imageURL 图像的 url （远程或者本地的文件路径）
/// @param placeholder 占位图
/// @param options 请求图像时要使用的选项
/// @param progress 在图像请求期间调用的block（在主线程上）
/// @param transform 这个block（在后台线程上）用于执行额外的图像处理
/// @param completion 图像请求完成时调用的block（在主线程上）
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                             progress:(nullable YYWebImageProgressBlock)progress
                            transform:(nullable YYWebImageTransformBlock)transform
                           completion:(nullable YYWebImageCompletionBlock)completion;

/// 使用指定的URL设置视图的 highlightedImage
/// @param imageURL 图像的url（远程或者本地文件路径）
/// @param placeholder 占位图
/// @param options 请求图像时要使用的选项
/// @param manager 用于创建图像请求操作的管理器
/// @param progress 在图像请求期间调用的block（在主线程上）
/// @param transform 这个block（在后台线程上）用于执行额外的图像处理
/// @param completion 图像请求完成时调用的block（在主线程上）.
- (void)setHighlightedImageWithURL:(nullable NSURL *)imageURL
                          placeholder:(nullable UIImage *)placeholder
                              options:(YYWebImageOptions)options
                              manager:(nullable YYWebImageManager *)manager
                             progress:(nullable YYWebImageProgressBlock)progress
                            transform:(nullable YYWebImageTransformBlock)transform
                           completion:(nullable YYWebImageCompletionBlock)completion;

/**
 取消当前的 highlighed image 请求
 */
- (void)cancelCurrentHighlightedImageRequest;

@end

NS_ASSUME_NONNULL_END
