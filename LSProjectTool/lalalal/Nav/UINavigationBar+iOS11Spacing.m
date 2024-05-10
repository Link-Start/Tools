//
//  UINavigationBar+iOS11Spacing.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2024/3/25.
//  Copyright © 2024 Link-Start. All rights reserved.
//

#import "UINavigationBar+iOS11Spacing.h"
#import <objc/runtime.h>


#define kSpacerWidth kLS_relative_Width(15)

@implementation UINavigationBar (iOS11Spacing)


+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethodWithOriginSel:@selector(layoutSubviews) swizzledSel:@selector(sx_layoutSubviews)];
    });
}


+ (void)swizzleInstanceMethodWithOriginSel:(SEL)oriSel swizzledSel:(SEL)swiSel {
    
    Method originAddObserverMethod = class_getInstanceMethod(self, oriSel);
    Method swizzledAddObserverMethod = class_getInstanceMethod(self, swiSel);
    
    [self swizzleMethodWithOriginSel:oriSel oriMethod:originAddObserverMethod swizzledSel:swiSel swizzledMethod:swizzledAddObserverMethod class:self];
}

+ (void)swizzleMethodWithOriginSel:(SEL)oriSel oriMethod:(Method)oriMethod swizzledSel:(SEL)swizzledSel swizzledMethod:(Method)swizzledMethod class:(Class)cls {
    
    BOOL didAddMethod = class_addMethod(cls, oriSel, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls, swizzledSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    } else {
        method_exchangeImplementations(oriMethod, swizzledMethod);
    }
}


- (void)sx_layoutSubviews {
    
    [self sx_layoutSubviews];
    
    if(@available(iOS 11.0, *)) {
        
        if (kSpacerWidth) {
            return;
        }
        
        // 需要调节
        self.layoutMargins = UIEdgeInsetsZero;
        CGFloat space = kSpacerWidth;
        for (UIView *subViews in self.subviews) {
            if ([NSStringFromClass(subViews.class) containsString:@"contentView"]) {
                subViews.layoutMargins = UIEdgeInsetsMake(0, space, 0, space);//可修正iOS11之后的偏移,
            }
            continue;
        }
    }
}






@end
