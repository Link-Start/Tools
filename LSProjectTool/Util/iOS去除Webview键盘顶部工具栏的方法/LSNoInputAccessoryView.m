//
// LSNoInputAccessoryView.m
// Pension
//
// reated by 刘晓龙 on 2021/9/9.
// Copyright © 2021 ouba. All rights reserved.
//


#import "LSNoInputAccessoryView.h"
#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@implementation LSNoInputAccessoryView

- (id)inputAccessoryView{
    return nil;
}

///：去掉 wkwebviewe done 工具栏
- (void)removeInputAccessoryViewFromWKWebView:(WKWebView *)webView {
    UIView *targetView;
    for (UIView *view in webView.scrollView.subviews) {
        if([[view.class description] hasPrefix:@"WKContent"]) {
            targetView = view;
        }
    }
    if (!targetView) {
        return;
    }
    NSString *noInputAccessoryViewClassName = [NSString stringWithFormat:@"%@_LSNoInputAccessoryView", targetView.class.superclass];
    Class newClass = NSClassFromString(noInputAccessoryViewClassName);
    if(newClass == nil) {
        newClass = objc_allocateClassPair(targetView.class, [noInputAccessoryViewClassName cStringUsingEncoding:NSASCIIStringEncoding], 0);
        if(!newClass) {
            return;
        }
        Method method = class_getInstanceMethod([LSNoInputAccessoryView class], @selector(inputAccessoryView));
        class_addMethod(newClass, @selector(inputAccessoryView), method_getImplementation(method), method_getTypeEncoding(method));
        objc_registerClassPair(newClass);
    }
    object_setClass(targetView, newClass);
}

@end
