//
//  LSLayoutTool.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/11/29.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "LSLayoutTool.h"

@implementation LSLayoutTool


/// 适配手机和平板的宽度
- (CGFloat)autoWidth {
    
//    if ([self lxl_isLandspace]) {
//        <#statements#>
//    }
//    if ([UIApplication sharedApplication].statusBarOrientation) {
//        <#statements#>
//    }

    return 0;
}


- (BOOL)lxl_isLandspace {
    return (UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationLandscapeRight) || (UIApplication.sharedApplication.statusBarOrientation == UIDeviceOrientationLandscapeLeft);
}

/// 适配手机和平板的高度
/// 系统字号

@end
