////
////  NSObject+LSMethodSwizzling.h
////  LSProjectTool
////
////  Created by 刘晓龙 on 2021/7/1.
////  Copyright © 2021 Link-Start. All rights reserved.
////
//
//#import <Foundation/Foundation.h>
//
//NS_ASSUME_NONNULL_BEGIN
//
//@interface NSObject (LSMethodSwizzling)
//
///// 交换两个类方法的实现
///// @param originalSelector  原始方法的 SEL
///// @param swizzledSelector  交换方法的 SEL
///// @param targetClass 类
//+ (void)ls_defenderSwizzlingClassMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;
///// 交换两个对象方法的实现
///// @param originalSelector  原始方法的 SEL
///// @param swizzledSelector  交换方法的 SEL
///// @param targetClass  类
//+ (void)ls_defenderSwizzlingInstanceMethod:(SEL)originalSelector withMethod:(SEL)swizzledSelector withClass:(Class)targetClass;
//
//@end
//
//NS_ASSUME_NONNULL_END
