//
//  URL Schemes.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/8/4.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#ifndef URL_Schemes_h
#define URL_Schemes_h

--------------
// !!!!!!!!!!!!!!! 重要：iOS 15限制了配置的URL Scheme不可以超过50个 !!!!!!!!!!!!!!!
// 经验证，在iOS 15系统上，使用Xcode 13编译出的App，LSApplicationQueriesSchemes的数量会限制为50个。第50个之后的scheme配置会不生效
--------------

#pragma mark - URL Schemes
// URL Types ----> URL Schemes
//https://www.jianshu.com/p/ca7357ab4852
//https://www.jianshu.com/p/f367b4a5e871
//https://sspai.com/post/31500
//https://sspai.com/post/44591
// https://st3376519.huoban.com/share/1985010/VGi2N5Vf0C1MVnHCVWiBc8L9g15c9VGJbMGcFrb6/172707/list
/**
一个 URL Schemes 分为 Scheme、Action、Parameter、Value 这 4 个部分，中间用冒号 :、斜线 /、问号 ?、等号 = 相连接。

拿 things:///add?title=正文内容&note=备注 来说：
    Scheme（链接头）是 things；
    Action（动作）是 add；
    Parameter（参数）是 title 和 note；
    Value（值）是 正文内容 和 备注。
另外在不同的部分之间有符号相连，它们也有一定的规则：
    冒号:：在链接头和命令之间；
    双斜杠 //：在链接头和命令之间，有时会是三斜杠 ///；
    问号 ?：在命令和参数之间；
    等号 =：在参数和值之间；
    「和」符号 &：在一组参数和另一组参数之间。

 
 //!!!!!!!!!!!!!!!!!!!!!!!!!
 // iOS 9后苹果为URL Scheme添加了白名单，开发者需要在白名单中注册自己app要用到的URL Scheme
 // 在iOS 9中不在白名单中注册的话，利用URL Scheme是打不开其他app的，而且在控制台还会打印如下错误信息
 
 // ******************************!!!!!!!!!!!!!!!!!
 //别的app利用URL Scheme打开自己的app的动作该怎么扑捉呢？在app被URL Scheme打开的时候会触发如下代理方法，使用的版本要求也都在下面了。(建议把对URL Scheme的处理封装出来，减少AppDelegate的代码量)
 // 需要把你想要打开的app的schemes添加到白名单,否则跳不过去
 // 这3个回调是有优先级的。3>2>1。
 // 也就是说，如果你3个回调都实现了，那么程序只会执行 3 回调。其他回调是不会执行的。（当然，iOS9以下只会执行2回调）
 - (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url { // 1
 //    NS_DEPRECATED_IOS(2_0, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;
     // iOS2.0的时候推出的，参数只有url
     NSLog(@"%@", url);
     
     return YES;
 }
 - (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(id)annotation { // 2
 //    NS_DEPRECATED_IOS(4_2, 9_0, "Please use application:openURL:options:") __TVOS_PROHIBITED;
     // iOS4.2的时候推出的，参数有url sourceApplication annotation.
     NSLog(@"%@", sourceApplication);
     
     return YES;
 }
 - (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options { // 3
     // NS_AVAILABLE_IOS(9_0) ;
     // no equiv. notification. return NO if the application can't open for some reason
     // iOS9.0的时候推出的，参数有url options。options有下面几个key
     NSLog(@"%@", options);
     
     return YES;
 }
 
 
 
 
 白名单：LSApplicationQueriesSchemes
 https://developer.umeng.com/docs/128606/detail/129507
 
 配置SSO白名单：https://developer.umeng.com/docs/66632/detail/66825#h3--sso-
 U-Share集成文档：https://developer.umeng.com/docs/66632/detail/66825#h3--sso-
 
 <key>LSApplicationQueriesSchemes</key>
     <array>
         <!--微信 URL Scheme白名单-->
         <string>wechat</string>
         <string>weixin</string>
         <string>weixinULAPI</string>
         <string>weixinURLParamsAPI</string>

         <!-- 支付宝 URL Scheme 白名单-->
         <string>alipay</string>
         <string>alipayshare</string>

         <!-- QQ、Qzone URL Scheme白名单-->
         <string>mqqopensdklaunchminiapp</string>
         <string>mqqopensdkminiapp</string>
         <string>mqqapi</string>
         <string>mqq</string>
         <string>mqqOpensdkSSoLogin</string>
         <string>mqqconnect</string>
         <string>mqqopensdkapi</string>
         <string>mqqopensdkapiV2</string>
         <string>mqqopensdkapiV3</string>
         <string>mqqopensdkapiV4</string>
         <string>tim</string>
         <string>timapi</string>
         <string>timopensdkfriend</string>
         <string>timwpa</string>
         <string>timgamebindinggroup</string>
         <string>timapiwallet</string>
         <string>timOpensdkSSoLogin</string>
         <string>wtlogintim</string>
         <string>timopensdkgrouptribeshare</string>
         <string>timopensdkapiV4</string>
         <string>timgamebindinggroup</string>
         <string>timopensdkdataline</string>
         <string>wtlogintimV1</string>
         <string>timapiV1</string>
         <string>openmobile.qq.com</string>  <!-- QQ互联-->
         <!-- 百度地图 -->
        <string>baidumap</string>
        <!-- 高德地图 -->
        <string>iosamap</string>
        <!-- 谷歌地图 -->
        <string>comgooglemaps</string>
        <!-- 腾讯地图 -->
        <string>qqmap</string>
     </array>
*/

#endif /* URL_Schemes_h */


// ------------------ 35 个
<key>LSApplicationQueriesSchemes</key>
    <array>
        <!--微信 URL Scheme白名单-->
        <string>wechat</string>
        <string>weixin</string>
        <string>weixinULAPI</string>
        <string>weixinURLParamsAPI</string>

        <!-- 支付宝 URL Scheme 白名单-->
        <string>alipay</string>
        <string>alipayshare</string>

        <!-- QQ、Qzone URL Scheme白名单-->
        <string>mqqopensdklaunchminiapp</string>
        <string>mqqopensdkminiapp</string>
        <string>mqqapi</string>
        <string>mqq</string>
        <string>mqqOpensdkSSoLogin</string>
        <string>mqqconnect</string>
        <string>mqqopensdkapi</string>
        <string>mqqopensdkapiV2</string>
        <string>mqqopensdkapiV3</string>
        <string>mqqopensdkapiV4</string>
        <string>tim</string>
        <string>timapi</string>
        <string>timopensdkfriend</string>
        <string>timwpa</string>
        <string>timgamebindinggroup</string>
        <string>timapiwallet</string>
        <string>timOpensdkSSoLogin</string>
        <string>wtlogintim</string>
        <string>timopensdkgrouptribeshare</string>
        <string>timopensdkapiV4</string>
        <string>timgamebindinggroup</string>
        <string>timopensdkdataline</string>
        <string>wtlogintimV1</string>
        <string>timapiV1</string>
        <string>openmobile.qq.com</string>  <!-- QQ互联-->

        <!-- 百度地图 -->
        <string>baidumap</string>
        <!-- 高德地图 -->
        <string>iosamap</string>
        <!-- 腾讯地图 -->
        <string>qqmap</string>
        <!-- 谷歌地图 -->
        <string>comgooglemaps</string>
    </array>


// ------------------
<key>LSApplicationQueriesSchemes</key>
    <array>
        <!-- 微信 URL Scheme 白名单-->
        <string>wechat</string>
        <string>weixin</string>
        <string>weixinULAPI</string>
        <string>weixinURLParamsAPI</string>

        <!-- 支付宝 URL Scheme 白名单-->
        <string>alipay</string>
        <string>alipayshare</string>

        <!-- 新浪微博 URL Scheme 白名单-->
        <string>sinaweibohd</string>
        <string>sinaweibo</string>
        <string>sinaweibosso</string>
        <string>weibosdk</string>
        <string>weibosdk2.5</string>
        <string>weibosdk3.3</string>

        <!-- QQ、Qzone URL Scheme 白名单-->
        <string>mqqopensdklaunchminiapp</string>
        <string>mqqopensdkminiapp</string>
        <string>mqqapi</string>
        <string>mqq</string>
        <string>mqqOpensdkSSoLogin</string>
        <string>mqqconnect</string>
        <string>mqqopensdkdataline</string>
        <string>mqqopensdkgrouptribeshare</string>
        <string>mqqopensdkfriend</string>
        <string>mqqopensdkapi</string>
        <string>mqqopensdkapiV2</string>
        <string>mqqopensdkapiV3</string>
        <string>mqqopensdkapiV4</string>
        <string>mqzoneopensdk</string>
        <string>wtloginmqq</string>
        <string>wtloginmqq2</string>
        <string>mqqwpa</string>
        <string>mqzone</string>
        <string>mqzonev2</string>
        <string>mqzoneshare</string>
        <string>wtloginqzone</string>
        <string>mqzonewx</string>
        <string>mqzoneopensdkapiV2</string>
        <string>mqzoneopensdkapi19</string>
        <string>mqzoneopensdkapi</string>
        <string>mqqbrowser</string>
        <string>mttbrowser</string>
        <string>tim</string>
        <string>timapi</string>
        <string>timopensdkfriend</string>
        <string>timwpa</string>
        <string>timgamebindinggroup</string>
        <string>timapiwallet</string>
        <string>timOpensdkSSoLogin</string>
        <string>wtlogintim</string>
        <string>timopensdkgrouptribeshare</string>
        <string>timopensdkapiV4</string>
        <string>timgamebindinggroup</string>
        <string>timopensdkdataline</string>
        <string>wtlogintimV1</string>
        <string>timapiV1</string>
        <string>openmobile.qq.com</string>  <!-- QQ互联-->

        <!-- 钉钉 URL Scheme 白名单-->
        <string>dingtalk</string>
        <string>dingtalk-open</string>

        <!-- Linkedin URL Scheme 白名单-->
        <string>linkedin</string>
        <string>linkedin-sdk2</string>
        <string>linkedin-sdk</string>

        <!-- 点点虫 URL Scheme 白名单-->
        <string>laiwangsso</string>
        <!-- 易信 URL Scheme 白名单-->
        <string>yixin</string>
        <string>yixinopenapi</string>
        <!-- instagram URL Scheme 白名单-->
        <string>instagram</string>
        <!-- whatsapp URL Scheme 白名单-->
        <string>whatsapp</string>
        <!-- line URL Scheme 白名单-->
        <string>line</string>
        <!-- Facebook URL Scheme 白名单-->
        <string>fbapi</string>
        <string>fb-messenger-api</string>
        <string>fb-messenger-share-api</string>
        <string>fbauth2</string>
        <string>fbshareextension</string>
        <!-- Kakao URL Scheme 白名单-->
        <!-- 注：以下第一个参数需替换为自己的kakao appkey-->
        <!-- 格式为 kakao + "kakao appkey"-->
        <string>kakaofa63a0b2356e923f3edd6512d531f546</string>
        <string>kakaokompassauth</string>
        <string>storykompassauth</string>
        <string>kakaolink</string>
        <string>kakaotalk-4.5.0</string>
        <string>kakaostory-2.9.0</string>
        <!-- pinterest URL Scheme 白名单-->
        <string>pinterestsdk.v1</string>
        <!-- Tumblr URL Scheme 白名单-->
        <string>tumblr</string>
        <!-- 印象笔记 -->
        <string>evernote</string>
        <string>en</string>
        <string>enx</string>
        <string>evernotecid</string>
        <string>evernotemsg</string>
        <!-- 有道云笔记-->
        <string>youdaonote</string>
        <string>ynotedictfav</string>
        <string>com.youdao.note.todayViewNote</string>
        <string>ynotesharesdk</string>
        <!-- Google+-->
        <string>gplus</string>
        <!-- Pocket-->
        <string>pocket</string>
        <string>readitlater</string>
        <string>pocket-oauth-v1</string>
        <string>fb131450656879143</string>
        <string>en-readitlater-5776</string>
        <string>com.ideashower.ReadItLaterPro3</string>
        <string>com.ideashower.ReadItLaterPro</string>
        <string>com.ideashower.ReadItLaterProAlpha</string>
        <string>com.ideashower.ReadItLaterProEnterprise</string>
        <!-- VKontakte-->
        <string>vk</string>
        <string>vk-share</string>
        <string>vkauthorize</string>
        <!-- Twitter-->
        <string>twitter</string>
        <string>twitterauth</string>

        <!-- -->
        <string>safepay</string>
        <string>jdpay</string>

        <!-- 百度地图 -->
        <string>baidumap</string>
        <!-- 高德地图 -->
        <string>iosamap</string>
        <!-- 腾讯地图 -->
        <string>qqmap</string>
        <!-- 谷歌地图 -->
        <string>comgooglemaps</string>
</array>
