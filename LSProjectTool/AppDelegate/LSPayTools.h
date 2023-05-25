//
//  LSPayTools.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/7/20.
//  Copyright © 2021 Link-Start. All rights reserved.
//  微信、支付宝、苹果支付(内购)
//  https://www.jianshu.com/p/4e03b45e687a
//  http://www.jianshu.com/u/2a2051ad6a5d

#import <Foundation/Foundation.h>


/// 支付结果
typedef NS_ENUM(NSUInteger, PayResultCode) {
    WXPaySuccess            = 1001,   /**< 微信支付成功    */
    WXPayFail               = 1002,   /**< 微信支付失败    */
    WXPayCancel             = 1003,   /**< 用户点击取消并返回 */
    WXError_NotInstall      = 1004,   /**< 未安装微信   */
    WXError_Unsupport       = 1005,   /**< 微信不支持    */
    WXError_Param           = 1006,   /**< 微信支付参数解析错误   */
    
    AlipayPaySuccess        = 1101,   /**< 支付宝支付成功 */
    AlipayPayError          = 1102,   /**< 支付宝支付错误 */
    AlipayPayCancel         = 1103,   /**< 支付宝支付取消 */
    AlipayError_Param       = 1006,   /**< 支付宝支付参数解析错误   */
    
    
    AppStorePaySuccess      = 1201,   /**内购支付成功*/
    AppStorePayError        = 1202,   /**内购支付失败*/
    AppStorePayCancel       = 1203,   /**内购支付取消*/
    AppStore_Unsupport      = 1205,   /**< 内购支付不支持,不支持内购    */
    AppStore_NotAllow       = AppStore_Unsupport,
};


typedef void (^PayComplete)(PayResultCode code, NSString * _Nullable stateString, NSDictionary* _Nullable data);



NS_ASSUME_NONNULL_BEGIN

/// 支付工具
@interface LSPayTools : NSObject


/// 单利
+ (instancetype)sharedInstance;

#pragma mark - 微信
/// 微信需要注册，支付宝不需要注册     appid:微信开发者ID           universalLink:微信开发者Universal Link
- (void)wx_registerApp:(NSString *)wx_appid universalLink:(NSString *)universalLink;

- (void)wx_payRequestWithPayStr:(NSString *)payStr complete:(PayComplete)completion;
/// 调起微信支付
/// @param pay_param 支付参数 json串
/// @param successBlock 成功
/// @param failBlock    失败
- (void)wx_payRequestWithPayParam:(NSString *)pay_param success:(PayComplete)successBlock failure:(PayComplete)failBlock;
/// 调起微信支付
/// @param dict 微信订单字典(全部由后台拼接好给iOS端)
/// @param successBlock 成功
/// @param failBlock    失败
- (void)wx_payRequestWithPayDict:(NSDictionary *)dict success:(PayComplete)successBlock failure:(PayComplete)failBlock;



#pragma mark - 支付宝
#pragma mark - 支付宝  支付宝不需要 注册

///// 支付宝支付
//- (void)alipay_payRequestWithJsonStr:(NSString *)jsonStr alipayScheme:(NSString *)alipayScheme success:(PayComplete)successBlock failure:(PayComplete)failBlock;

/// 支付宝支付发起支付请求/调用支付结果开始支付    支付宝不需要 注册
/// @param orderStr 支付宝支付参数(全部由后台拼接好给iOS端)
- (void)alipay_payRequestWithOrderStr:(NSString *)orderStr alipayScheme:(NSString *)alipayScheme success:(PayComplete)successBlock failure:(PayComplete)failBlock;


#pragma mark - 苹果内购     In-App Purchase

/******************* 参数 ********************/
///用户ID
@property (nonatomic, copy) NSString *user_id;
///订单发送时间（yyyyMMddHHmmss）
@property (nonatomic , copy) NSString *orderSendTime;
///订单号
@property (nonatomic , copy) NSString *traderOrderNo;
///交易金额（分）
@property (nonatomic , copy) NSString *tranAmt;



/// 开启内购监听 在程序入口 didFinsihLaunchingWithOptions 实现
- (void)IAP_startManagerObserver;
/// 停止内购监听 在AppDelegate.m中的applicationWillTerminate方法实现
- (void)IAP_stopManagerObserver;

/// 拉起内购支付
/// @param productId productId
/// @param successBlock 成功的回调
/// @param failBolck 失败的回调
- (void)IAP_requestProductId:(NSString *)productId success:(PayComplete)successBlock failure:(PayComplete)failBolck;

@end

NS_ASSUME_NONNULL_END
