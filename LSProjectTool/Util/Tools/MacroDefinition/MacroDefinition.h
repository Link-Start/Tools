//
//  MacroDefinition.h
//  Test
//
//  Created by Xcode on 16/5/17.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
// Xcode6之后，可能是因为大家把大量的头文件和宏定义放到pch里边，导致编译时间过长，苹果就去掉了pch文件
//
//  宏定义：
#pragma mark - 防止block循环引用
/*
 //ARC 使用__weak
 //避免宏循环引用 部分变量也需要weak 这个宏不仅仅只支持self
 //小技巧:添加@符号在前面,可以让我们的这个宏看起来更原生一些(使用时要使用@weakObj())
 //如果weak前置，当然也可以，生成的会是weakobj这样的变量名，只需要把宏中o##Weak 换成weak##o
 //1. 利用了@autoreleasepool{}这个系统的关键字来实现的
 #define WeakObj(o) autoreleasepool{} __weak typeof(o) o##Weak = o;
 //在block中调用self会引起循环引用，但是在block中需要对weakSelf进行strong,保证代码在执行到block中，self不会被释放，当block执行完后，会自动释放该strongSelf
 #define StrongObj(o) autoreleasepool{} __strong typeof(o) o = o##Weak;
 //2. 利用@try{}@finally{} (这部分空的@try或者空的@autoreleasepool会在编译时被优化掉，不必担心性能问题)
 //#define WeakObj(o) try{}@finally{} __weak typeof(o) o##Weak = o;
 
 */

//以下代码是对__weak __typeof(self)weakSelf = self
//和__strong __typeof(weakSelf)strongSelf = weakSelf的宏定义
//使用 @ls_weakify(self)    @ls_strongify(self)
#ifndef ls_weakify   //如果标识符未被定义过,执行程序段 1 否则执行程序段2
#if DEBUG
#if __has_feature(objc_arc)
#define ls_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define ls_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define ls_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define ls_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef ls_strongify
#if DEBUG
#if __has_feature(objc_arc)  //ARC
#define ls_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else                        //MRC
#define ls_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define ls_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define ls_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif


//WeakSelf 宏定义:
#define LS_WeakSelf(type) __weak typeof(type) weak##type = type
//StrongSelf 宏定义
#define LS_StrongSelf(type) __strong typeof(type) strong##type = type

#if DEBUG
//0开发环境/测试环境 1正式环境
#define currentEnvironment 0
#define isProduction        NO
#define isDebug             YES
#else
#define currentEnvironment 1
#define isProduction        YES
#define isDebug             NO
#endif


///APP信息
#define kLS_AppInfoDictionary  [[NSBundle mainBundle] infoDictionary]
///APP名称
#define kLS_App_name      [kLS_AppInfoDictionary objectForKey:@"CFBundleDisplayName"]
///APP版本  Version版本
#define kLS_App_version   [kLS_AppInfoDictionary objectForKey:@"CFBundleShortVersionString"]
///app      build版本
#define kLA_App_bulidVersion  [infoDictionary objectForKey:@"CFBundleVersion"]


/********************************** 识别设备和操作系统 *************************************/
/// 用户为设备设置的名称 ar name: String                             设备的名称。                     e.g. "My iPhone"
#define kLS_DeviceName [[UIDevice currentDevice] name]
/// 当前操作系统名称                                                                                                        e.g. @"iOS"
#define kLS_SystemName [[UIDevice currentDevice] systemName]
/// 操作系统的当前版本。var systemVersion: String               操作系统的当前版本。    e.g. @"4.0"
#define kLS_SystemVersion [[UIDevice currentDevice] systemVersion]
/// //var model: String                                                             设备的型号。                  e.g. @"iPhone", @"iPod touch"
#define kLS_Model [[UIDevice currentDevice] model]
/// 地方型号（国际化区域名称) var localizedModel: String      设备作为本地化字符串的模型。。
#define kLS_LocalizePhoneModel [[UIDevice currentDevice] localizedModel]
/// var userInterfaceIdiom: UIUserInterfaceIdiom                      当前设备上要使用的接口样式。
#define kLS_UserInterfaceIdiom [[UIDevice currentDevice] userInterfaceIdiom]
/// 手机序列号 UUID var identifierForVendor: UUID?                           一个字母数字字符串，唯一地标识应用程序供应商的设备。
#define kLS_IdentifierForVendor [[UIDevice currentDevice] identifierForVendor]
/// UUID 每次获取都不一样
#define kLS_UUID ([[NSUUID UUID] UUIDString])



///获取当前语言
#define kLS_GetCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//设备的 DeviceToken
#define kLS_DeviceToken @"DeviceToken"


/// 禁止手机睡眠
#define kLS_PhoneDisabledSleep [UIApplication sharedApplication].idleTimerDisabled = YES;

/**
 [[UIScreen mainScreen] scale]是计算屏幕分辨率的
 [[UIScreen main] scale] == 1; //代表320 x 480 的分辨率（就是iphone4之前的设备，非Retain屏幕）
 [[UIScreen main] scale] == 2; //代表640 x 960 的分辨率（Retain屏幕）
 [[UIScreen main] scale] == 3; //代表1242 x 2208 的分辨率
 
 用 [[UIScreen mainScreen] scale]  可以知道使用@2x 图片还是@3x图片
 */

///屏幕分辨率
#define kLS_Screen_resolution (kLS_ScreenWidth * kLS_ScreenHeight * ([UIScreen mainScreen].scale))
/// 设备分辨率、系统分辨率
#define kLS_Device_resolution CGSizeMake(kLS_ScreenWidth * ([UIScreen mainScreen].scale), (kLS_ScreenHeight * ([UIScreen mainScreen].scale)))
/// 设备分辨率、系统分辨率
#define kLS_Device_resolution_str [NSString stringWithFormat:@"%.0f*%.0f", (kLS_ScreenWidth * [UIScreen mainScreen].scale), (kLS_ScreenHeight * [UIScreen mainScreen].scale)];


///获取系统时间戳
#define kLS_GetCurentTime [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]]

//获取一段时间间隔
#define kLS_StartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kLS_EndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
///打印当前方法的名称。ittd print method name
#define kLS_PrintCurrentMethodName()   NSLog(@"当前方法名：%s", __PRETTY_FUNCTION__)

/// 本地化字符串
/** NSLocalizedString宏做的其实就是在当前bundle中查找资源文件名“Localizable.strings”(参数:键＋注释) */
#define kLS_LocalString(x, ...)     NSLocalizedString(x, nil)
/** NSLocalizedStringFromTable宏做的其实就是在当前bundle中查找资源文件名“xxx.strings”(参数:键＋文件名＋注释) */
#define kLS_AppLocalString(x, ...)  NSLocalizedStringFromTable(x, @"someName", nil)


/* ******************图片 的宏定义 -- 优先使用前两种宏定义,性能高于后面***********************/
///读取本地图片 定义UIImage对象 ext可为nil imgView.image = kLSLoadLocalImage(@"Default.png",nil);
#define kLS_LoadLocalImage(file,ext) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:file ofType:ext]]
//定义UIImage对象
#define kLS_ImageNamed(imageName) [UIImage imageNamed:[UIUtil imageName:imageName]]
//可拉伸的图片
#define kLS_ResizableImage(name,top,left,bottom,right) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right)]
#define kLS_ResizableImageWithMode(name,top,left,bottom,right,mode) [[UIImage imageNamed:name] resizableImageWithCapInsets:UIEdgeInsetsMake(top,left,bottom,right) resizingMode:mode]


// 文件管理单例
#define kLS_FileManager [NSFileManager defaultManager]
//获取temp
#define kLS_PathTemp NSTemporaryDirectory()
//获取沙盒 Document
#define kLS_PathDocument [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]
//获取沙盒 Cache
#define kLS_PathCache [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]


//获取系统对象
#define kLS_Application        [UIApplication sharedApplication]
#define kLS_AppDelegate        [UIApplication sharedApplication].delegate
#define kLS_AppDelegateWindow  (kLS_AppDelegate.window) ? (kLS_AppDelegate.window) : (kLS_Application.keyWindow)
#define kLS_RootViewController kLS_AppDelegateWindow.rootViewController
#define kLS_UserDefaults       [NSUserDefaults standardUserDefaults]
#define kLS_NotificationCenter [NSNotificationCenter defaultCenter]



//View 圆角和加边框
#define kLS_ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define kLS_ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]


//角度转弧度
#define kLS_Angle_To_Radians(angle) (angle * M_PI / 180)
//由弧度获取角度
#define kLS_radian_To_Angle(radian) (radian*180.0)/(M_PI)
//拼接字符串
#define kLS_NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]


///修改textField的placeholder的字体颜色、大小
//#define kLS_changeTextFieldPlaceholderColor(textField, color) [textField setValue:color forKeyPath:@"_placeholderLabel.textColor"]
#define kLS_changeTextFieldPlaceholderColor(textField, color, font)\
if (@available(iOS 13.0, *)) {\
textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:(textField.placeholder.length > 0 ? textField.placeholder : @" ") attributes:@{NSForegroundColorAttributeName:color, NSFontAttributeName:font}];\
} else {\
[textField setValue:color forKeyPath:@"_placeholderLabel.textColor"];\
[textField setValue:font forKeyPath:@"_placeholderLabel.font"];\
}
//#define kLS_changeTextFieldPlaceholderFont(textField, font) [textField setValue:font forKeyPath:@"_placeholderLabel.font"]


//openUrlString 打开网址
#define kLS_OpenUrlString(urlString)\
    NSURL *str_URL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", urlString]];\
    if ([[UIApplication sharedApplication] canOpenURL:str_URL]) {\
        if(@available(iOS 10.0, *)) {\
            [[UIApplication sharedApplication] openURL:str_URL options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];\
        } else {\
            [[UIApplication sharedApplication] openURL:str_URL];\
        }\
    } else {\
        NSLog(@"不能打开的地址urlString：%@", urlString);\
    }
//openUrl 打开网址
#define kLS_OpenUrl(Url)\
    if ([[UIApplication sharedApplication] canOpenURL:Url]) {\
        if(@available(iOS 10.0, *)) {\
            [[UIApplication sharedApplication] openURL:Url options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];\
        } else {\
            [[UIApplication sharedApplication] openURL:Url];\
        }\
    } else {\
        NSLog(@"不能打开的地址url：%@", Url);\
    }

// 打电话
#define kLS_CallPhone(phoneNumber)\
    if (!phoneNumber) {\
        NSLog(@"手机号码是空的");\
        return;\
    }\
    NSString * phoneStr = [NSString stringWithFormat:@"tel:%@",phoneNumber];\
    NSURL *takePhoneUrl = [NSURL URLWithString:phoneStr];\
    if ([[UIApplication sharedApplication] canOpenURL:takePhoneUrl]) {\
        if(@available(iOS 10.0, *)) {\
            [[UIApplication sharedApplication] openURL:takePhoneUrl options:@{UIApplicationOpenURLOptionsSourceApplicationKey:@YES} completionHandler:nil];\
        } else {\
            [[UIApplication sharedApplication] openURL:str_URL];\
        }\
    }



//打开appStore中的应用 https://itunes.apple.com/cn/app/idxxxxx?mt=8
// 当前app 在 appStore中的下载地址 1515655040
#define kLS_currentApplicationInAppStoreDownloadAddress(appleID) [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/id%@?mt=8", appleID]

//版本比较
#define kLS_VersionCompare(v1, v2)\
if ([v1 compare:v2 options:NSNumericSearch] == NSOrderedDescending) {\
    NSLog(@"v1 > v2 (当前版本是最新)");\
} else if ([v1 compare:v2 options:NSNumericSearch] == NSOrderedSame) {\
    NSLog(@"相同");\
} else {\
    NSLog(@"v1 < v2 (有新版本)");\
}


/******************************************************************************************************************************************************************************************************/

/// Xib 注册tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
#define kLS_tableViewCellSectionHeaderFooterView_registerNib(tableView, headerFooterViewName, headerFooterViewNameId) \
                        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([headerFooterViewName class]) bundle:nil] forHeaderFooterViewReuseIdentifier:headerFooterViewNameId];
/// 纯代码 注册tableViewCellSectionHeaderView、tableViewCellSectionFooterView
#define kLS_tableViewCellSectionHeaderFooterView_registerClass(tableView, headerFooterViewName) \
                        [tableView registerClass:[headerFooterViewName class] forHeaderFooterViewReuseIdentifier:k##headerFooterViewName##Id];
/// Xib 注册tableViewCellSectionFooterView
//#define kLS_tableViewCellSectionFooterView_registerNib(tableView, footerViewName, footerViewId) \
                        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([footerViewName class]) bundle:nil] forHeaderFooterViewReuseIdentifier:footerViewId];
/// Xib 注册tableViewCell
#define kLS_tableViewCell_registerNib(tableView, cellName, cellIdentifiter) \
                        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellReuseIdentifier:cellIdentifiter]
///纯代码注册 tableViewCell
#define kLS_tableViewCell_registerClass(tableView, cellName, cellID) \
                         [tableView registerClass:[cellName class] forCellReuseIdentifier:cellID];
///从缓存池获取 tableViewCell
#define kLS_tableViewCell_getFromCachePool(cellIdentifiter) \
                         [tableView dequeueReusableCellWithIdentifier:cellIdentifiter forIndexPath:indexPath];
///从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
#define kkLS_tableViewCellSectionHeaderFooterView_getFromCachePool(kHeaderFooterViewNameId) [tableView dequeueReusableHeaderFooterViewWithIdentifier:kHeaderFooterViewNameId];


/// Xib 注册collectionViewCell
#define kLS_collectionViewCell_registerNib(collectionView, cellName, cellIdentifiter) \
                         [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellWithReuseIdentifier:cellIdentifiter];
///纯代码注册 collectionViewCell
#define kLS_collectionViewCell_registerClass(collectionView, cellName, cellIdentifiter) \
                         [collectionView registerClass:[cellName class] forCellWithReuseIdentifier:cellIdentifiter];
///从缓存池获取 collectionViewCell
#define kLS_collectionViewCell_getFromCachePool(cellIdentifiter) \
                         [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifiter forIndexPath:indexPath];


/// Xib 加载View
#define kLS_loadViewFromNibName(ViewName) \
                         [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ViewName class]) owner:self options:nil] firstObject];


/// Xib 注册tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
#define kLS_tableViewCellSectionHeaderFooterView_registerNib_(tableView, headerViewName) \
                        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([headerViewName class]) bundle:nil] forHeaderFooterViewReuseIdentifier:k##headerViewName##Id];
/// 纯代码 注册tableViewCellSectionHeaderView、tableViewCellSectionFooterView
#define kLS_tableViewCellSectionHeaderFooterView_registerClass_(tableView, headerViewName) \
                        [tableView registerClass:[headerViewName class] forHeaderFooterViewReuseIdentifier:k##headerViewName##Id];
///  Xib 注册tableViewCell
#define kLS_tableViewCell_registerNib_(tableView, cellName) \
                        [tableView registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellReuseIdentifier:k##cellName##Id]
///纯代码注册 tableViewCell cellID     kCellNameId 形式
#define kLS_tableViewCell_registerClass_(tableView, cellName) \
                         [tableView registerClass:[cellName class] forCellReuseIdentifier:k##cellName##Id];
/// Xib 注册collectionViewCell
#define kLS_collectionViewCell_registerNib_(collectionView, cellName) \
                        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([cellName class]) bundle:nil] forCellWithReuseIdentifier:k##cellName##Id];
///纯代码注册 collectionViewCell
#define kLS_collectionViewCell_registerClass_(collectionView, cellName) \
                        [collectionView registerClass:[cellName class] forCellWithReuseIdentifier:k##cellName##Id];

///从缓存池获取 tableViewCell
#define kLS_tableViewCell_getFromCachePool_(cellName) \
                        [tableView dequeueReusableCellWithIdentifier:k##cellName##Id forIndexPath:indexPath];
///从缓存池获取 tableViewCellSectionHeaderView、 tableViewCellSectionFooterView
#define kkLS_tableViewCellSectionHeaderFooterView_getFromCachePool_(headerFooterViewName) \
                        [tableView dequeueReusableHeaderFooterViewWithIdentifier:k##headerFooterViewName##Id];

///从缓存池获取 collectionViewCell
#define kLS_collectionViewCell_getFromCachePool_(cellName) \
                        [collectionView dequeueReusableCellWithReuseIdentifier:k##cellName##Id forIndexPath:indexPath];

/******************************************************************************************************************************************************************************************************/

/// 从当前导航栏 nav 中移除当前VC
#define dismissCurrentVc(targetVc) \
{\
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy;\
    [childsVcs removeObject:targetVc];\
    targetVc.navigationController.viewControllers = childsVcs;\
}
/// 从当前导航栏 nav 中移除当前VC
#define dismissCurrentVcAnimation(targetVc) \
{ \
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy;\
    [childsVcs removeObject:targetVc];\
    [targetVc.navigationController setViewControllers:childsVcs animated:YES];\
}

///  移除导航栏 nav 中间的所有VC， 只保留第一个和最后一个Vc
#define bringVctoFront(targetVc) \
{\
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy;\
    NSMutableArray *remainChildVcs = [NSMutableArray array];\
    [remainChildVcs addObject:[childsVcs firstObject]];\
    [remainChildVcs addObject:[childsVcs lastObject]];\
    targetVc.navigationController.viewControllers = remainChildVcs;\
}

/// 从targetVc 所在的导航控制器Nav中 移除某个vc
#define removeCurrentVC(targetVc) { \
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy; \
    [childsVcs removeObject:targetVc]; \
    targetVc.navigationController.viewControllers = childsVcs; \
}
/// 从targetVc 所在的导航控制器Nav中 移除某个vc
#define removeCurrentVcAnimation(targetVc) { \
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy; \
    [childsVcs removeObject:targetVc]; \
    [targetVc.navigationController setViewControllers:childsVcs animated:YES]; \
}
/// 保留 targetVc 所在导航条Nav 中的第一个和最后一个VC,其余的全部移除
#define retainTargetVcWhereNavFirstAndLastVC(targetVc) { \
    NSMutableArray *childsVcs = targetVc.navigationController.viewControllers.mutableCopy; \
    NSMutableArray *remainChildVcs = [NSMutableArray array]; \
    [remainChildVcs addObject:[childsVcs firstObject]]; \
    [remainChildVcs addObject:[childsVcs lastObject]]; \
    targetVc.navigationController.viewControllers = remainChildVcs; \
}

/// 更改tabBar 选中的下标
#define changeTabBarControllerSelectIndex(index) [(UITabBarController *)kLS_AppDelegateWindow.rootViewController setSelectedIndex:index]


/******************************************************************************************************************************************************************************************************/


///去除数组中重复的对象
#define kLS_RemoveDuplicateObjectsFromArray(oldArray) [oldArray valueForKeyPath:@"@distinctUnionOfObjects.self"];


//数据验证
#define StrValid(f) (f!=nil && [f isKindOfClass:[NSString class]] && ![f isEqualToString:@""])
#define SafeStr(f) (StrValid(f) ? f:@"")
#define HasString(str,key) ([str rangeOfString:key].location!=NSNotFound)

#define ValidStr(f) StrValid(f)
#define ValidDict(f) (f!=nil && [f isKindOfClass:[NSDictionary class]])
#define ValidArray(f) (f!=nil && [f isKindOfClass:[NSArray class]] && [f count]>0)
#define ValidNum(f) (f!=nil && [f isKindOfClass:[NSNumber class]])
#define ValidClass(f,cls) (f!=nil && [f isKindOfClass:[cls class]])
#define ValidData(f) (f!=nil && [f isKindOfClass:[NSData class]])

#pragma mark - Judge 判断
// 判断它是否是空字符串。
// 判断它是否是空字符串。undefined
#define kLS_IsEmptyString(str) ((str == nil) || [str isKindOfClass:[NSNull class]] || (str == NULL) || ([str isEqualToString:@"null"])  || ([str isEqualToString:@"<null>"]) || ([str isEqualToString:@"<NULL>"]) || ([str isEqualToString:@"(null)"]) || ([str isEqualToString:@"(NULL)"]) || ([str isEqualToString:@"undefined"]) || ([str isKindOfClass:[NSString class]] && str.length <= 0))
// 判断它是否为nil或null对象。
#define kLS_IsEmptyObject(obj) ((obj == nil) || (obj == NULL) || [obj isKindOfClass:[NSNull class]])
// 判断它是否是一个有效的字典。
#define kLS_IsDictionary(objDict) (objDict != nil && [objDict isKindOfClass:[NSDictionary class]])
// 判断它是否是一个有效的数组。
#define kLS_IsArray(objArray) (objArray != nil && [objArray isKindOfClass:[NSArray class]])

///获取安全的字符串
#define kLS_GetString(Str) (kLS_IsEmptyString(Str) ? @"" : [NSString stringWithFormat:@"%@", Str])
#define kLS_IntegerToStr(num) ([NSString stringWithFormat:@"%ld", (long)num])
#define CHECK_VALUE(str) (kLS_IsEmptyString(str) ? @"" : [NSString stringWithFormat:@"%@", str])

#define ChangeNSIntegerToStr(num) [NSString stringWithFormat:@"%d", num]
#define GET_SD_IMAGE_URL(str) [NSURL URLWithString:[NSString stringWithFormat:@"%@", str]]

#define GetImgWithUrl(url) [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]]


// 当我们使用kvo或者做动画的时候需要使用keyPath，但是keyPath是字符串类型，为了防止输入错误，我们可以使用下面的自动提示宏
// 自动提示宏如下：
//自动提示宏：就是在输入宏的时候有提示功能 自动提示宏：（objc.keyPath）这一部分内容，仅仅是让你的宏具有提示功能
#define keyPath(objc,keyPath) @(((void)objc.keyPath, #keyPath))
//接下来简单对这个宏定义进行解释:
//- 宏定义里面的#号，会自动把后面的参数变成C语言的字符串
//- @(基本类型)可以对基本类型进行装箱操作（也就是基本类型转换为OC的对象）
//- 对于逗号表达式，例如：`(5, 10, 2)`会去最后一个值，为了防止前面两个值因为没有使用报警告可以这样写((void)5, (void)10, 2)，这个括号相当于return 2,所以为了把整个值转变成对象类型可以再加一个括号@(((void)5, (void)10, 2))
//- 对于@(((void)objc.keyPath, #keyPath))来说就是取keyPath位置的字符串



#pragma mark - System Singletons  单例
// 简化通知
#define kLS_PostNotificationWithName(notificationName) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:nil]
// 简化通知
#define kLS_PostNotificationWithNameAndUserInfo(notificationName, userInfo) \
[kNotificationCenter postNotificationName:notificationName object:nil userInfo:userInfo]
//单例化一个类
#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface MacroDefinition : NSObject
/*
 NS_ASSUME_NONNULL_BEGIN和NS_ASSUME_NONNULL_END。
 在这两个宏之间的代码，所有简单指针对象都被假定为nonnull(不能为空)，因此我们只需要去指定那些nullable(可以为空)的指针
 */
@end
NS_ASSUME_NONNULL_END


