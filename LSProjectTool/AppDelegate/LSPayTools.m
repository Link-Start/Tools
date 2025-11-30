//
//  LSPayTools.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/7/20.
//  Copyright © 2021 Link-Start. All rights reserved.
//
//业务 : https://www.jianshu.com/p/a678d98154c9
//代码 : https://www.jianshu.com/p/60645201a29c
//      https://www.jianshu.com/p/955e56aba8b0

#define HasWXApi (__has_include(<WXApi/WXApi.h>) || __has_include("WXApi.h"))
#define HasAlipaySDK (__has_include(<AlipaySDK/AlipaySDK.h>) || __has_include("AlipaySDK/AlipaySDK.h"))


#import "LSPayTools.h"

#if HasWXApi
#import "WXApi.h"
#endif
#if HasAlipaySDK
#import "AlipaySDK/AlipaySDK.h"
#endif

#if (__has_include(<YYKit/YYKit.h>) || __has_include("YYKit.h"))
#import "YYKit.h"
#endif


#import <StoreKit/StoreKit.h> //苹果支付(内购)
#import <UICKeyChainStore.h>

//#import "ADFileManager.h"


#define tempOrderPath [[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/Preferences"] stringByAppendingPathComponent:@"/tempOrderPath"]
#define iapReceiptPath [[[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"/Preferences"] stringByAppendingPathComponent:@"/tempOrderPath"]
#define kApple_pay_Unlock_iap_userId @"apple_pay_unlock_iap_user_Id"
#define kApple_pay_Unlock_transactionId @"apple_pay_unlock_transaction_Id"
#define kApple_pay_ReceiptKey @"apple_pay_receipt_Key"
#define kApple_pay_OrderNo @"apple_pay_order_no"
#define kApple_pay_Time @"apple_pay_time"
#define kApple_pay_UserId @"apple_pay_user_id"


dispatch_queue_t iap_queue() {
    static dispatch_queue_t as_iap_queue;
    static dispatch_once_t onceToken_iap_queue;
    dispatch_once(&onceToken_iap_queue, ^{
        as_iap_queue = dispatch_queue_create("com.iap.queue", DISPATCH_QUEUE_CONCURRENT);
    });
    return as_iap_queue;
}


@interface LSPayTools ()<WXApiDelegate,SKProductsRequestDelegate,SKPaymentTransactionObserver>
/// 微信 appId
@property (nonatomic, copy) NSString *wx_AppID;
/// 苹果内购支付
@property (nonatomic, copy) NSString *product_Id;
//购买凭证 存储base64编码的交易凭证
@property (nonatomic, copy) NSString *receiptBase64String;


@property (nonatomic, copy) PayComplete PaySuccessBlock;
@property (nonatomic, copy) PayComplete PayFailBlock;

@end

@implementation LSPayTools

#pragma mark -
static LSPayTools *_ls_payTools = nil;
/// 单利
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _ls_payTools = [[LSPayTools alloc] init];
    });
    return _ls_payTools;
}

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}


#pragma mark - 微信   微信需要先注册
/// 微信需要注册，支付宝不需要注册
/// 向微信终端程序注册第三方应用
/// @attention 请保证在主线程中调用此函数
/// @param appid 微信开发者ID
/// @param universalLink 微信开发者Universal Link
- (void)wx_registerApp:(NSString *)wx_appid universalLink:(NSString *)universalLink {
#if HasWXApi
    //在register之前打开log, 后续可以根据log排查问题
    [WXApi startLogByLevel:WXLogLevelDetail logBlock:^(NSString *log) {
        NSLog(@"微信SDK WeChatSDK: %@", log);
    }];

    [WXApi registerApp:wx_appid universalLink:universalLink];//
    [WXApi sendReq:nil completion:nil];

    //自检函数
    [WXApi checkUniversalLinkReady:^(WXULCheckStep step, WXCheckULStepResult* result) {
        NSLog(@"微信自检：%@, %u, %@, %@", @(step), result.success, result.errorInfo, result.suggestion);
    }];
#endif
}


- (void)wx_payRequestWithPayStr:(NSString *)payStr complete:(PayComplete)completion {
#if HasWXApi
    if (![WXApi isWXAppInstalled]) {
//        [BEEToast showFailWithMessage:@"该支付渠道暂时无法使用"];
        NSLog(@"该支付渠道暂时无法使用");
        return;
    }

    payStr = [[[payStr stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@"{" withString:@""] stringByReplacingOccurrencesOfString:@"}" withString:@""];
    NSArray *payInfos = [payStr componentsSeparatedByString:@","];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *wxPayInfo in payInfos) {
        if ([wxPayInfo containsString:@"partnerid"]) {
            dic[@"partnerid"] = [wxPayInfo stringByReplacingOccurrencesOfString:@"partnerid=" withString:@""];
            continue;
        }
        if ([wxPayInfo containsString:@"prepayid"]) {
            dic[@"prepayid"] = [wxPayInfo stringByReplacingOccurrencesOfString:@"prepayid=" withString:@""];
            continue;
        }
        if ([wxPayInfo containsString:@"package"]) {
            dic[@"package"] = [wxPayInfo stringByReplacingOccurrencesOfString:@"package=" withString:@""];
            continue;
        }
        if ([wxPayInfo containsString:@"noncestr"]) {
            dic[@"noncestr"] = [wxPayInfo stringByReplacingOccurrencesOfString:@"noncestr=" withString:@""];
            continue;
        }
        if ([wxPayInfo containsString:@"timestamp"]) {
            dic[@"timestamp"] = [wxPayInfo stringByReplacingOccurrencesOfString:@"timestamp=" withString:@""];
            continue;
        }
        if ([wxPayInfo containsString:@"sign"]) {
            dic[@"sign"] = [wxPayInfo stringByReplacingOccurrencesOfString:@"sign=" withString:@""];
            continue;
        }
    }

//    //商户服务器生成支付订单，先调用【统一下单API】生成预付单，获取到prepay_id后将参数再次签名传输给APP发起支付
//    PayReq *request = [[PayReq alloc] init];
//    /** 商家向财付通申请的商家id */
//    request.partnerId = dic[@"partnerid"];
//    /** 预支付订单 */
//    request.prepayId= dic[@"prepayid"];
//    /** 随机串，防重发 */
//    request.nonceStr= dic[@"noncestr"];
//    /** 时间戳，防重发 */
//    request.timeStamp = [dic[@"timestamp"] longValue];
//    /** 商家根据财付通文档填写的数据和签名 */
//    request.package = dic[@"package"];;
//    /** 商家根据微信开放平台文档对数据做的签名 */
//    request.sign= dic[@"sign"];
//
//    //发送请求到微信，等待微信返回onResp
//    //函数调用后，会切换到微信的界面。第三方应用程序等待微信返回onResp。微信在异步处理完成后一定会调用onResp。支持以下类型
//    //SendAuthReq、SendMessageToWXReq、PayReq等。
//    [WXApi sendReq:request completion:^(BOOL success) {
//    }];
    self.PaySuccessBlock =  completion;
#endif
    
}
/// 调起微信支付
/// @param pay_param 支付参数 json串
/// @param successBlock 成功
/// @param failBlock    失败
- (void)wx_payRequestWithPayParam:(NSString *)pay_param success:(PayComplete)successBlock failure:(PayComplete)failBlock {
    //解析结果
    NSData *data = [pay_param dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];

    if (error != nil) {
        self.PayFailBlock = failBlock;
        failBlock?failBlock(WXError_Param, @"微信支付参数错误", nil):Nil;
        return;
    }
    [self wx_payRequestWithPayDict:dict success:successBlock failure:failBlock];
}

/// 调起微信支付
/// @param dict 微信订单字典(全部由后台拼接好给iOS端)
/// @param successBlock 成功
/// @param failBlock    失败
- (void)wx_payRequestWithPayDict:(NSDictionary *)dict success:(PayComplete)successBlock failure:(PayComplete)failBlock {
    self.PaySuccessBlock = successBlock;
    self.PayFailBlock = failBlock;

#if HasWXApi
    //1. 判断是否安装微信 (检查微信是否已被用户安装)
    if (![WXApi isWXAppInstalled]) {
        NSLog(@"您尚未安装\"微信App\",请先安装后再返回支付");
        NSLog(@"(微信)该支付渠道暂时无法使用");
        return;
    }

    //2.判断微信的版本是否支持最新Api(判断当前微信的版本是否支持OpenApi)
    if (![WXApi isWXAppSupportApi]) {
        NSLog(@"您微信当前版本不支持此功能,请先升级微信应用");
        return;
    }

    if (dict) {
//        //调起微信支付
//        PayReq *req = [[PayReq alloc] init];
//        //由用户微信号和AppID组成的唯一标识，需要校验微信用户是否换号登录时填写
//        req.openID = dict[@"appid"];
//        //商家向财付通申请的商家id
//        req.partnerId = dict[@"partnerid"];
//        //预支付订单
//        req.prepayId = dict[@"prepayid"];
//        //随机串，防重发
//        req.nonceStr = dict[@"noncestr"];
//        //时间戳，防重发
//        req.timeStamp = [dict[@"timestamp"] intValue];
//        //商家根据财付通文档填写的数据和签名
//        req.package = @"Sign=WXPay";
//        //商家根据微信开放平台文档对数据做的签名
//        req.sign = dict[@"sign"];
//        //发送请求到微信，等待微信返回onResp
//        [WXApi sendReq:req completion:^(BOOL success) {
//        }];
//        //日志输出
//        NSLog(@"微信支付参数：%@", dict);
    }
#endif
}

#pragma mark - 微信支付代理方法
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
//- (void)onReq:(BaseReq *)req {
//
//}

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp {
    
#if DEBUG
        NSLog(@"微信支付 错误码:%d  错误提示字符串:%@", resp.errCode, resp.errStr);
#endif

#if HasWXApi
    //回调中errCode值列表：
    // 0 成功 展示成功页面
    //-1 错误 可能的原因：签名错误、未注册APPID、项目设置APPID不正确、注册的APPID与设置的不匹配、其他异常等
    //-2 用户取消 无需处理。发生场景：用户不支付了，点击取消，返回APP

//    if ([resp isKindOfClass:[PayResp class]]){
//        // 支付返回结果,实际支付结果需要去微信服务器端查询
//        switch (resp.errCode) {
//            case WXSuccess: {// 成功
//                self.PaySuccessBlock?self.PaySuccessBlock(WXPaySuccess, @"微信支付成功", nil):Nil;
//                NSLog(@"微信支付成功－PaySuccess，retcode = %d", resp.errCode);
//                break;
//            }
//            case WXErrCodeUserCancel: {//用户点击取消并返回
//                self.PayFailBlock?self.PayFailBlock(WXPayCancel, @"微信支付用户点击取消并返回", nil):Nil;
//                NSLog(@"微信支付取消－PayCancel，retcode = %d", resp.errCode);
//                break;
//            }
//
//            default:{ //剩余都是支付失败
//                self.PayFailBlock?self.PayFailBlock(WXPayFail, @"微信支付失败", nil):Nil;
//                NSLog(@"微信支付失败 错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
//                break;
//            }
//        }
//    }
#endif
}

#pragma mark - 支付宝  支付宝不需要 注册
///// 支付宝支付
//- (void)alipay_payRequestWithJsonStr:(NSString *)jsonStr alipayScheme:(NSString *)alipayScheme success:(PayComplete)successBlock failure:(PayComplete)failBlock {
//    //注：若公司服务器返回的json串可以直接使用，就不用下面的json解析了
//    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
//    NSError *err = nil;
//    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
//    if (err) {
//        self.PayFailBlock = failBlock;
//        self.PayFailBlock?self.PayFailBlock(AlipayPay_Param, @"json解析失败", nil):Nil;
//        NSLog(@"json解析失败：%@",err);
//    }
//    NSString *orderSS = [NSString stringWithFormat:@"app_id=%@&biz_content=%@&charset=%@&method=%@&sign_type=%@&timestamp=%@&version=%@&format=%@&notify_url=%@",dic[@"app_id"],dic[@"biz_content"],dic[@"charset"],dic[@"method"],dic[@"sign_type"],dic[@"timestamp"],dic[@"version"],dic[@"format"],dic[@"notify_url"]];
//
//    NSString *signedStr = [self urlEncodedString:dic[@"sign"]];
//    NSString *orderString = [NSString stringWithFormat:@"%@&sign=%@",orderSS, signedStr];
////    MJLog(@"===%@",orderSS);
//
//    [self alipay_payRequestWithOrderStr:orderString alipayScheme:alipayScheme success:successBlock failure:failBlock];
//}
////url 加密
//- (NSString*)urlEncodedString:(NSString *)string {
//    NSString * encodedString = (__bridge_transfer  NSString*) CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, NULL, (__bridge CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8 );
//
//    return encodedString;
//}

/// 支付宝支付 发起支付请求/调用支付结果开始支付    支付宝不需要 注册
- (void)alipay_payRequestWithOrderStr:(NSString *)orderStr alipayScheme:(NSString *)alipayScheme success:(PayComplete)successBlock failure:(PayComplete)failBlock {
    self.PaySuccessBlock = successBlock;
    self.PayFailBlock = failBlock;

#if HasAlipaySDK
    __weak __typeof(self)weakSelf = self;
    [[AlipaySDK defaultService] payOrder:orderStr fromScheme:alipayScheme callback:^(NSDictionary *resultDic) {
        __strong __typeof(weakSelf)strongSelf = weakSelf;
        [strongSelf aliPay_payResultHandle:resultDic];//支付宝支付结果处理
    }];
#endif
}

#pragma mark - 支付宝支付结果处理
//支付宝支付结果处理
- (void)aliPay_payResultHandle:(NSDictionary *)resultDic {
#if DEBUG
    NSLog(@"支付宝支付结果：%@",resultDic[@"memo"]);
#endif
    // 返回结果需要通过 resultStatus 以及 result 字段的值来综合判断并确定支付结果。 在 resultStatus=9000,并且 success="true"以及 sign="xxx"校验通过的情况下,证明支付成功。其它情况归为失败。较低安全级别的场合,也可以只通过检查 resultStatus 以及 success="true"来判定支付结果
    NSInteger resultStatus = [resultDic[@"resultStatus"] integerValue];
    if (resultDic && [resultDic objectForKey:@"resultStatus"]) {
        switch (resultStatus) {
            case 9000:
                self.PaySuccessBlock?self.PaySuccessBlock(AlipayPaySuccess, @"支付宝支付成功", nil):Nil;
                NSLog(@"支付结果,支付宝支付成功");
                break;
//            case 8000:
//                self.PayFailBlock?self.PayFailBlock(AlipayPayError, @"支付宝支付正在处理中", nil):Nil;
//                NSLog(@"支付结果,支付宝支付正在处理中");
//                break;
//            case 4000:
//                self.PayFailBlock?self.PayFailBlock(AlipayPayError, @"支付宝支付订单支付失败,请稍后再试", nil):Nil;
//                NSLog(@"支付结果,支付宝支付订单支付失败,请稍后再试");
//                break;
            case 6001:
                self.PayFailBlock?self.PayFailBlock(AlipayPayCancel, @"支付宝支付已取消支付", nil):Nil;
                NSLog(@"支付结果,支付宝支付已取消支付");
                break;
//            case 6002:
//                self.PayFailBlock?self.PayFailBlock(AlipayPayError, @"支付宝支付网络连接错误,请稍后再试", nil):Nil;
//                NSLog(@"支付结果,支付宝支付网络连接错误,请稍后再试");
//                break;
            default:
                self.PayFailBlock?self.PayFailBlock(AlipayPayError, @"支付宝支付错误", nil):Nil;
                NSLog(@"支付结果,支付宝支付错误");
                break;
        }
    }
}

#pragma mark - 微信、支付宝支付回调
+ (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [[LSPayTools sharedInstance] WX_Alipay_payCallBackHandleOpenURL:url];
}
// NOTE: 9.0以后使用新API接口
+ (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options{
    return [[LSPayTools sharedInstance] WX_Alipay_payCallBackHandleOpenURL:url];
}
+ (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler{
#if HasWXApi
    return [WXApi handleOpenUniversalLink:userActivity delegate:[LSPayTools sharedInstance]];
#endif
}


///微信、支付宝支付回调处理
- (BOOL)WX_Alipay_payCallBackHandleOpenURL:(NSURL *)url {
#if HasAlipaySDK
    if ([url.host isEqualToString:@"safepay"]) {
        __weak __typeof(self)weakSelf = self;
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
             //【由于在跳转支付宝客户端支付的过程中，商户app在后台很可能被系统kill了，所以pay接口的callback就会失效，请商户对standbyCallback返回的回调结果进行处理,就是在这个方法里面处理跟callback一样的逻辑】
            [strongSelf aliPay_payResultHandle:resultDic];//支付宝支付结果处理
        }];

        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝支付 result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            MJLog(@"支付宝支付授权结果 authCode = %@", authCode?:@"");
        }];
        return YES;
    }
#endif
#if HasWXApi
    return [WXApi handleOpenURL:url delegate:self]; //([url.host isEqualToString:@"pay"]) //微信支付
#endif
}

#pragma mark - 苹果支付 内购

/// 开启内购监听 在程序入口 didFinsihLaunchingWithOptions 实现
/// 在didFinsihLaunchingWithOptions调用此方法,会先检测一遍有没有未校验的订单, >>>
///     >>>如果有未校验的订单会走这个方法:<- (void)paymentQueue:updatedTransactions:>,走到交易完成(Purchased)的回调,
- (void)IAP_startManagerObserver {
    dispatch_sync(iap_queue(), ^{
        if ([SKPaymentQueue defaultQueue]) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        }
    });
}
/// 停止内购监听 在AppDelegate.m中的applicationWillTerminate方法实现
- (void)IAP_stopManagerObserver {
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        if ([SKPaymentQueue defaultQueue]) {
            [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
        }
    });
}


/// 拉起内购支付
/// @param productId productId
/// @param successBlock 成功的回调
/// @param failBolck 失败的回调
- (void)IAP_requestProductId:(NSString *)productId success:(PayComplete)successBlock failure:(PayComplete)failBolck {

//    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];

    self.product_Id = productId;
    self.PaySuccessBlock = successBlock;
    self.PayFailBlock = failBolck;

   //移除上次未完成的交易订单XXXXXXXX      不能移除，移除的话,没有校验的订单会不见了，就丢单了,
//    [self removeAllUncompleteTransactionBeforeStartNewTransaction];
    
    [self removeIAPArrayObjectWithTime:30*24*3600];//删除，保存超过30天的订单数据

    // 最好设置上
//    [MBProgressHUD qucickTip:@"正在连接苹果商店…"];
    [MBProgressHUD showMessage:@"正在连接苹果商店…"];

    if (!productId || productId.length == 0) { //if (productId && productId.length > 0) {
        NSLog(@"内购项目ID错误, 为%@", productId);
        self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"内购项目ID错误", nil):Nil;
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"没有对应的商品" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }

    if ([SKPaymentQueue canMakePayments]) {// 允许内购
        NSLog(@"允许程序内付费购买");
        [self requestProductInfo:productId];//// 请求对应的产品信息
    } else {
        NSLog(@"不允许程序内付费购买");
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请先开启应用内付费购买功能。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
//        //用户未开启内购，弹框提示
//        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"内购未开启" message:@"进入“【设置】 - 开启【屏幕使用时间】功能。然后在【屏幕使用时间】选项中选择【内容和隐私访问限制】，选择【iTunes Store 与 App store 购买】- 选择【App内购项目】- 选择“允许”，将该功能开启" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
//        [alertView show];
        self.PayFailBlock?self.PayFailBlock(AppStore_Unsupport, @"不允许程序内付费购买", nil):Nil;
    }
}

#pragma mark -- 结束上次未完成的交易 防止串单
// 每次成功，都调用[[SKPaymentQueue defaultQueue] finishTransaction:trans];结束当前交易，就不会串单
/// 结束上次未完成的交易 防止串单 (不能移除，移除的话,没有校验的订单会不见了，就丢单了)
- (void)removeAllUncompleteTransactionBeforeStartNewTransaction {

    //以下方法中存储着未完成的单
    NSArray *transactions = [SKPaymentQueue defaultQueue].transactions;//好像这个数组里面只能存两条未完成的订单
    if (transactions.count > 0) {
        //监测是否有未完成的交易
//        SKPaymentTransaction *trans = [transactions firstObject];
//        if (trans.transactionState == SKPaymentTransactionStatePurchased) {
//            [[SKPaymentQueue defaultQueue] finishTransaction:trans];
//            return;
//        } else {
//                 SKPayment *payment = [SKPayment paymentWithProduct:requestProduct];
//                  [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
//                  [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
//                  [[SKPaymentQueue defaultQueue] addPayment:payment];
//         }
NSLog(@"🔥🔥🔥🔥🔥🔥🔥有历史未消耗订单 %ld🔥🔥🔥🔥🔥🔥🔥🔥", transactions.count);

        for (int i = 0; i < transactions.count; i++) {
            SKPaymentTransaction *trans = [transactions objectAtIndex:i];
            //Purchased:交易完成
            //Restored:已经购买过该商品
            if (trans.transactionState == SKPaymentTransactionStatePurchased ||
                trans.transactionState == SKPaymentTransactionStateRestored) {
                [[SKPaymentQueue defaultQueue] finishTransaction:trans];
            }
        }
        [self removeIAPArrayAllObject];//删除保存的所有的对象
        [self removeIAPDictAllObject];//删除所有保存的票据记录
    } else {
        NSLog(@"没有历史未消耗订单");
    }
}

#pragma mark -- 发起购买请求
/// 发起购买请求          请求对应的产品信息 获取内购项目信息
- (void)requestProductInfo:(NSString *)productId {
    NSLog(@"---------请求对应的产品信息------------");
    NSSet *productSet = [NSSet setWithObjects:productId, nil];
    SKProductsRequest *request = [[SKProductsRequest alloc] initWithProductIdentifiers:productSet];
    request.delegate = self;
    [request start];//发起购买请求
}


#pragma mark -- SKProductsRequestDelegate 请求协议  查询成功后的回调
/// 通过苹果内购回调函数去处理    收到产品返回信息
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response {
    NSLog(@"-----------收到产品反馈信息--------------");
    NSArray *productArr = response.products;//// 商品数组
    if (productArr.count == 0) {// 如果服务器没有产品
        NSLog(@"没有商品");
        [MBProgressHUD hideAllHuds];
        [MBProgressHUD showError:@"没有商品信息"];
        self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"无法获取产品信息,购买失败", nil):Nil;
        return;
    }

    NSLog(@"产品 productId：%@",response.invalidProductIdentifiers);
    NSLog(@"付费产品数量：%zd",productArr.count);

    SKProduct *product = nil;
    

    for (SKProduct *pro in productArr) {
        NSLog(@"产品(商品)信息");
        NSLog(@"SKProduct 描述信息%@", [pro description]);
        NSLog(@"产品标题 %@" , pro.localizedTitle);
        NSLog(@"产品描述信息: %@" , pro.localizedDescription);
        NSLog(@"价格: %@" , pro.price);
        NSLog(@"Product id: %@" , pro.productIdentifier);

        // 11. 如果后台消费条目的ID与我这里需要的请求的一样（用于确保订单的正确性）
        if ([pro.productIdentifier isEqualToString:self.product_Id]) {
            product = pro;//对应的产品
            break;
        }
    }

    if (!product) {
        NSLog(@"没有此商品");
        [MBProgressHUD showError:@"没有此商品"];
        self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"没有此商品", nil):Nil;
        return;
    }
    // product.introductoryPrice：产品折扣价
    if (product.price) { //对应的产品价格
        // 传递过来的价格，
        NSDecimalNumber *product_tranAmt = [NSDecimalNumber decimalNumberWithString:self.tranAmt locale:product.priceLocale];
        NSDecimalNumber *multiply_ = [NSDecimalNumber decimalNumberWithString:@"100"];
        // 乘       x100
        NSDecimalNumber *product_price_multiply = [product.price decimalNumberByMultiplyingBy:multiply_];
        
        //传递过来的价格 和 苹果返回的产品价格不一样
        if (product_price_multiply != product_tranAmt) {
            NSLog(@"传递过来的价格 和 苹果返回的产品价格不一样");
            NSLog(@"产品(商品)价格有变动，请登录开发者账号进行查看");
            [MBProgressHUD showError:@"传递过来的价格 和 苹果返回的产品价格不一样"];
            
//            self.PayFailBlock?self.PayFailBlock(AppStorePayError_ProductPriceChange, @"产品(商品)价格有变动,购买失败", nil):Nil;
            self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"产品(商品)价格有变动,购买失败", nil):Nil;
            return;
        }
    }
    

    NSLog(@"---------发送购买请求------------");
    //发起内购请求
//    SKPayment *payment = [SKPayment paymentWithProduct:product];
////    payment = [SKPayment paymentWithProductIdentifier:self.productId];
//    [[SKPaymentQueue defaultQueue] addPayment:payment];

    
//    SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
//    //使用苹果提供的属性,将平台订单号复制给这个属性作为透传参数
//    payment.applicationUsername = self.orderNo;//内购透传参数 ,与transaction一一对应
//    [[SKPaymentQueue defaultQueue] addPayment:payment];
    
    [self buyProduct:product];
}

/*解决掉单的问题:
 1.将需要传给后台服务器的参数（比如订单id，用户id,等参数）放到SKMutablePayment的applicationUsername字段里面；
  在监听到交易完成的回调的时候可以从transaction.payment.applicationUsername里面获取之前存入的参数
 */
-(void)buyProduct:(SKProduct *)product{
    // 1.创建票据
    NSString *userId = self.user_id;
    NSString *orderNo = self.traderOrderNo;
    
    NSString *userName = [NSString stringWithFormat:@"%@-%@",userId,orderNo];
    SKMutablePayment *skpayment = [SKMutablePayment paymentWithProduct:product];
    skpayment.applicationUsername = userName;
    
    // 2.将票据加入到交易队列
    [[SKPaymentQueue defaultQueue] addPayment:skpayment];
}


//查询失败后的回调
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    NSLog(@"-------弹出错误信息-----%@-----", error);
    [MBProgressHUD hideAllHuds];
    [MBProgressHUD qucickTip:error.localizedDescription?:@"无法获取产品信息"];
    self.PayFailBlock?self.PayFailBlock(AppStorePayError, error.localizedDescription?:@"无法获取产品信息", nil):Nil;
}
//如果没有设置监听购买结果将直接跳至反馈结束；
- (void)requestDidFinish:(SKRequest *)request {
    NSLog(@"----------信息反馈结束--------------");
}


//- (void)PurchasedTransaction:(SKPaymentTransaction *)transaction{
//    NSLog(@"-----PurchasedTransaction 购买交易 ----");
//    NSArray *transactions =[[NSArray alloc] initWithObjects:transaction, nil];
//    [self paymentQueue:[SKPaymentQueue defaultQueue] updatedTransactions:transactions];
//}


///
/// ！！！！！App Store 促销开发(https://juejin.cn/post/7229151797415575610)！！！！！！！
///// 当用户从应用商店发起IAP购买时发送
///// 当用户在App Store中开始应用程序内购买，并且交易在您的应用程序中继续时，会调用此委托方法。具体来说，如果您的应用程序已经安装，则会自动调用该方法。
///// 如果用户在App Store中开始应用程序内购买时尚未安装您的应用程序，则用户将在应用程序安装完成后收到通知。当用户点击通知时，会调用此方法。否则，如果用户手动打开应用程序，则仅在购买开始后不久打开应用程序时调用此方法。
///这个方法会返回商品信息,返回值 YES 则交给苹果处理该订单,直接调起支付流程,
///如果返回 NO 的话,则不会调起支付流程,在里面我们可以增加自己的一些逻辑代码,比如判断当前用户是否已经登录了等等操作
//- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
// NSLog(@"AppStore 从促销点击购买处理");
//    NSLog(@"商品信息 :%@", product);
// 直接返回 NO,不交给苹果处理
//    NSString *productID = product.productIdentifier;
//    NSLog(@"AppStore 促销点击购买: productIdentifier - %@", productID);
//
//    // 记录当前事件
//    [APPDELEGATE.appReqTools dealAppStoreBuyWithProductID:productID];
//    // 判断当前是否登录
//    BOOL result = [LBLoginHandler checkLogin];
//    if (result == YES) {
//        // 当前已登录直接处理
//        NSLog(@"当前已登录,直接处理当前事件");
//        [APPDELEGATE.appReqTools dealAllEvent];;
//    } else {
//        // 当前未登录
//        NSLog(@"当前未登录,待登录成功后,处理跳转购买会员页面");
//    }
//
//    return NO;
//    // 这样就完成了 AppStore 内购促销开发
//}


#pragma mark -- 监听结果
//判断交易状态：
//<SKPaymentTransactionObserver> 千万不要忘记绑定，代码如下：
//----监听购买结果
//[[SKPaymentQueue defaultQueue] addTransactionObserver:self];
// 监听购买结果
//SKPaymentTransactionObserver
//实现观察者监听付钱的代理方法,只要交易发生变化就会走下面的方法
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    /*
      SKPaymentTransactionStatePurchasing,    正在购买
      SKPaymentTransactionStatePurchased,     已经购买
      SKPaymentTransactionStateFailed,        购买失败
      SKPaymentTransactionStateRestored,      回复购买中
      SKPaymentTransactionStateDeferred       交易还在队列里面，但最终状态还没有决定
      */
    //当用户购买的操作有结果时，就会触发下面的回调函数，
   // 验证成功与否都注销交易,否则会出现虚假凭证信息一直验证不通过,每次进程序都得输入苹果账号
//    NSLog(@"-----paymentQueue 付款队列 --------");
    for (SKPaymentTransaction *trans in transactions) {
        switch (trans.transactionState) {
            case SKPaymentTransactionStatePurchasing: { //商品添加进列表
                NSLog(@"-----商品添加进列表 --------");
                NSLog(@"正在购买中...");
                //解决applicationUsername支付一半kill进程后为nil的问题
//                [self saveCurrentTransationBindedOrderNo];
            }
                break;
            case SKPaymentTransactionStatePurchased: { //交易完成
                NSLog(@"-----交易完成 --------");
                NSLog(@"购买完成，向自己的服务器验证------ %@", trans.payment.applicationUsername);
                
//                //这里可以做一个是否同一用户的判断，因为如果是更新数据时产生的订单，跟下单时的用户未必是同一个用户
//                //isLogin:是否登录状态； userId：该订单的用户id；currentUserId:当前登录用户的id；
//                NSArray *arr = [trans.payment.applicationUsername componentsSeparatedByString:@"-"];
//                NSString *userId = @"";
//                if (arr.count>0) {
//                    userId = arr[0];
//                }
//                if (isLogin && [currentUserId isEqualToString: userId]) {
                    
                    //[self completedTransactionGoOnLocalVerify:transaction]; // 本地校验交易凭据
                    [self completeTransactionGoOnBackgroundServerVerify:trans];// 后台服务器校验App Store交易凭据
//                }
            }
                break;
            case SKPaymentTransactionStateFailed: { //交易失败
                NSLog(@"-----交易失败 --------");
                [self failedTransaction:trans];//处理失败逻辑
            }
                break;
            case SKPaymentTransactionStateRestored: {//已经购买过该商品
                NSLog(@"-----已经购买过该商品 --------");
                [MBProgressHUD hideAllHuds];
                
//将当前用户已完成的事务添加回要重新完成的队列。将要求用户进行身份验证。
//成功时，观察者将收到0个或多个-paymentQueue:updatedTransactions:，
//然后是-paymentQueue RestoreCompletedTransactionsFinished:，
//失败时将收到-paymentQueue:restoreCompletedTransaction FailedWithError:。
//在部分成功的情况下，一些交易可能仍然可以交付。
//                [queue restoreCompletedTransactions];//
//                [queue restoreCompletedTransactionsWithApplicationUsername:@""];
                
                
                
                [self restoreTransaction:trans];
//                [[SKPaymentQueue defaultQueue] finishTransaction:tran]; //消耗型商品不用写
            }
                break;
            case SKPaymentTransactionStateDeferred:{
                NSLog(@"交易还在队列里面，最终状态未确定");
            }
                break;
            default:
                NSLog(@"内购结果，不在列出的选项中...");
                break;
        }
    }
}

//持久化 当前正在交易绑定的业务订单
- (void)saveCurrentTransationBindedOrderNo {
    NSLog(@"商品添加进列表");
    if (!self.traderOrderNo) {
        NSLog(@"订单编号OrderNo 为空");
        return;
    }
    NSDictionary *orderDict = @{
        @"productId":self.product_Id,
        @"orderNo":self.traderOrderNo
    };

    [[NSUserDefaults standardUserDefaults] setObject:orderDict forKey:@"persient.IAP.order"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString *)bindedOrderNo {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"persient.IAP.order"];
    if (dict) {
        return dict[@"orderNo"];
    }
    return nil;
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    NSLog(@"内购_当事务从队列中删除时发送");
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    NSLog(@"内购_将用户的购买历史记录中的交易添加回队列时遇到错误时发送。%@", error);
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"内购_当用户购买历史记录中的所有交易都已成功添加回队列时发送。");
}
// Sent when the download state has changed.
- (void)paymentQueue:(SKPaymentQueue *)queue updatedDownloads:(NSArray<SKDownload *> *)downloads {
    NSLog(@"内购_下载状态更改时发送。");
}
// Sent when a user initiates an IAP buy from the App Store
- (BOOL)paymentQueue:(SKPaymentQueue *)queue shouldAddStorePayment:(SKPayment *)payment forProduct:(SKProduct *)product {
    NSLog(@"内购_当用户从应用商店发起IAP购买时发送");
    return YES;
}

- (void)paymentQueueDidChangeStorefront:(SKPaymentQueue *)queue {
    NSLog(@"内购_付款队列更改之前。");
}
// Sent when entitlements for a user have changed and access to the specified IAPs has been revoked.
- (void)paymentQueue:(SKPaymentQueue *)queue didRevokeEntitlementsForProductIdentifiers:(NSArray<NSString *> *)productIdentifiers {
    NSLog(@"内购_当用户的权限发生更改并且对指定IAP的访问被吊销时发送。");
}

// Sent when the storefront changes while a payment is processing.
- (BOOL)paymentQueue:(SKPaymentQueue *)paymentQueue shouldContinueTransaction:(SKPaymentTransaction *)transaction inStorefront:(SKStorefront *)newStorefront  {
   
    NSLog(@"在处理付款时店面发生更改时发送。");
    return YES;
}

// Sent if there is a pending price consent confirmation from the App Store for the current user. Return YES to immediately show the price consent UI. Return NO if you intend to show it at a later time. Defaults to YES.
// This may be called at any time that you have transaction observers on the payment queue, so make sure to set the delegate before adding any transaction observers if you intend to implement this method.
- (BOOL)paymentQueueShouldShowPriceConsent:(SKPaymentQueue *)paymentQueue {
   //如果应用商店对当前用户有待定的价格同意确认，则发送。返回YES，立即显示价格同意界面。如果您打算稍后显示，请返回“否”。默认为YES。
    //如果您在支付队列中有交易观察员，则可以随时调用此方法，因此如果您打算实现此方法，请确保在添加任何交易观察员之前设置委托。
    
    NSLog(@"如果应用商店对当前用户有待定的价格同意确认，则发送。返回YES.");
    return YES;
}


#pragma mark -- 交易完成的回调
#pragma mark -- -- 后台服务器端验证App Store票据  -- --
/*
 //该方法为监听内购交易结果的回调
 - (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions
 transactions 为一个数组 遍历就可以得到 SKPaymentTransaction 对象的元素transaction。然后从transaction里可以取到以下这两个个参数，product_id，transaction_id。另外从沙盒里取到票据信息receipt_data
 我们先看怎么取到以上的三个参数
 //获取receipt_data
 NSData *data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] appStoreReceiptURL] path]];
 NSString * receipt_data = [data base64EncodedStringWithOptions:0];
 //获取product_id
 NSString *product_id = transaction.payment.productIdentifier;
 //获取transaction_id
 NSString * transaction_id = transaction.transactionIdentifier;
 */
/// 收到支付成功后把订单号和交易凭证抛给后台：
/// @param: 后台服务器端验证App Store票据（为了安全，需要自己服务器验证App Store票据）
/// @param: 注意：字符串：@"{"receipt-data" : "%@"}"，服务器解码时，带上“receipt-data”字段，不然base64解码失败
/** 注意：这里之后可以不用自己去验证，直接调用自己服务器接口，让后台去APP Store 验证*/
/** 将App Store返回的交易凭据发送到后台服务器，由后台服务器验证，code==200，提示成功 */
// （14.）： 交易结束，当交易结束后还要后台服务器端去App Store上验证支付信息是否都正确，只有所有都正确后，我们就可以给用户发放我们的虚拟产品了。
- (void)completeTransactionGoOnBackgroundServerVerify:(SKPaymentTransaction *)transaction {
//    NSString *str = [[NSString alloc] initWithData:transaction.transactionReceipt encoding:NSUTF8StringEncoding];
    NSLog(@"------ 完成交易调用的方法 getApplePayDataToServerRequsetWith 1----------");
    // 获取设备端app的交易收据数据，使用NSBundle的方法定位app的收据，并用Base64编码。将此 Base64 编码数据发送到您的服务器。
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    if (!receiptData) {
        NSLog(@"没有交易收据");
//        return;
    }
    
    
//1. 在这里保存数据
  /*在appDelegate里面开启监听,如果有没有验证票据的订单存在,会直接走<updatedTransactions:>方法,到这里
    (1)上面的<appStoreReceiptURL>方法可以取到一条对应的未验证的票据 receiptData
    (2)transaction里面会有一条没有验证票据的数据信息,product_id，transaction_id
    (3)transaction.payment.applicationUsername可以取到对应的订单保存的透传参数
    (4)取出之前保存的数据(如果有,如果保存的数据里没有这条记录,把这条数据保存下来)，然后调用后台接口 验证票据
   
  */
//2.调用后台服务器接口 验证票据
//3. 成功方法里:移除对应的数据，返回成功

    //获取编码格式的收据
    NSString *receiptBase64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    // 注意：字符串：@"{\"receipt-data\" : \"%@\"}"，服务器解码时，带上“receipt-data”字段，不然base64解码失败

    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (!self.traderOrderNo) { //没有订单号，(代表是之前验签失败的订单,是程序启动时苹果api自动检测到未完成订单过来的)
        //苹果检测到的未完成订单
        //1.从applicationUsername拿到参数信息
        //2.读取自己保存的订单数据，根据订单号进行比对
        //3.1如果在自己保存的记录中找到对应的订单号,去服务器校验
        //3.2如果没有在自己保存的记录中找到对应的订单号,保存这条订单记录,然后去服务器校验
        //4.1 校验成功,从自己保存的数据中删除对应的数据,
        //4.2 校验失败,返回失败信息
        
//        NSDictionary *iap_dict = [self getIAPDictData];
//        NSLog(@"%@", iap_dict);
        NSArray *iap_array = [self getIAPArrayData];//保存的iap_订单数据
        NSLog(@"%@", iap_array);
        
//        NSString *userName = [NSString stringWithFormat:@"%@-%@-%@-%@-%@",userId,product_id, self.traderOrderNo, self.orderSendTime, self.tranAmt];

        //获取到前面放到applicationUsername里面的参数(订单号,userid,...等)
        NSArray *arr = [transaction.payment.applicationUsername componentsSeparatedByString:@"-"];
        self.traderOrderNo = @"";//self.traderOrderNo
        if (arr.count >= 4) {
            self.product_Id = arr[1];
            self.traderOrderNo = arr[2];
            self.orderSendTime = arr[3];
            self.tranAmt = arr[4];
        }
        for (int i = 0; i < iap_array.count; i++) {
            NSDictionary *temDic = iap_array[i];
            if ([temDic[@"traderOrderNo"] isEqualToString:self.traderOrderNo]) {
                dict = [NSMutableDictionary dictionaryWithDictionary:temDic];
                break;
            }
        }
        
        if (!dict[@"traderOrderNo"]) {//如果之前没有保存过这条数据
            // 提交服务器验证之前，保存数据
            dict[@"product_id"] = transaction.payment.productIdentifier;// 内购产品编号
            dict[@"transaction_id"] = transaction.transactionIdentifier;//交易编号
            dict[@"receipt_data"] = receiptBase64String;
            dict[@"traderOrderNo"] = self.traderOrderNo;//订单号
            dict[@"orderSendTime"] = self.orderSendTime;
            dict[@"tranAmt"] = self.tranAmt;//交易金额
            
            [self saveIAPArrayWithDict:dict];//保存到数组
        }
        
    } else {//有订单号，代表是正常流程下单过来的
        // 提交服务器验证之前，保存数据
        dict[@"product_id"] = transaction.payment.productIdentifier;// 内购产品编号
        dict[@"transaction_id"] = transaction.transactionIdentifier;//交易编号
        dict[@"receipt_data"] = receiptBase64String;
        dict[@"traderOrderNo"] = self.traderOrderNo;//订单号
        dict[@"orderSendTime"] = self.orderSendTime;
        dict[@"tranAmt"] = self.tranAmt;//交易金额
        
        [self saveIAPArrayWithDict:dict];//保存到数组
////        [self saveIAPDictWithTraderOrderNo:self.traderOrderNo dict:dict]//保存到字典
    }

    // 提交服务器验证
//    [OPNetClient paymentConfirm_AppleIPAPayWithTraderOrderNo:self.traderOrderNo orderSendTime:self.orderSendTime tranAmt:self.tranAmt productId:self.product_Id receiptData:dict[@"receipt_data"] transactionId:dict[@"transaction_id"] complete:^(id  _Nonnull response) {
//
//        NSLog(@"苹果支付确认成功：%@", response);
//        if (self.PaySuccessBlock) {
//            self.PaySuccessBlock(AppStorePaySuccess, @"内购交易成功", dict);
//        }
//
//        [self finishAndRemoveTransaction:transaction];//从队列中删除已完成（即失败或已完成）的事务。
//          //  内购交易成功， 根据订单号 删除保存的对应的数据
//        [self removeIAPArrayObjectWithTraderOrderNo:self.traderOrderNo];
////        [self removeIAPDictObjectWithTraderOrderNo:self.traderOrderNo];//
//
//    } failure:^(NSError * _Nonnull error) {
//        NSLog(@"苹果支付确认失败：：%@", error);
//        BEEFailToast(error.userInfo[NSLocalizedFailureReasonErrorKey]?:@"");
//    }];

}


//// 提交服务器验证之前，保存数据
//- (void)commitServerVerifyBeforSaveIAPArrayOrderDataWitTransaction:(SKPaymentTransaction *)transaction receiptBase64String:(NSString *)receiptBase64String {
//    //product_id：这个也不用解释 内购产品编号 你不传的话 服务器不知道你买的哪个订单
//    // transaction_id：这个是交易编号，是必须要传的。因为你要是防止越狱下内购被破解就必须要校验in_app这个参数。
//    //而这个参数的数组元素有可能为多个，你必须得找到一个唯一标示，才可以区分订单到底是那一笔。
//    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
//    dict[@"product_id"] = transaction.payment.productIdentifier;// 内购产品编号
//    dict[@"transaction_id"] = transaction.transactionIdentifier;//交易编号
//    dict[@"receipt_data"] = receiptBase64String;
//    dict[@"traderOrderNo"] = self.traderOrderNo;//订单号
//    dict[@"orderSendTime"] = self.orderSendTime;
//    dict[@"tranAmt"] = self.tranAmt;//交易金额
//
//    [self saveIAPArrayWithDict:dict];//保存
//}


#pragma mark - 保存票据、订单信息
// TODO: - 将 票据,订单信息 整体作为array的一个元素放入数组保存
/// 将票据、订单信息数据加入数组    保存到钥匙串中
- (void)saveIAPArrayWithDict:(NSMutableDictionary *)dict {
    NSMutableArray *iap_dataArray = [self getIAPArrayData].mutableCopy;
    if (!iap_dataArray) {
        iap_dataArray = [NSMutableArray array];
    }
    if (![iap_dataArray containsObject:dict]) {
        [iap_dataArray addObject:dict];
        NSData *new_data = [iap_dataArray modelToJSONData];
        [UICKeyChainStore setData:new_data forKey:@"apple.iap.pay.array.hyh"];
    }
}
/// 从钥匙串中拿到保存票据、订单信息 数据的数组
- (NSArray *)getIAPArrayData {
    NSData *iap_data = [UICKeyChainStore dataForKey:@"apple.iap.pay.array.hyh"];
    NSArray *iap_dataArray = [iap_data jsonValueDecoded];
    return iap_dataArray;
}
/// 从钥匙串中保存票据、订单信息 数据的数组 中 根据订单号 删除对应的 数据
- (void)removeIAPArrayObjectWithTraderOrderNo:(NSString *)traderOrderNo {
    NSMutableArray *iap_dataArray = [self getIAPArrayData].mutableCopy;
    [iap_dataArray enumerateObjectsUsingBlock:^(NSMutableDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj[@"traderOrderNo"] == traderOrderNo) {
            [iap_dataArray removeObject:obj];
            *stop = YES;
        }
    }];
    NSData *new_data = [iap_dataArray modelToJSONData];
    [UICKeyChainStore setData:new_data forKey:@"apple.iap.pay.array.hyh"];
}
/// 删除钥匙串中保存票据、订单信息 数据的数组所有的对象
- (void)removeIAPArrayAllObject {
    NSMutableArray *iap_dataArray = [self getIAPArrayData].mutableCopy;
    
    [iap_dataArray removeAllObjects];
    NSData *new_data = [iap_dataArray modelToJSONData];
    [UICKeyChainStore setData:new_data forKey:@"apple.iap.pay.array.hyh"];
}
/// 根据过期时间删除保存的数据，overtime：超出时间：秒
- (void)removeIAPArrayObjectWithTime:(NSInteger)overtime {
    
    NSMutableArray *iap_dataArray = [self getIAPArrayData].mutableCopy;
    
//    for (NSDictionary *dict in [iap_dataArray reverseObjectEnumerator]) {
//        //订单发送时间
//       long long orderSendTime = [self ls_timeStampFromDateString:dict[@"orderSendTime"] withFormat:@"yyyyMMddHHmmss"];
//        long long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
//        if (currentTimeStamp - orderSendTime >= overtime) {
//            [iap_dataArray removeObject:dict];
//        }
//    }
    [iap_dataArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //订单发送时间
        NSDictionary *dict = obj;
       long long orderSendTime = [self ls_timeStampFromDateString:dict[@"orderSendTime"] withFormat:@"yyyyMMddHHmmss"];
        long long currentTimeStamp = [[NSDate date] timeIntervalSince1970];
        if (currentTimeStamp - orderSendTime >= overtime) {
            [iap_dataArray removeObject:dict];
            NSLog(@"删除成功%@", dict[@"traderOrderNo"]);
        }
    }];
    NSData *new_data = [iap_dataArray modelToJSONData];
    [UICKeyChainStore setData:new_data forKey:@"apple.iap.pay.array.hyh"];
}
/// 将时间转换为时间戳
- (long long)ls_timeStampFromDateString:(NSString *)dateString withFormat:(NSString *)format {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:format];
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [dateFormatter setTimeZone:localTimeZone];
    NSDate *dateFormatted = [dateFormatter dateFromString:dateString];
    ///时间戳    毫秒
    long long timeStamp = (long)[dateFormatted timeIntervalSince1970];
    return timeStamp;
}

// TODO: - 将订单号作为key值,票据,订单信息作为value值，加入字典，保存
/// 将票据、订单信息数据加入字典    保存到钥匙串中
- (void)saveIAPDictWithTraderOrderNo:(NSString *)traderOrderNo dict:(NSMutableDictionary *)dict {
    NSMutableDictionary *iap_dict = [self getIAPDictData].mutableCopy;
    if (!iap_dict) {
        iap_dict = [NSMutableDictionary dictionary];
    }
    if (traderOrderNo) {
        iap_dict[traderOrderNo] = dict;
    }
    NSData *new_data = [iap_dict modelToJSONData];
    [UICKeyChainStore setData:new_data forKey:@"apple.iap.pay.dict.hyh"];
}
/// 从钥匙串中拿到保存票据、订单信息 数据的字典
- (NSDictionary *)getIAPDictData {
    NSData *iap_data = [UICKeyChainStore dataForKey:@"apple.iap.pay.dict.hyh"];
    NSDictionary *iap_dataDict = [iap_data jsonValueDecoded];
    return iap_dataDict;
}
/// 从钥匙串中保存票据、订单信息 数据的字典 中 根据订单号 删除对应的 数据
- (void)removeIAPDictObjectWithTraderOrderNo:(NSString *)traderOrderNo {
    NSMutableDictionary *iap_dict = [self getIAPDictData].mutableCopy;
    iap_dict[traderOrderNo] = nil;
    NSData *new_data = [iap_dict modelToJSONData];
    [UICKeyChainStore setData:new_data forKey:@"apple.iap.pay.dict.hyh"];
}
/// 删除钥匙串中保存票据、订单信息 数据的字典所有的对象
- (void)removeIAPDictAllObject {
    NSMutableDictionary *iap_dict = [self getIAPDictData].mutableCopy;
    [iap_dict removeAllObjects];
    NSData *new_data = [iap_dict modelToJSONData];
    [UICKeyChainStore setData:new_data forKey:@"apple.iap.pay.dict.hyh"];
}
/**
 
 21000: 未使用HTTP POST请求方法向App Store发送请求。
 21001: 此状态代码不再由App Store发送。
 21002: receipt-data属性中的数据格式错误，或者服务遇到了临时问题。再试一次。
 21003: 收据无法认证。
 21004: 您提供的共享密钥与您帐户的文件共享密钥不匹配。
 21005: 收据服务器暂时无法提供收据。再试一次。
 21006：  该收据有效，但订阅已过期。当此状态码返回到您的服务器时，收据数据也会被解码并作为响应的一部分返回。仅针对自动续订的iOS 6样式的交易收据返回。
 21007: 该收据来自测试环境，但是已发送到生产环境以进行验证。
 21008：  该收据来自生产环境，但是已发送到测试环境以进行验证。
 21009：  内部数据访问错误。稍后再试。
 21010: 找不到或删除了该用户帐户。
 ————————————————
 原文链接：https://blog.csdn.net/qq1353424111/article/details/108714916
 */

#pragma mark - 苹果建议，先使用正式环境校验票据，如果验证失败，错误代码为‘Sandbox receipt used in production’,则应根据测试环境进行验证
#pragma mark - 先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
#pragma mark -- -- 本地验证 App Store票据  -- --
#pragma mark - 本地校验
/// 购买完成进行本地校验交易凭证（ 第二种，不需要服务器验证，自己在客户端验证，不安全，容易被破解，导致赚钱少哦）
- (void)completedTransactionGoOnLocalVerify:(SKPaymentTransaction *)transaction {
//这里要把SKPaymentTransaction整个对象给后台，记得携带订单号，先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
//正式环境：https://buy.itunes.apple.com/verifyReceipt
//沙箱环境：https://sandbox.itunes.apple.com/verifyReceipt

    NSLog(@"-----completeTransaction 交易完成 --------");
    NSLog(@"购买成功,准备验证发货");

    //获取购买凭证
//    NSString *productIdentifier = transaction.payment.productIdentifier;
//    NSLog(@"productId(产品 id)：%@", productIdentifier);
//    NSString *transactionReceiptString = nil;
    //系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptUrl=[[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
    NSString *receiptBase64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
//    NSLog(@"receiptBase64String == %@",receiptBase64String);
//    if ([productIdentifier length] <= 0) { //
//        self.PayFailBlock?self.PayFailBlock(AppStorePayError, transaction.error.localizedDescription?:@"", nil):Nil;
//        [self finishAndRemoveTransaction:transaction];//
//        return;
//    }
//
//    //        self.hud.labelText = @"正在验证,请勿离开...";
//    // 请求自己的服务器去验证用户购买结果
//    // 往后台验证,只有服务器有反应就hide
//    //        [MBProgressHUD hideAllHUDsForView:kKeyWindow animated:YES];
//
//    NSArray *tt = [productIdentifier componentsSeparatedByString:@"."];
//    NSString *bookid = [tt lastObject];
//    if ([bookid length] > 0) {
//        [self recordTransaction:bookid];
//        [self provideContent:bookid];
//    }
//
//    NSLog(@"正在验证,请勿离开...");
//    NSDictionary *params = @{@"receiptData":receiptData,
//                           @"orderNo":transaction.transactionIdentifier};
//    self.PaySuccessBlock?self.PaySuccessBlock(AppStorePaySuccess, @"苹果内购支付成功", params):Nil;
//    [self finishAndRemoveTransaction:transaction];


//根据存储凭证存储Order
    if (self.traderOrderNo) {
        [self localVerify_saveOrderNoByInAppPurchase:transaction receiptDataBase64String:receiptBase64String];
    }

// 获取购买凭证并且发送服务器验证
    [self localVerify_getAndSaveReceipt:transaction];//获取交易成功后的购买凭证
}

#pragma mark - 存储订单，防止走漏单流程时获取不到OrderNo, 且苹果返回的OrderNo为nil
- (void)localVerify_saveOrderNoByInAppPurchase:(SKPaymentTransaction *)transaction receiptDataBase64String:(NSString *)receiptDataBase64String {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *orderNo = self.traderOrderNo;
    NSString *savePath = [NSString stringWithFormat:@"%@/%@.plist", tempOrderPath, orderNo];

    [dict setValue:orderNo forKey:transaction.transactionIdentifier];//交易编号
    
    dict[@"receipt_data"] = receiptDataBase64String;
    dict[@"product_id"] = transaction.payment.productIdentifier;//内购产品编号
    dict[@"transaction_id"] = transaction.transactionIdentifier;//交易编号
    
    BOOL ifWriteSuccess = [dict writeToFile:savePath atomically:YES];
    if (ifWriteSuccess) {
        NSLog(@"根据事务id存储订单号成功!订单号为:%@  事务id为:%@",orderNo,transaction.transactionIdentifier);
    }
}
//根据凭证存储的列表里获取Order
- (NSString *)getOrderWithTransactionId:(NSString *)transId {
    NSString *orderNo;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:tempOrderPath error:&error];

    for (NSString *name in cacheFileNameArray) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", tempOrderPath, name];
        NSMutableDictionary *localDict = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
        if ([localDict valueForKey:transId]) {
            orderNo = [localDict valueForKey:transId];
        } else {
            continue;
        }
    }
    if (orderNo.length > 0) {
        return orderNo;
    }
    return @"";
}

#pragma mark -- 获取购买凭证
///获取内购票据
- (NSString *)getIapReceipt {
    // 获取交易凭证
    // 系统IOS7.0以上获取支付验证凭证的方式应该改变，切验证返回的数据结构也不一样了。
    // 验证凭据，获取到苹果返回的交易凭据
    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
    //// 从沙盒中获取到购买凭据
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
//    BASE64 常用的编码方案，通常用于数据传输，以及加密算法的基础算法，传输过程中能够保证数据传输的稳定性
//    BASE64 是可以解密的
    NSString *base64String = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    self.receiptBase64String = base64String;
    NSString *sendString = [NSString stringWithFormat:@"{\"receipt-data\" : \"%@\"}", base64String];
    NSLog(@"______%@", sendString);
    return base64String;
}

//本地验证
- (void)localVerify_getAndSaveReceipt:(SKPaymentTransaction *)transaction {
    NSString *receiptBase64String = [self getIapReceipt];//获取内购票据，内购交易凭证
    if (!receiptBase64String) {
        NSLog(@"获取交易凭证为空，验证失败");
        self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"获取交易凭证失败", nil):Nil;
        return;
    }

    NSError *error = nil;
    NSDictionary *requestContents = @{@"receipt-data":receiptBase64String};
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents options:0 error:&error];
    if (!requestData) {//交易凭证为空，验证失败
        NSLog(@"获取交易凭证为空，验证失败");
        self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"交易凭证为空，验证失败", nil):Nil;
        return;
    }

    //初始化
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSString *orderNo = transaction.payment.applicationUsername;
    NSString *user_id;
    if (self.user_id) {
        user_id = self.user_id;
        [[NSUserDefaults standardUserDefaults] setValue:user_id forKey:kApple_pay_Unlock_iap_userId];
    } else {
        user_id = [[NSUserDefaults standardUserDefaults] valueForKey:kApple_pay_Unlock_iap_userId];
    }

    if (user_id == nil || user_id.length == 0) {
        user_id = @"走漏单流程未传入userId";
        NSLog(@"走漏单流程未传入userId");
    }

    if (orderNo == nil || orderNo.length == 0) {
        if (self.traderOrderNo) {
            orderNo = self.traderOrderNo;
        } else {
            if ([self getOrderWithTransactionId:transaction.transactionIdentifier].length > 0) {
                orderNo = [self getOrderWithTransactionId:transaction.transactionIdentifier];
            } else {
                orderNo = @"苹果返回透传参数为nil";
                NSLog(@"苹果返回透传参数为nil");
            }
        }
    }

    NSLog(@"后台订单号为%@",orderNo);
    //如果这时候
    [dict setValue:receiptBase64String forKey:kApple_pay_ReceiptKey];
    [dict setValue:transaction.transactionIdentifier forKey:kApple_pay_Unlock_transactionId];
    [dict setValue:orderNo forKey:kApple_pay_OrderNo];
    [dict setValue:[self getCurrentZoneTime] forKey:kApple_pay_Time];
    [dict setValue:user_id forKey:kApple_pay_UserId];
    //
    NSString *savePath = [NSString stringWithFormat:@"%@/%@.plist", tempOrderPath, transaction.transactionIdentifier];
    //这个存储成功与否 其实无关紧要
    BOOL ifWriteSuccess = [dict writeToFile:savePath atomically:YES];

    if (ifWriteSuccess) {
        NSLog(@"购买凭据存储成功!");
    } else {
        NSLog(@"购买凭据存储失败");
    }

    //向苹果服务器验证支付凭据真实性
//    [self sendAppStoreRequestToPhpWithReceipt:base64String userId:user_id platFormOrder:orderNo trans:transaction];
    [self localVerify_verifyRequestData:requestData testSandbox:NO transaction:transaction];
}

/// 正式环境：https://buy.itunes.apple.com/verifyReceipt
/// 沙箱环境：https://sandbox.itunes.apple.com/verifyReceipt
- (void)localVerify_verifyRequestData:(NSData *)postData testSandbox:(BOOL)test transaction:(SKPaymentTransaction *)transaction {

//    // appStoreReceiptURL iOS7.0增加的，购买交易完成后，会将凭据存放在该地址
//    NSURL *receiptUrl = [[NSBundle mainBundle] appStoreReceiptURL];
//    //// 从沙盒中获取到购买凭据
//    NSData *receiptData = [NSData dataWithContentsOfURL:receiptUrl];
//    NSString *str = [[NSString alloc] initWithData:receiptData encoding:NSUTF8StringEncoding];
//    NSString *environment = [self environmentForReceipt:str];
//    NSLog(@"------ 完成交易调用的方法completedTransaction 1----------%@", environment);
//    /** 注意：这里之后可以不用自己去验证，直接调用自己服务器接口，让后台去APP Store 验证*/
//    NSURL *appStoreUrl = nil;
//    if ([environment isEqualToString:@"environment=Sandbox"]) {
//        appStoreUrl = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];// 沙箱环境
//    } else {
//        appStoreUrl = [NSURL URLWithString:@"https://buy.itunes.apple.com/verifyReceipt"];//正式环境
//    }


    NSString *url = @"https://sandbox.itunes.apple.com/verifyReceipt";// 沙箱环境
    if (test) {
        url = @"https://buy.itunes.apple.com/verifyReceipt";//正式环境
    }

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    request.HTTPBody = postData;
    static NSString *requestMethod = @"POST";
    request.HTTPMethod = requestMethod;

    [[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            //无法连接服务器，购买校验失败
            NSLog(@"无法连接服务器，购买校验失败");
            self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"无法连接服务器，购买校验失败", nil):Nil;
        } else {
            NSError *error;
            NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
            if (!jsonResponse) {
                // 苹果服务器校验数据返回为空校验失败
                NSLog(@"苹果服务器校验数据返回为空,校验失败");
                self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"苹果服务器校验数据返回为空,校验失败", nil):Nil;
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                return ;
            }
            //先验证正式服务器,如果正式服务器返回21007再去苹果测试服务器验证,沙盒测试环境苹果用的是测试服务器
            NSString *status = [NSString stringWithFormat:@"%@", jsonResponse[@"status"]];
            if (status && [status isEqualToString:@"21007"]) {
                [self localVerify_verifyRequestData:postData testSandbox:YES transaction:transaction];
            } else if (status && [status isEqualToString:@"0"]) { //订单校验成功
                //订单校验成功,
                NSString *orderNo = transaction.payment.applicationUsername;
                if (!orderNo) {
                    orderNo = [self bindedOrderNo];
                }
                [self localVerify_verifySuccess:orderNo];//检验成功，进行后续操作
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            } else {
                // 苹果服务器校验数据返回为空校验失败
                NSLog(@"苹果服务器校验数据返回为空,校验失败");
                self.PayFailBlock?self.PayFailBlock(AppStorePayError, @"苹果服务器校验数据返回为空,校验失败", nil):Nil;
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
        }
    }];
}

//  在第二步中调用（第二种，不安全的验证票据方法中）：
- (NSString *)environmentForReceipt:(NSString *)str {

    str = [str stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@""];

    NSArray *arr = [str componentsSeparatedByString:@";"];

    // 存储收据环境的变量
    NSString *environment = arr[2];
    return environment;
}

// 本地检验成功，进行后续操作
- (void)localVerify_verifySuccess:(NSString *)orderNo {
    if (!orderNo.length) {
        NSLog(@"苹果服务器,交易凭证校验成功");
        self.PaySuccessBlock?self.PaySuccessBlock(AppStorePaySuccess, @"苹果服务器,交易凭证校验成功", nil):Nil;
        return;
    }
    //开始调用接口..
    NSLog(@"苹果服务器,交易凭证校验成功，开始调用接口，接口调用成功后移除本地凭证(successConsumptionOfGoodsWithTransId)");
    self.PaySuccessBlock?self.PaySuccessBlock(AppStorePaySuccess, @"苹果服务器,交易凭证校验成功，开始调用接口", nil):Nil;
}

//根据购买凭证 移除本地凭证的方法
- (void)successConsumptionOfGoodsWithTransId:(NSString *)transactionId {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    if ([fileManager fileExistsAtPath:iapReceiptPath]) {
        NSArray *cacheFileNameArray = [fileManager contentsOfDirectoryAtPath:iapReceiptPath error:&error];
        if (!error) {
            for (NSString *name in cacheFileNameArray) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@", iapReceiptPath, name];

                [self removeReceiptWithPlistPath:filePath byTransId:transactionId];//根据订单号来删除存储的凭证
            }
        }
    }
}
//根据订单号来删除存储的凭证
- (void)removeReceiptWithPlistPath:(NSString *)plistPath byTransId:(NSString *)transactionId {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    NSString *localTransId = [dict objectForKey:kApple_pay_Unlock_transactionId];
    //通过凭证进行对比
    if ([transactionId isEqualToString:localTransId]) {
        BOOL ifRemove = [fileManager removeItemAtPath:plistPath error:&error];
        if (ifRemove) {
            NSLog(@"成功订单，移除成功");
        } else {
            NSLog(@"成功订单，移除失败");
        }
    } else {
        NSLog(@"本地无与之匹配的订单");
    }
}

#pragma mark -- 获取系统时间的方法
- (NSString *)getCurrentZoneTime{
    NSDate * date = [NSDate date];
    NSDateFormatter*formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*dateTime = [formatter stringFromDate:date];
    return dateTime;
}

//记录交易
-(void)recordTransaction:(NSString *)product{
    NSLog(@"-----记录交易--------");
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}
#pragma mark -- 处理交易失败回调
- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    [MBProgressHUD hideAllHuds];
    
    NSLog(@"购买失败代码：%ld", transaction.error.code);
    NSLog(@"失败错误：%@", transaction.error);
    
    
    if(transaction.error.code != SKErrorPaymentCancelled) {
        NSLog(@"购买失败");
        self.PayFailBlock?self.PayFailBlock(AppStorePayError, transaction.error.localizedDescription?:@"购买失败", nil):Nil;
        
        NSString *errorMsg = @"";
        if (transaction.error.code == SKErrorUnknown) {
            errorMsg = @"未知错误";
        } else if (transaction.error.code == SKErrorClientInvalid) {
            errorMsg = @"不允许客户端发出请求";
        } else if (transaction.error.code == SKErrorPaymentInvalid) {
            errorMsg = @"采购标识符无效";
        } else if (transaction.error.code == SKErrorPaymentNotAllowed) {
            errorMsg = @"不允许此设备付款";
        } else if (transaction.error.code == SKErrorStoreProductNotAvailable) {
            errorMsg = @"产品在当前店面中不可用";
        } else if (transaction.error.code == SKErrorCloudServicePermissionDenied) {
            errorMsg = @"用户不允许访问云服务信息";
        } else if (transaction.error.code == SKErrorCloudServiceNetworkConnectionFailed) {
            errorMsg = @"设备无法连接到网络";
        } else if (transaction.error.code == SKErrorCloudServiceRevoked) {
            errorMsg = @"用户已撤销使用此云服务的权限";
        }
        if (@available(iOS 12.2, *)) {
            if (transaction.error.code == SKErrorPrivacyAcknowledgementRequired) {
                errorMsg = @"用户需要确认苹果的隐私政策";
            } else if (transaction.error.code == SKErrorUnauthorizedRequestData) {
                errorMsg = @"应用程序正在尝试使用SKPayment的requestData属性，但没有相应的权限";
            } else if (transaction.error.code == SKErrorInvalidOfferIdentifier) {
                errorMsg = @"指定的订阅报价标识符无效";
            } else if (transaction.error.code == SKErrorInvalidSignature) {
                errorMsg = @"提供的加密签名无效";
            } else if (transaction.error.code == SKErrorMissingOfferParams) {
                errorMsg = @"缺少SKPaymentDiscount中的一个或多个参数";
            } else if (transaction.error.code == SKErrorInvalidOfferPrice) {
                errorMsg = @"所选报价的价格无效（例如低于当前基本订阅价格）";
            } else if (transaction.error.code == SKErrorOverlayCancelled) {
                errorMsg = @"SKOverlay，取消";
            }
        } else if (@available(iOS 14.0, *)) {
            if (transaction.error.code == SKErrorOverlayInvalidConfiguration) {
                errorMsg = @"SKOverlay，无效的配置";
            } else if (transaction.error.code == SKErrorOverlayTimeout) {
                errorMsg = @"SKOverlay，超时";
            } else if (transaction.error.code == SKErrorIneligibleForOffer) {
                errorMsg = @"用户没有资格享受订阅优惠";
            } else if (transaction.error.code == SKErrorUnsupportedPlatform) {
                errorMsg = @"不支持的平台";
            }
        } else if (@available(iOS 14.5, *)) {
            if (transaction.error.code == SKErrorOverlayPresentedInBackgroundScene) {
                errorMsg = @"客户端试图在UIWindowScene中而不是在前台显示SKOverlay";
            }
        } else {
            
        }
        
        [MBProgressHUD showError:[NSString stringWithFormat:@"%ld, %@", transaction.error.code, errorMsg]];//交易失败
        
//        [MBProgressHUD showError:@"购买失败"];//交易失败
    } else {
        NSLog(@"用户取消交易(取消购买)");
        self.PayFailBlock?self.PayFailBlock(AppStorePayCancel, transaction.error.localizedDescription?:@"用户取消交易", nil):Nil;
        [MBProgressHUD showError:@"用户取消交易(取消购买)"];//取消充值
    }

    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    }
}

////当用户的购买历史记录中的所有交易已成功添加回队列时发送。
//-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentTransaction *)transaction{
//
//}

/// 已经购买过该商品
- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    // 对于已购商品，处理恢复购买的逻辑
    [MBProgressHUD hideAllHuds];
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    
    
    
    
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
//        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];//一般用于非消耗商品，用来恢复购买。
    }
    NSLog(@"交易恢复处理");
}
////将交易从用户的购买历史记录添加回队列时遇到错误时发送。
//-(void)paymentQueue:(SKPaymentQueue *)paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
//    NSLog(@"-------paymentQueue 支付队列 ----");
//    self.PayFailBlock?self.PayFailBlock(AppStorePayError, error.localizedDescription, nil):Nil;
//}


//从队列中删除已完成（即失败或已完成）的
-(void)finishAndRemoveTransaction:(SKPaymentTransaction *)transaction {
    //异步的。从队列中删除已完成（即失败或已完成）的事务。试图完成采购事务将引发异常。
//    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    }
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    
    NSLog(@"内购解除监听");
}

#pragma mark - 异常订单处理
////https://www.jianshu.com/p/60645201a29c
////array是异常数组，包含订单号、交易凭据
//-(void)anomalyOrderVerify:(NSMutableArray * )array{
//    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
//    for (int i = array.count; i > 0 ; i-- ) {
//       //循环判断，通过信号量控制
//        dispatch_semaphore_signal(semaphore);
//    }
//}



//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//}

-(void)dealloc {
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    }
    NSLog(@"dealloc 内购解除监听");
}

//我们已经完成了内购的付款操作了，至于如何给到用户商品就在
//- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions
//这个代理方法里面就行操作

@end


/**
 
 SKPaymentQueue.h
 //canMakePayments：如果此设备无法或不允许付款，返回NO
 //addPayment：将付款添加到服务器队列。付款被复制以将SKPaymentTransaction添加到交易数组中。同一笔付款可以多次添加以创建多笔交易。
 //restoreCompletedTransactions：将当前用户已完成的事务添加回要重新完成的队列。将要求用户进行身份验证。成功时，观察者将收到0个或多个-paymentQueue:updatedTransactions:，然后是-paymentQueue RestoreCompletedTransactionsFinished:，失败时将收到-paymentQueue:restoreCompletedTransaction FailedWithError:。在部分成功的情况下，一些交易可能仍然可以交付。
 //restoreCompletedTransactionsWithApplicationUsername：
 //finishTransaction：从队列中删除已完成（即失败或已完成）的事务。试图完成采购事务将引发异常。
 //startDownloads：启动给定的下载（SKDownload）。
 //pauseDownloads：暂停/继续下载（SKDownload）
 //resumeDownloads：
 //cancelDownloads：取消下载（SKDownload）
 //addTransactionObserver：观察员不予保留。只有当队列具有观察者时，事务数组才会与服务器同步。这可能需要用户进行身份验证。
 //removeTransactionObserver：
 // transactionObservers：可用的transactionObserver数组。不保留事务观察员
 // transactions：未完成的SKPaymentTransactions数组。仅当队列具有观察者时有效。异步更新
 //showPriceConsentOfNeed：如果StoreKit调用了SKPaymentQueueDelegate的“paymentQueueShouldShowPriceConsistent:”方法，而您返回“否”，则您可以使用此方法在以后显示更适合您的应用程序的价格同意UI。如果没有待定的价格同意书，这种方法将毫无作用。
 //presentCodeRedemptionSheet：调用此方法让StoreKit提供一张表单，使用户可以兑换您的应用程序提供的代码。
 
 
 
 
 */
