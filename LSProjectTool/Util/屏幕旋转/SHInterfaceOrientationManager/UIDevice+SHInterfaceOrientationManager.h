//
//  UIDevice+InterfaceOrientation.h
//  OraKit
//
//  Created by shaoruibo on 2022/7/29.
//
// https://github.com/quntion/SHInterfaceOrientationManager
// iOS 屏幕旋转状态化管理组件，解决你对屏幕旋转方向管理的一切烦恼~（理想旗舰奢华顶配最终玄幻版）

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIDevice (SHInterfaceOrientationManager)

/// 强制App界面旋转
/// @param orientation 目标方向（如果给定 UIInterfaceOrientationUnknown，则会按照 UIInterfaceOrientationPortrait 替换）
+ (void)ora_forceOrientation:(UIInterfaceOrientation )orientation;

@end

NS_ASSUME_NONNULL_END
