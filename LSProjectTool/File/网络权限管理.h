//
//  网络权限管理.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2022/8/30.
//  Copyright © 2022 Link-Start. All rights reserved.
//

#ifndef _______h
#define _______h




检测 iOS 系统网络权限被关闭：
    https://www.jianshu.com/p/81d0b7f06eba

网络权限管理：
    https://www.jianshu.com/p/2d3ef8b72986
    https://www.csdn.net/tags/MtjaAg5sMjE4OS1ibG9n.html

一、iOS网络情况分类：
通过App应用设置网络使用权限（关闭、WLAN、WLAN与蜂窝移动网）
直接设置手机网络情况（飞行模式、无线局域网络、蜂窝移动网络）

二、iOS开发使用到的网络判断类：
AFNetworkReachability或者Reachability来判断网络的可达性，这两个类可以判断网络是否可达，以及可达时网络的类型（WLAN还是蜂窝移动网络）；
CTCellularData来判断网络数据是否受限，只有应用网络权限设置为WLAN与蜂窝移动网时，网络数据才会返回不受限；

三、组合关系：

    权限        飞行模式／关闭网络      局域网        蜂窝移动网络
    关闭         不可达-数据受限   不可达-数据受限  不可达-数据受限
    WLAN        不可达-数据受限    WLAN-数据受限  不可达-数据受限
WLAN和蜂窝移动网  不可达-数据受限    WLAN-数据不受限  WLAN-数据不受限
注：关闭网络，及关闭无线局域网和蜂窝移动网络。

四、特殊说明：
第一次安装应用（之前从未安装过），第一次启动App时，会提示选择网络，选择之后就不会提示选择网络；但有时第一次安装时不出现选择网络，需要在设置中修改任意一个应用的网络权限，然后重启App，就会提示网络（目前没有找到不出现选择网络的原因）；
当网络由可达状态切换到不可达状态后，第一进入App时，系统会提示一次网络权限改变的提示；
修改网络权限时，App不会重启，这个地方与相册授权不同。相册、相机、麦克风等修改权限后返回时，App会重新启动。

五、代码：

CTCellularData *cellularData = [[CTCellularData alloc] init];
cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
        //获取联网权限状态
        switch (state) {
            case kCTCellularDataRestricted:
                // 说明：CTCellularData 只能检测蜂窝权限，不能检测WiFi权限
                // 所以走到这里的两种情况：
                // 1.通过App应用设置网络使用权限：关闭
                // 2.通过App应用设置网络使用权限：WLAN（无论有没有链接WiFi）
                // 所以要根据 AFNetworking/其他工具判断 WLAN的链接状态 ，如果没有没有链接WiFi，弹窗提醒
                
                NSLog(@"权限被关闭 Restricrted");
                break;
                
            case kCTCellularDataNotRestricted:
                // 走到这里情况：1.通过App应用设置网络使用权限：WLAN与蜂窝移动网
                // 这里可以使用 AFNetworking/其他工具判断具体的网络状态
                NSLog(@"权限开启 Not Restricted");
                break;
                
            case kCTCellularDataRestrictedStateUnknown:
                //未知，第一次请求
                NSLog(@"权限未知 Unknown");
                break;
                
            default:
                break;
        };
    };

AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
[mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //获取联网可达状态
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"NetworkingTypeUnknown");
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"NetworkingTypeNotReachable");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"NetworkingTypeReachableViaWWAN");
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"NetworkingTypeReachableViaWiFi");
                break;
                
            default:
                NSLog(@"NetworkingTypeUnknown");
                break;
        }
}];




iOS各种权限状态的获取及注意事项
https://blog.csdn.net/lipengfei_1993/article/details/83860139?utm_term=ios获取网络权限管理&utm_medium=distribute.pc_aggpage_search_result.none-task-blog-2~all~sobaiduweb~default-2-83860139-null-null&spm=3001.4430


联网权限

引入头文件 @import CoreTelephony;
应用启动后，检测应用中是否有联网权限

typedef NS_ENUM(NSUInteger, CTCellularDataRestrictedState) {
  kCTCellularDataRestrictedStateUnknown,//权限未知
  kCTCellularDataRestricted,//权限被关闭，
  kCTCellularDataNotRestricted//权限开启
};
 
  使用时需要注意的关键点：
  CTCellularData  只能检测蜂窝权限，不能检测WiFi权限。
  一个CTCellularData实例新建时，restrictedState是kCTCellularDataRestrictedStateUnknown，
  之后在cellularDataRestrictionDidUpdateNotifier里会有一次回调，此时才能获取到正确的权限状态。
  当用户在设置里更改了app的权限时，cellularDataRestrictionDidUpdateNotifier会收到回调，如果要停止监听，
  必须将 `cellularDataRestrictionDidUpdateNotifier` 设置为nil。
  赋值给cellularDataRestrictionDidUpdateNotifier的block并不会自动释放，
  即便你给一个局部变量的CTCellularData实例设置监听，当权限更改时，还是会收到回调，所以记得将block置nil。
 
 
CTCellularData *cellularData = [[CTCellularData alloc]init];
cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
//获取联网状态
    switch (state)
     {
       case kCTCellularDataRestricted://通过App应用设置网络使用权限（关闭、WLAN）时，会走到这里
                                     // 说明：CTCellularData 只能检测蜂窝权限，不能检测WiFi权限
         NSLog(@"权限被关闭 Restricrted");
         break;
       case kCTCellularDataNotRestricted://通过App应用设置网络使用权限（WLAN与蜂窝移动网）时，会走到这里
         NSLog(@"权限开启 Not Restricted");
         break;
       //未知，第一次请求
       case kCTCellularDataRestrictedStateUnknown:
         NSLog(@"权限未知 Unknown");
         break;
      default:
         break;
     };
 };


查询应用是否有联网功能
CTCellularData *cellularData = [[CTCellularData alloc]init];
CTCellularDataRestrictedState state = cellularData.restrictedState;
switch (state) {
  case kCTCellularDataRestricted://通过App应用设置网络使用权限（关闭、WLAN）时，会走到这里
                                // 说明：CTCellularData 只能检测蜂窝权限，不能检测WiFi权限
        NSLog(@"权限被关闭 Restricrted");
        break;
  case kCTCellularDataNotRestricted://通过App应用设置网络使用权限（WLAN与蜂窝移动网）时，会走到这里
        NSLog(@"权限开启 Not Restricted");
        break;
  case kCTCellularDataRestrictedStateUnknown:
        NSLog(@"权限未知 Unknown");
        break;
    default:
        break;
 }


注意：当应用被设置为不联网，使用的时候，系统会自动弹出警告“xxxx 已被关闭网络”点击可以去设置，自动跳转到设置中心里。
iOS10 国行机第一次安装App时会有一个权限弹框弹出，在允许之前是没有网络的，网上对于现状已有描述和解决方法：
（1）在引导页中诱导出网络权限弹框，这样就不会影响到之后应用的网络请求。
（2）允许用户手动重新请求。出现数据空白时，如果在空白页面上有“重新加载”的按钮。
（3) 允许用户手动重新请求。出现数据空白时，如果在空白页面上有“重新加载”的按钮。














#endif /* _______h */
