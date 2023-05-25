//
//  UIViewController+initializemethod.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2022/5/26.
//  Copyright © 2022 Link-Start. All rights reserved.
//

#import "UIViewController+initializemethod.h"
#import "NSObject+KJRuntime.h"


@implementation UIViewController (initializemethod)


+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kRuntimeMethodSwizzling([self class], @selector(presentViewController:animated:completion:), @selector(jt_presentViewController:animated:completion:));

    });

    
//    kRuntimeClassMethodSwizzling([self class], @selector(systemFontOfSize:), @selector(customSystemFontOfSize:));

    
//    Method originalMethod = class_getInstanceMethod(self, @selector(presentAnimated:completionHandler:));
//    Method swizzledMethod = class_getInstanceMethod(self, @selector(jt_presentAnimated:completionHandler:));
//
//    if (class_addMethod(self, original, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod))) {
//        class_replaceMethod(clazz, swizzled, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
}


- (void)jt_presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion {
    
    //// 在这里判断是否是更换icon时的弹出框
    if ([viewControllerToPresent isKindOfClass:[UIAlertController class]]) {
        NSString *alertTitle = ((UIAlertController *)viewControllerToPresent).title;
        NSString *alertMessage = ((UIAlertController *)viewControllerToPresent).message;
        
        //// 更换icon时的弹出框，这两个string都为nil。
        if (alertTitle == nil && alertMessage == nil) {
            return;
        }
        
    }
    
    //因为方法已经交换，这个地方的调用就相当于调用原先系统的 present
//        [self jt_presentViewController:viewControllerToPresent animated:flag completion:completion];

}

@end
