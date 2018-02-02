//
//  NetworkRequest.h
//  LALA
//
//  Created by Xcode on 16/5/27.
//  Copyright © 2016年 Link+Start. All rights reserved.
//

//AFN 3.0版本现在正式支持的iOS 7， Mac OS X的10.9， watchOS 2 ， tvOS 9 和Xcode 7
//从AFNetworking 3.0后UIAlertView的类目因过时而被废弃

#import <Foundation/Foundation.h>
#import "Tools.h"
///网络请求工具(对AFNetworking的封装)
/*!
 *  @author
 *
 *  基于AFNetworking的网络层封装类.
 *
 *  @note 这里只提供公共api
 */
@interface NetworkRequest : NSObject

//###################################################################################################
#pragma mark - 数据请求

/**
 *  GET请求
 *
 *  @param url        网址
 *  @param parameters 参数
 *  @param graceTime  提示时间
 *  @param markedWords 提示语
 *  @param finish
 *  @param failure
 */
+ (void)GETDataByUrl:(NSString*)url
      withParameters:(NSDictionary*)parameters
           graceTime:(CGFloat)graceTime
         markedWords:(NSString *)markedWords
           completed:(void(^)(id json))finish
             failure:(void(^)( NSError *error))failure;

/**
 *  GET请求
 *
 *  @param url        网址
 *  @param parameters 参数
 *  @param finish
 *  @param failure
 */
+ (void)GETDataByUrl:(NSString*)url
      withParameters:(NSDictionary*)parameters
           graceTime:(CGFloat)graceTime
           completed:(void(^)(id json))finish
             failure:(void(^)( NSError *error))failure;
/**
 *  POST请求 1
 *
 *  @param url        网址
 *  @param parameters 参数
 *  @param finish
 *  @param failure
 */
+ (void)POSTDataByUrl:(NSString*)url
       withParameters:(NSDictionary*)parameters
            graceTime:(CGFloat)graceTime
            completed:(void(^)(id json))finish
              failure:(void(^)(NSError *error))failure;
#pragma mark - 上传
#pragma mark - 上传头像的方法(上传单个图片) 使用NSData数据流传图片
/**
 *  上传头像的方法(上传单个图片) 使用NSData数据流传图片
 *  @berif          上传图片少或者数量多都没关系,速度也很快
 *  @param images   要上传的头像 image（直接给图片，转换方法在里面）
 *  @param url      url地址
 *  @param imageKey 要上传的头像image 对应的key值字符串
 *  @param param    参数（除了image之外的参数）
 *  @param finish   请求成功的回调
 *  @param failure  请求失败的回调
 */
+ (void)uploadImage:(UIImage *)image toURL:(NSString *)urlString imageKey:(NSString *)imageKey parameters:(NSDictionary *)parameters graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure;
#pragma mark - 上传头像的方法(可以上传多个图片) 使用NSData数据流传图片
/**
 *  上传头像的方法(可以上传多个图片) 使用NSData数据流传图片
 *  @berif          上传图片少或者数量多都没关系,速度也很快
 *  @param images   装有 要上传的头像 image 的数组
 *  @param url      服务器网址
 *  @param param    参数（除了image之外的参数）
 *  @param finish   成功
 *  @param failure  失败
 */
+ (void)uploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure;
+ (void)async_uploadImages:(NSArray<UIImage*>*)images toURL:(NSString *)urlString parameters:(NSDictionary*)parameters imageKey:(NSString *)imageKey graceTime:(CGFloat)graceTime completed:(void(^)(id json))finish failure:(void(^)(NSError *error))failure;
#pragma mark - 使用Base64字符串上传图片
/**
 *  适合上传图片数量比较少的，比如上传头像，上传图片数量多的话，速度会慢些
 */


#pragma mark - 下载
/**
 *  检测当前网络是否可用
 *
 *  @return  Yes:有网络  NO:没有网络
 */
+ (BOOL)activeNetwork;

@end
