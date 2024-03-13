//
//  AMapPrivacyUtility.h
//  officialDemoNavi
//
//  Created by menglong on 2021/10/29.
//  Copyright © 2021 AutoNavi. All rights reserved.
//
//  高德地图开放平台隐私权政策：https://lbs.amap.com/pages/privacy/
//
//
//
// 



#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
 * 隐私合规使用demo 工具类
 */
@interface AMapPrivacyUtility : NSObject

/**
 * @brief 通过这个方法来判断是否同意隐私合规
 * 1.如果没有同意隐私合规，则创建的SDK manager 实例返回 为nil， 无法使用SDK提供的功能
 * 2.如果同意了下次启动不提示 的授权，则不会弹框给用户
 * 3.如果只同意了，则下次启动还要给用户弹框提示
 */
/// 显示，隐私合规信息，弹窗
+ (void)handlePrivacyAgreeStatus;

@end

NS_ASSUME_NONNULL_END

/**
  手动导入 高德地图定位库 AMapFoundationKit.framework和AMapLocationKit.framework 文件
 报错：
 Undefined symbols for architecture arm64:
   "_OBJC_CLASS_$_EAAccessoryManager", referenced from:
       objc-class-ref in AMapLocationKit(AMapLocationKit-arm64-master.o)
 ld: symbol(s) not found for architecture arm64
 clang: error: linker command failed with exit code 1 (use -v to see invocation)
 
 原因：缺少苹果的库：ExternalAccessory.framework
 解决：Target --> Build Phases --> Link Binary With Libraries 添加库 ExternalAccessory.framework
 
 */
