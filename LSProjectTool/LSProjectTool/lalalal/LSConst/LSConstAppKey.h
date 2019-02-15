//
//  LSConstAppKey.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2019/1/24.
//  Copyright © 2019年 Link-Start. All rights reserved.
//

/*
 NSString *const 和 const NSString * 的区别
 1.变量存储的指针可变，变量存储的值不可变
 const NSString * str = @"11";
 str = @"22";
 2.变量存储的值可变，变量存储的指针不可变
 NSString *const str1 = @"33";
 str1 = @"44";   //会报错
 **/


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSConstAppKey : NSObject

///极光推送appKey
UIKIT_EXTERN NSString *const JPush_appKey;

///友盟_appKey
UIKIT_EXTERN NSString *const UM_appKey;

///微信_appId
UIKIT_EXTERN NSString *const WeChat_appId;
///微信_appKey
UIKIT_EXTERN NSString *const WeChat_appKey;
///微信_appSecret
UIKIT_EXTERN NSString *const WeChat_appSecret;

///QQ_appId
UIKIT_EXTERN NSString *const QQ_appId;
///QQ_appKey
UIKIT_EXTERN NSString *const QQ_appKey;
///客服_QQ
UIKIT_EXTERN NSString *const QQ_KeFu;

///新浪_appKey
UIKIT_EXTERN NSString *const Sina_appKey;
///新浪_appId
UIKIT_EXTERN NSString *const Sina_appId;
///新浪_appSecret
UIKIT_EXTERN NSString *const Sina_appSecret;

///阿里(支付宝)_appKey
UIKIT_EXTERN NSString *const Alipay_appKey;

///百度_appKey
UIKIT_EXTERN NSString *const Baidu_appKey;
///百度地图_appKey
UIKIT_EXTERN NSString *const BaiduMaps_appKey;

///高度地图_appKey
UIKIT_EXTERN NSString *const GaoDeMaps_appKey;

///环信_appKey
UIKIT_EXTERN NSString *const HuanXin_appKey;

@end

NS_ASSUME_NONNULL_END
