//
//  DefineModel.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/26.
//  Copyright © 2017年 Link-Start. All rights reserved.
//


//判断设备 获取机型

#ifndef DefineModel_h
#define DefineModel_h

//手机型号(是iPhone还是iPad)
#define kPhoneModel [[UIDevice currentDevice] model]
//判断是否为iPhone
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
//判断是否是IPad
#define IsPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//判断是否为ipod
#define IS_IPOD ([[[UIDevice currentDevice] model] isEqualToString:@"iPodtouch"])

///判断是否是    iPhone 4
#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
///判断是否是    iPhone 5
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
//判断是否是     IPhone5
#define IsIPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136),[[UIScreen mainScreen] currentMode].size) : NO)
//判断是否是    iPhone 6
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
//判断是否是     iPhone 6 P
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
//判断是否是     iPhoneX 拿分辨率来判断
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//iPhoneX机型判断 依据屏幕尺寸
#define kDevice_IS__iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)


//判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !IsPad : NO)
//判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !IsPad : NO)
//判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !IsPad : NO)



//由于iPhone X、iPhone XS、iPhone XS Max、iPhone XR这些机型的navigationBar高度以及tabBar高度都一致，所以可以用来判断当前设备是否有“齐刘海”。
///iPhone X、iPhone XS、iPhone XS Max、iPhone XR
#define kDevice_IS_iPhoneX_Series ([[UIApplication sharedApplication] statusBarFrame].size.height>20?YES:NO)







//判断是否是Retina屏
#define isRetina ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)


#endif /* DefineModel_h */
