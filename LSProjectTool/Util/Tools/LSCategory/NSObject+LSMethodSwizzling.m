////
////  NSObject+LSMethodSwizzling.m
////  LSProjectTool
////
////  Created by 刘晓龙 on 2021/7/1.
////  Copyright © 2021 Link-Start. All rights reserved.
////
//
//#import "NSObject+LSMethodSwizzling.h"
//#import <objc/runtime.h>
//
//@implementation NSObject (LSMethodSwizzling)
//
//// 交换两个类方法的实现
//+ (void)ls_defenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
//    swizzlingClassMethod(targetClass, originalSelector, swizzledSelector);
//}
////交换两个类方法的实现 C 函数
//void swizzlingClassMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
//    Method originalMethod = class_getClassMethod(class, originalSelector);
//    Method swizzledMethod = class_getClassMethod(class, swizzledSelector);
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//// 交换两个对象方法的实现
//+ (void)ls_defenderSwizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass {
//    swizzlingInstanceMethod(targetClass, originalSelector, swizzledSelector);
//}
////交换两个对象方法的实现 C 函数
//void swizzlingInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector) {
//    Method originalMethod = class_getInstanceMethod(class, originalSelector);
//    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
//    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
//    if (didAddMethod) {
//        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
//    } else {
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//
//@end
