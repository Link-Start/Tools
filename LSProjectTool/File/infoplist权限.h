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

#pragma mark -
#pragma mark -
#pragma mark -
#pragma mark -

#endif /* infoplist___h */
