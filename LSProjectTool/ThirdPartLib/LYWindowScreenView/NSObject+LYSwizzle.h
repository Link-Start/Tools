//
//  NSObject+LYSwizzle.h
//  bangjob
//
//  Created by langezhao on 2018/12/26.
//  Copyright © 2018年 com.58. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface NSObject (LYSwizzle)

/// 交换实例方法
+ (void)swizzleInstanceSelector:(SEL)originalSelector withNewSelector:(SEL)newSelector;

/// 交换类方法
+ (void)swizzleClassSelector:(SEL)orgSelector withNewSelector:(SEL)newSelector;

@end
