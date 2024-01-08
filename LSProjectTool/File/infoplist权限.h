//
//  infoplist权限.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/4/28.
//  Copyright © 2021 Link-Start. All rights reserved.
//
//
// iOS各种权限状态的获取及注意事项 https://www.dandelioncloud.cn/article/details/1515907437629644801

#ifndef infoplist___h
#define infoplist___h

iOS常用权限请求判断  https://github.com/MxABC/LBXPermission

#pragma mark - 麦克风权限：Privacy - Microphone Usage Description 是否允许此App使用你的麦克风？
#pragma mark - 相机权限： Privacy - Camera Usage Description 是否允许此App使用你的相机？
#pragma mark - 相册权限： Privacy - Photo Library Usage Description 是否允许此App访问你的媒体资料库？
#pragma mark - 通讯录权限： Privacy - Contacts Usage Description 是否允许此App访问你的通讯录？

// 问题：!!!!
    问题描述
    调用系统的通讯录界面CNContactPickerViewController之后出现联系人列表向上偏移，然后被搜索框挡住。
    https://segmentfault.com/q/1010000017081146

// 问题出现的环境背景及自己尝试过哪些方法!!!!
    尝试过建立单独的干净的demo（完全原生）去实现，没有出现上述bug，所以觉得可能是跟自己的设置有关


// 原因：!!!!!
    如果设置了UIScrollView的contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
     就会出现不能自动适应的问题.

// 解决办法：
    在调用系统通讯录的地方设置:
if (@available(iOS 11.0, *)){
    //UIScrollViewContentInsetAdjustmentNever:contentInset 不会被调整
    //UIScrollViewContentInsetAdjustmentAlways:contentInset 始终会被scrollView的safeAreaInsets来调整
    [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAlways];
}
经实践，设置UIScrollViewContentInsetAdjustmentAlways之后页面确实恢复正常，






#pragma mark - 蓝牙权限：Privacy - Bluetooth Peripheral Usage Description 是否许允此App使用蓝牙？
#pragma mark - 语音转文字权限：Privacy - Speech Recognition Usage Description 是否允许此App使用语音识别？
#pragma mark - 日历权限：Privacy - Calendars Usage Description
//EKAuthorizationStatusNotDetermined = 0,//未确定
//EKAuthorizationStatusRestricted, //受限制的
//EKAuthorizationStatusDenied, //否认，拒绝
//EKAuthorizationStatusAuthorized,//经授权的



#pragma mark - 定位。位置
#pragma mark - 定位权限：Privacy - Location When In Use Usage Description
#pragma mark - 定位权限: Privacy - Location Always Usage Description
#pragma mark - 位置权限：Privacy - Location Usage Description
#pragma mark - 使用期间定位：info.plist 配置 NSLocationWhenInUseUsageDescription
#pragma mark - 始终定位：info.plist 同时配置以下项目 NSLocationAlwaysAndWhenInUseUsageDescription、NSLocationWhenInUseUsageDescription，需要支持 iOS10 的话需要配置 NSLocationAlawaysUsageDescription
#pragma mark - 位置权限：模糊定位状态 NSLocationDefaultAccuracyReduced(Privacy - Location Default Accuracy Reduced 为 true 默认请求大概位置。)
// https://www.jianshu.com/p/7616285c251d
1.系统级开关状态，及跳转设置
[CLLocationManager locationServicesEnabled] //系统的全局定位开关
此方法是获取到用户是否打开了系统的位置服务，但是因为现在苹果的安全机制，我们无法执行代码跳转到系统的位置开关界面，所以，如果位置服务不可用的情况下，我们不需要做任何操作，只需要操作位置权限问题即可。
注意：一定要区分位置服务和位置权限，位置服务是系统设置中位置的总开关，位置权限，只是代表是否可以获取到某一个应用的位置

//CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
typedef NS_ENUM(int, CLAuthorizationStatus) {
      kCLAuthorizationStatusNotDetermined = 0,  // 用户未授权，即还未弹出OS的授权弹窗
      kCLAuthorizationStatusDenied, // 用户拒绝定位权限，包括拒绝App或者全局开关关闭
      kCLAuthorizationStatusRestricted, // 定位服务受限，该状态位用户无法通过设置页面进行改变
      kCLAuthorizationStatusAuthorizedAlways, // 始终定位，即后台定位
      kCLAuthorizationStatusAuthorizedWhenInUse, // App使用的时候，允许定位
      kCLAuthorizationStatusAuthorized, // iOS8.0之后已经被废弃
};


//kCLAuthorizationStatusRestricted：定位服务授权状态是受限制的。可能是由于活动限制定位服务，用户不能改变。这个状态可能不是用户拒绝的定位服务。
//kCLAuthorizationStatusDenied：定位服务授权状态已经被用户明确禁止，或者在设置里的定位服务中关闭。
//kCLAuthorizationStatusAuthorizedAlways：定位服务授权状态已经被用户允许在任何状态下获取位置信息。包括监测区域、访问区域、或者在有显著的位置变化的时候。
//kCLAuthorizationStatusAuthorizedWhenInUse：定位服务授权状态仅被允许在使用应用程序的时候。
//kCLAuthorizationStatusAuthorized：这个枚举值已经被废弃了。他相当于kCLAuthorizationStatusAuthorizedAlways这个值。

// 三、始终定位Always 和 App使用期间定位WhenInUse 两种定位模式配置
// 两种模式的都需要初始化CLLocationManagerd的实例self.locationManager = [[CLLocationManager alloc] init];，然后调用实例方法。

//3.1、“使用期间定位”模式 info.plist 配置 NSLocationWhenInUseUsageDescription
//b、调用方法requestWhenInUseAuthorization申请使用期间定位模式,有且只有status == kCLAuthorizationStatusNotDetermined的时候，调用才会出现系统弹窗。
//注意：如果用户选择“允许一次”，则状态更改为kCLAuthorizationStatusAuthorizedWhenInUse，但是设置还是为"询问"状态，下次App启动的时候，还是status == kCLAuthorizationStatusNotDetermined需要进行授权弹窗。
//c、之后如果还需要定位，则需要自己弹窗提醒用户

// 3.2、“始终定位”模式 只有当你的App确实需要始终定位的时候，才配置。该模式下，AppStore的审核也会更加的严格。
// info.plist 同时配置以下项目
//NSLocationAlwaysAndWhenInUseUsageDescription
//NSLocationWhenInUseUsageDescription
//需要支持 iOS10 的话需要配置 NSLocationAlawaysUsageDescription
// 调用方法requestAlwaysAuthorization, 该方法的调用时机非常重要，否则可能永远都出不来弹窗。


// 四、模糊定位，iOS14适配
// 4.1、模糊定位状态
self.locationManager = [[CLLocationManager alloc] init];
CLAccuracyAuthorization status = self.locationManager.accuracyAuthorization;
typedef NS_ENUM(NSInteger, CLAccuracyAuthorization) {
    CLAccuracyAuthorizationFullAccuracy, //精准定位
    CLAccuracyAuthorizationReducedAccuracy, // 模糊定位
};
// 4.2、可以通过直接在 info.plist 中添加 NSLocationDefaultAccuracyReduced(Privacy - Location Default Accuracy Reduced) 为 true 默认请求大概位置。 这样设置之后，即使用户想要为该 App 开启精确定位权限，也无法开启。
// 4.3、可以直接通过API来根据不同的需求设置不同的定位精确度。
self.locationManager = [[CLLocationManager alloc] init];
self.locationManager.desiredAccuracy = kCLLocationAccuracyReduced;
// 4.4、临时一次精准定位弹窗 —— 每次调用否会弹窗，iOS无限制
// 在 Info.plist 中配置NSLocationTemporaryUsageDescriptionDictionary字典中需要配置 key 和 value 表明使用位置的原因，以及具体的描述。 key为自定义的字段，在接口中传入PurposeKey。
// 然后调用方法[self.mgr requestTemporaryFullAccuracyAuthorizationWithPurposeKey:@"purposeKey"];


#pragma mark - 媒体库权限：Privacy - Media Library Usage Description
#pragma mark - 健康分享权限：Privacy - Health Share Usage Description
#pragma mark - 健康更新权限：Privacy - Health Update Usage Description
#pragma mark - 运动使用权限：Privacy - Motion Usage Description
#pragma mark - 音乐权限：Privacy - Music Usage Description
#pragma mark - 提醒使用权限：Privacy - Reminders Usage Description
#pragma mark - Siri使用权限：Privacy - Siri Usage Description
#pragma mark - 电视供应商使用权限：Privacy - TV Provider Usage Description
#pragma mark - 视频用户账号使用权限：Privacy - Video Subscriber Account Usage Description
#pragma mark - 网络权限：App Transport Security Settings — Allow Arbitrary Loads
// NSAppTransportSecurity，App Transport Security Settings

// iOS 无法加载HTTP
// https://www.jianshu.com/p/a69f0d1b316b
// https://www.jianshu.com/p/bee253cb4825
// https://www.jianshu.com/p/601f3fa318ed

//1.在iOS 9的时候,默认非HTTS的网络是被禁止的,
//我们可以在info.plist文件中添加NSAppTransportSecurity字典,将NSAllowsArbitraryLoads设置为YES来禁用ATS;


<key>NSAppTransportSecurity</key>
<dict>
    <key>NSExceptionDomains</key>
    <dict>
        <key>yourdomain.com</key>
        <dict>
            <key>NSExceptionAllowInsecureHTTPLoads</key>
            <true/>
            <key>NSExceptionRequiresForwardSecrecy</key>
            <true/>
            <key>NSIncludesSubdomains</key>
            <true/>
            <key>NSTemporaryExceptionAllowsInsecureHTTPLoads</key>
            <true/>
        </dict>
    </dict>
    <key>NSAllowsArbitraryLoadsInWebContent</key>
    <true/>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>

//内容解释
//NSAllowsArbitraryLoads
设置为TURE的话，就会使得除了开发者在NSExceptionDomains里面配置的域名以外所有的网络连接不受限制。

//NSAllowsArbitraryLoadsInWebContent
如果你设置为TURE的话,系统会禁用对来自Web视图的请求的所有ATS限制，也就是你的WebView的请求不不一定需要HTTPS，APP就可以使用嵌入式浏览器来显示任意内容，但是应用的其他部分还是需要用ATS。

//NSExceptionDomains
NSExceptionDomains其实是相当于NSAllowsArbitraryLoads的一个子集。后者是全局的作用，而前者主要是用于对某些域名的限制作用。他的主要作用其实就是用于们自签名的证书。

//NSExceptionDomains字典里面各键的值意义如下。
NSIncludesSubdomains
默认为FALSE,如果设置为TURE，则表示当前设置域名的所有子域名也使用同样的配置

//NSExceptionAllowInsecureHTTPLoads
允许不安全的HTTP请求，这里所谓的不安全，不代表改变了 Transport Layer Security (TLS)或是事HTTPS的请求。所谓的不安全主要是因为使用自签名的证书，没有经过CA认证所以苹果并不知道是不是安全的，如果开发者允许那么苹果也允许加载。

//NSExceptionRequiresForwardSecrecy
默认值为TURE，如果设置为FALSE，则允许不支持完全前向保密（PFS）的TLS密码（对于指定的域名）。

//NSTemporaryExceptionAllowsInsecureHTTPLoads
默认值是FALSE，如果设置为TURE，则表示允许App进行不安全的HTTP请求







#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 加密豁免,出口合规证明: App Uses Non-Exempt Encryption          NO
#pragma mark - 白名单：Queried Url Schemes
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 相册
#pragma mark - 相机
#pragma mark - IDFA
// 按照下面的方法添加之后，在appDelegate里面调用一次方法,会显示弹窗，不管用户同意还是拒绝弹窗只会弹出一次,除非卸载重装
// 如果卸载重装还是没有弹窗,查看设置-->隐私-->跟踪--允许App请求跟踪 是否把总开关关闭了,
// 要把总开关打开才会有弹窗,下面才会有对应的列表显示你的app
//   IDFA
1.添加 AppTrackingTransparency.frame 库
2.info.plist文件中配置key：NSUserTrackingUsageDescription value：获取设备信息用以精准推送您喜欢的内容
Pricacy - Tracking Usage Description 我们需要获取您的设备信息用以精准推送您喜欢的内容,比如推送商品,或旅游信息等,需要获取您的设备信息,您是否同意?

// 如果需要使用idfa功能所需要引入的头文件
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>

//
//如果用户尚未收到授权访问可用于跟踪用户或设备的应用程序相关数据的请求，则返回该值。
//    ATTrackingManagerAuthorizationStatusNotDetermined = 0,
//
//如果访问可用于跟踪用户或设备的应用程序相关数据的授权受到限制，则返回的值。
//    ATTrackingManagerAuthorizationStatusRestricted,
//如果用户拒绝访问可用于跟踪用户或设备的应用程序相关数据的授权，则返回该值。
//    ATTrackingManagerAuthorizationStatusDenied,
//如果用户授权访问可用于跟踪用户或设备的应用程序相关数据，则返回的值
//    ATTrackingManagerAuthorizationStatusAuthorized


/// 用户追踪授权弹窗
//IDFA & IDFV
//IDFA - Identifier For Advertising（广告标识符）
//      同一手机获取该值都相同
//      重装应用, 不会改变
//      用户可手动重置这个值. 重置广告 id: 设置 -> 隐私 -> 广告 -> 重置广告 id (中国区的可能看不到这个, 模拟器可以看到)
//IDFV - Identifier For Vendor（应用开发商标识符）
///// https://blog.csdn.net/yangxuan0261/article/details/113801704
/// 没弹框是因为系统设置里面的[设置-隐私-跟踪-允许App请求跟踪]的状态开关状态没开?(https://www.jianshu.com/p/7a244e92278f)
/// iOS 15.0 以上没弹窗  [着重推荐方法1通知监听，推荐2，不推荐3延迟调用]
/// 1.监听UIApplicationDidBecomeActiveNotification通知，在对应回调内调用获取授权方法     ------>强烈推荐
/// 2.写到 applicationDidBecomeActive 里面才会提示授权弹窗                                                  ------>推荐
/// 3.延迟几秒后调用                                                                                                                     ------>不推荐


///获取IDFA
- (void)obtainIDFA {
    // iOS14方式访问 IDFA
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) { //用户同意授权
                NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                NSLog(@"idfaStr - %@", idfaStr);
            } else {
                NSLog(@"iOS14 用户开启了限制广告追踪");
           }
        }];
    } else {
        // 使用原方式访问 IDFA
        if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
            NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
            NSLog(@"iOS13  idfaStr - %@", idfaStr);
        }
    }
}
- (void)obtainIDFA {
     // iOS14方式访问 IDFA
     if (@available(iOS 14, *)) {
          
          //进行权限判断，根据不同权限进行判断
          ATTrackingManagerAuthorizationStatus status = ATTrackingManager.trackingAuthorizationStatus;
          switch (status) {
               case ATTrackingManagerAuthorizationStatusDenied:
                    NSLog(@"用户拒绝");
//                    [self applyIDFAAuthority];//申请权限
//                  finishBlock();
                    break;
               case ATTrackingManagerAuthorizationStatusAuthorized:
                    NSLog(@"用户允许");
//                  finishBlock();
                    break;
               case ATTrackingManagerAuthorizationStatusNotDetermined:
                    NSLog(@"用户未做选择或未弹窗");
                    [self applyIDFAAuthority];//申请权限
                    break;
               default:
//                    [self applyIDFAAuthority];//申请IDFA权限
                    break;
          }
          
     } else {
          // 使用原方式访问 IDFA
          if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
               NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
               NSLog(@"idfaStr - %@", idfaStr);
          } else {
               NSLog(@"iOS13  用户开启了限制广告追踪");
          }
     }
}

- (void)applyIDFAAuthority { //申请IDFA权限
     if (@available(iOS 14, *)) {
          //申请权限
         //请求弹出用户授权框，只会在程序运行是弹框1次，除非卸载app重装，通地图、相机等权限弹框一样
          [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
               if (status == ATTrackingManagerAuthorizationStatusAuthorized) { //用户同意授权
                    NSString *idfaStr = [[ASIdentifierManager sharedManager] advertisingIdentifier].UUIDString;
                    NSLog(@"iOS14 idfaStr - %@", idfaStr);
               } else {
                    NSLog(@"iOS14 用户开启了限制广告追踪");
               }
//              dispatch_async(dispatch_get_main_queue(), ^{
//                  finishBlock();
//              });
          }];
     }
}

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark - 添加自定义字体:Fonts provided by application 数组
    https://blog.csdn.net/weixin_72437555/article/details/131879646
一、下载字体
    我们要使用自定义字体，首先第一步肯定是下载字体，下
    载的字体格式一般是ttf或otf格式，
    笔者这里推荐几个字体下载网站：
        中文字体网站：https://www.fonts.net.cn/commercial-free/fonts-zh-5.html
        英文字体网站：https://www.dafont.com



//1.添加资源包到工程 2.在info.plist文件中注册字体 3.在工程Bundle Resource中复制字体资源包 4.代码检测查询加入的字体并使用
//1.添加资源包到工程: addFile添加字体资源包或者直接将字体包拖到工程资源文件夹下
//2.在info.plist文件中注册字体
//在工程的info.plist属性列表中添加Fonts provided by application数组属性并在其下添加要加入的自定义字体项。\
   注意，这里在plist文件中写的是文件的全称，包括文件后缀，文件的名字我们是可以随便改的，但建议用本来的字体族名，\
   例如这里是：KristenITC，字体族名是不会变的，之后具体代码中使用的时候是用的字体族名而不是自定义的文件名。\
   本来的字体族名可以右键查看字体文件的详细信息，里面的全称是本来的字体族名，而名称是自定义的。
//3.在工程Bundle Resource中复制字体资源包
//  项目-->targets-->Build Phases-->Copy Bundle Resources下查看是否有字体资源包,如果没有,添加进来
//4.代码检测查询加入的字体并使用
//在具体使用之前，我们可以先通过UIFont类提供的函数打印出系统所有的字体列表，并找到我们更添加的字体看是否添加成功，还可以具体看到我们的资源包有哪些具体的字体样式，例如该字体族的斜体、粗体、粗斜体等等。打印字体族列表的代码如下:
///**
//  * 检查自定义字体族是否成功加入
//  */
// // 取出系统安装了的所有字体族名
// NSArray *familyNames = [UIFont familyNames];
// NSLog(@"系统所有字体族名：%@", familyNames);
// // 打印字体族的所有子字体名(每种字体族可能对应多个子样式字体，例如每种字体族可能有粗体、斜体、粗斜体等等样式)
// for(NSString *familyName in familyNames) {
//   // 字体族的所有子字体名
//   NSArray *detailedNames = [UIFont fontNamesForFamilyName:familyName];
//   NSLog(@"\n字体族%@的所有子字体名：%@", familyName,detailedNames);
// }

//使用字体
//确定字体加入系统之后就可以像自带的系统字体一样直接使用了：
//设置label的字体和大小
// (这里直接使用字体族名也是可以的，有默认的子字体样式，也可以根据需求具体到自字体比如这里的：KristenITC-Regular)
//  [_label setFont:[UIFont fontWithName:@"KristenITC" size:35.0]];


#pragma mark - 设置状态栏字体颜色
1.在info.plist中设置 View controller-based status bar appearance 为 NO    (默认值是YES)
状态栏字体的颜色只由下面的属性设定，默认为白色：
// default is UIStatusBarStyleDefault
[UIApplication sharedApplication].statusBarStyle

解决个别vc中状态栏字体颜色不同的办法
1、在info.plist中，将View controller-based status bar appearance设为NO.
2、在app delegate中：
[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
3、在个别状态栏字体颜色不一样的vc中
-(void)viewWillAppear:(BOOL)animated {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

#pragma mark - App Uses Non-Exempt Encryption
#pragma mark - 开发者账号上架时提示：缺少出口证明
// https://developer.apple.com/documentation/security/complying_with_encryption_export_regulations?language=objc
// https://www.coder.work/article/9542
// https://www.coder.work/article/281237

// 如果您的构建版本未使用加密，请在 Info.plist 文件中使用键字符串值，这样无需为下一构建版本提供出口合规证明信息。
// <key>ITSAppUsesNonExemptEncryption</key><false/>
// 在info.plist中 显示为 App Uses Non-Exempt Encryption          NO
// 设置NO,此值表示应用不使用加密，或仅使用豁免加密。如果您的应用程序使用加密且未豁免，则必须将此值设置为 YES/true。
// 如果您的应用程序（包括它链接到的任何第三方库）不使用加密，或者它只使用免于出口合规性文档要求的加密形式，请将值设置为NO。否则，将其设置为YES。


// 提供合规性文件
// 如果您的应用程序需要出口合规性文档，请将所需项目上传到App Store Connect，如上传出口合规性文档中所述。成功审查文件后，苹果会为您提供代码。在应用程序的Info.plist文件中添加此字符串作为ITSEncryption密钥的值。
// <key>ITSEncryptionExportComplianceCode</key>
// 在info.plist中 显示为：App Encryption Export Compliance Code：字符串 (App Store Connect为需要它的应用程序提供的出口合规性代码)


/**
 
 加密出口合规密钥

 ITSAppUsesNonExemptEncryption ：   一个布尔值，指示应用程序是否使用加密。
 名称：应用程序使用非豁免加密
 ITSEncryptionExportComplianceCode：App Store Connect为需要它的应用程序提供的出口合规性代码。
 名称：应用程序加密出口合规代码
 
 App Uses Non-Exempt Encryption
 iOS应用程序使用非豁免加密时，是指该应用程序使用加密算法对数据进行加密，但这种加密算法没有获得美国政府的豁免权。根据美国的出口管理法规（EAR）和国际流量在可用性方面的限制（ITAR），使用非豁免加密的应用程序需要获得特定的权限和许可。
 解决办法：
 1.确认要在IOS应用程序中使用的加密算法是否符合美国政府的豁免标准。可以参考美国商务部的相关指南和规定。
 2.若加密算法不在豁免范围内，可以考虑申请合适的许可或权限。具体的申请程序和要求需要与美国政府相关部门进行沟通和遵循相关流程。
 3.如果无法获得特定的许可或权限，可以考虑使用符合美国政府豁免标准的加密算法替代原有的非豁免加密算法。
 4.针对IOS应用程序使用非豁免加密的情况，可以调整应用程序的加密策略，确保数据安全性，并在隐私政策中明确说明该潜在风险。
 
 
 App Encryption Export Compliance Code：
 如果您的应用程序需要出口合规性文档，请将所需项目上传到App Store Connect，如上传出口合规性文档中所述。成功审查文件后，苹果会为您提供代码。在应用程序的Info.plist文件中添加此字符串作为ITSEncryption密钥的值。
 
 */

#pragma mark -
#pragma mark - Application requires iPhone environment
Application requires iPhone environment-用于指示程序包是否只能运行在iPhone OS 系统上。Xcode自动加入这个键，并将它的值设置为true。您不应该改变这个键的值。


#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -






#endif /* infoplist___h */


/**
        Info.plist 相关知识：https://www.jianshu.com/p/d2e3577cada0
 在iOS开发中，Info.plist是用于存储应用程序相关信息的XML文件，其中包含许多属性来配置应用程序。以下是Info.plist中常用的属性以及它们的详细说明：

 Bundle identifier（Bundle标识符）：
 应用程序的唯一标识符，通常由两部分组成：“com.organization.appname”。

 Bundle name（Bundle名称）：
 应用程序在设备中显示的名称。

 Bundle version（Bundle版本）：
 应用程序版本号，通常由三部分组成：“主版本号.次版本号.修订版本号”。

 Bundle display name（Bundle显示名称）：
 设备中显示的名称。

 MinimumOSVersion（最低支持的操作系统版本）：
 应用程序能够运行的最低iOS版本。

 LSRequiresIPhoneOS（需要iPhone OS）：
 确定应用程序是否只能运行在iPhone设备上，还是可以在iPad等iOS设备上运行。

 UIApplicationExitsOnSuspend（应用程序挂起时退出）：
 决定当用户按下Home键并将应用程序挂起时是否完全退出应用程序。

 Privacy - Camera Usage Description（相机使用说明）：
 应用程序用于请求相机访问权限时需要添加的描述文本。

 Privacy - Location When In Use Usage Description（使用时获取位置说明）：
 请求应用程序使用位置数据时需要添加的描述文本。

 UIRequiredDeviceCapabilities（所需设备功能）：
 指定应用程序需要的设备功能，例如支持蓝牙、GPS等。

 CFBundleIconFiles（图标文件）：
 指定应用程序使用的图标文件名称。

 CFBundleURLTypes（URL类型）：
 声明应用程序支持的URL类型，例如http、ftp等。

 UISupportedInterfaceOrientations（支持的设备方向）：
 指定应用程序支持的屏幕方向。

 CFBundleShortVersionString（版本号字符串）：
 移动应用程序的版本字符串，通常是x.x.x格式的。

 Queried URL Schemes（统一资源定位符）：
 用于声明应用程序所支持的其他应用程序的URL Schemes

 Queried URL Schemes详解
 URL Schemes是一种统一资源定位符（URL）中的一部分，用于唯一标识设备上的应用程序。通过支持其他应用程序的URL Schemes，应用程序可以允许其他应用程序使用自己的特定功能或服务。

 Queried URL Schemes属性允许应用程序声明它所支持的其他应用程序的URL Schemes，并告知操作系统哪些应用程序可能会查询或与之交互。当应用程序在设备上安装后，操作系统会将Queried URL Schemes信息记录在设备注册表中，以便其他应用程序查询和交互时能够找到相关的URL Scheme和应用程序。

 例如，如果您的应用程序支持与社交媒体应用程序交互，您可以在Info.plist中添加一个Queried URL Schemes属性来声明它们支持的社交媒体应用程序的URL Schemes。这样，其他应用程序就可以使用这些URL Schemes来查找和与您的应用程序交互。

 在实现支持其他应用程序的URL Schemes之前，您可能需要确定您希望与哪些应用程序交互，并了解它们所使用的URL Schemes。可以通过查询其文档或尝试使用它们的URL Schemes来实现这一点。对于那些不公开或不简单支持URL Schemes的应用程序，可能需要与开发者或特定的API集成来实现交互

 详细列举

 CFBundleName: 应用程序的名称。该键用于设置应用程序的标题和名称。

 CFBundleIdentifier: 应用程序的标识符。该键用于设置应用程序的唯一标识符，通常用于在应用商店中发布应用程序。

 CFBundleShortVersionString: 应用程序的版本号。该键用于设置应用程序的版本名称和数字版本号。

 CFBundleVersion: 应用程序的版本号。该键用于设置应用程序的版本号，通常与 CFBundleShortVersionString 键的值相同。

 CFBundleInfoDictionaryVersion: Info.plist 文件的版本号。该键用于设置 Info.plist 文件的版本号，通常与应用程序的版本号相同。

 CFBundleNamePrefix: 应用程序名称的前缀。该键用于设置应用程序名称的前缀，通常用于在应用程序图标上显示的名称。

 CFBundleDevelopmentRegion: 应用程序的开发区域。该键用于设置应用程序的开发区域，通常用于设置语言和货币设置。

 CFBundleLocalizations: 应用程序的本地化版本。该键用于设置应用程序的本地化版本，通常用于设置语言和本地化字符串的本地化版本。

 CFBundleExecutable: 应用程序的可执行文件名。该键用于设置应用程序的可执行文件名。

 CFBundleIconFile: 应用程序的图标文件名。该键用于设置应用程序的图标文件名。

 LSMinimumSystemVersion: 操作系统版本要求。该键用于设置应用程序的操作系统版本要求，通常用于在应用程序的 Info.plist 文件中设置操作系统版本要求。

 LSApplicationQueriesSchemes: 应用程序的查询协议。该键用于设置应用程序的查询协议，通常用于在应用程序中打开和保存文档。---> 白名单

 CFBundleURLSchemes: 应用程序的 URL 类型。该键用于设置应用程序的 URL 类型，通常用于设置应用程序的外部 URL 类型。

 LSApplicationSupportsImageClass: 应用程序支持的图像类型。该键用于设置应用程序支持的图像类型，通常用于在应用程序中显示图像。

 CFBundleDocumentTypes: 应用程序支持的文档类型。该键用于设置应用程序支持的文档类型，通常用于在应用程序中打开和保存文档。

 LSMinimumOSVersion: 操作系统版本要求。该键用于设置应用程序的操作系统版本要求，通常用于在应用程序的 Info.plist 文件中设置操作系统版本要求。

 CFBundleInfoDictionaryPath: Info.plist 文件路径。该键用于设置 Info.plist 文件的路径，通常用于在应用程序的 Info.plist 文件中设置 Info.plist 文件的路径。

 CFBundleDevelopmentRegions: 应用程序的开发区域。该键用于设置应用程序的开发区域，通常用于设置语言和货币设置。

 CFBundleSignature: 应用程序的签名。该键用于设置应用程序的签名，用于确保应用程序的完整性和安全性。

 CFBundleIdentifiers: 应用程序的标识符。该键用于设置应用程序的多个标识符，例如应用程序的唯一标识符和发布标识符。

 CFBundleIcons: 应用程序的图标。该键用于设置应用程序的多个图标，例如应用程序的主图标和启动图标。

 CFBundlePackageType: 应用程序的包类型。该键用于设置应用程序的包类型，例如 .ipa 或 .appx。

 UIStatusBarStyle: 应用程序的状态栏样式。该键用于设置应用程序的状态栏样式，例如显示或隐藏状态栏。

 UISplashScreenImageName: 应用程序的启动画面。该键用于设置应用程序的启动画面，通常用于在应用程序启动时显示的图像。

 UIRequiresBatteryCharging: 应用程序的电池需求。该键用于设置应用程序的电池需求，例如是否需要电池充电。

 UIStatusBarHidden: 应用程序的状态栏是否可见。该键用于设置应用程序的状态栏是否可见，通常用于在应用程序中隐藏状态栏。

 UIUserInterfaceLayoutDirection: 应用程序的用户界面方向。该键用于设置应用程序的用户界面方向，例如左旋转或右旋转。

 UIBarStyle: 应用程序的导航栏和状态栏样式。该键用于设置应用程序的导航栏和状态栏样式，例如默认样式或垂直样式。

 CFBundleDisplayName: 应用程序的名称。该键用于设置应用程序的名称，通常用于在应用程序的图标上显示的名称。

 CFBundleIdentifier: 应用程序的标识符。该键用于设置应用程序的唯一标识符，通常用于在应用程序的 Info.plist 文件中设置应用程序的标识符。

 CFBundleName: 应用程序的名称。该键用于设置应用程序的名称，通常用于在应用程序的 Info.plist 文件中设置应用程序的名称。

 LSApplicationCategory: 应用程序的分类。该键用于设置应用程序的分类，例如默认分类、游戏分类或社交媒体分类。

 LSApplicationTrust: 应用程序的受信任级别。该键用于设置应用程序的受信任级别，例如默认信任、低信任或高信任。

 UIRequiresFullScreen: 应用程序是否需要全屏。该键用于设置应用程序是否需要全屏，例如是否需要在全屏模式下运行。

 UIDeviceFamily: 设备的家族类型。该键用于设置设备的家族类型，例如 iPhone、iPad 或 iPod Touch。

 UIScreenResolution: 屏幕的分辨率。该键用于设置屏幕的分辨率，例如高分辨率屏幕或普通分辨率屏幕。

 UIUserNotificationStyle: 通知的样式。该键用于设置通知的样式，例如默认样式或警告样式。

 UILaunchImages: 应用程序的启动图像。该键用于设置应用程序的启动图像，通常用于在应用程序启动时显示的图像。


 作者：山水域
 链接：https://www.jianshu.com/p/d2e3577cada0
 来源：简书
 著作权归作者所有。商业转载请联系作者获得授权，非商业转载请注明出处。
 
 
 
 */
