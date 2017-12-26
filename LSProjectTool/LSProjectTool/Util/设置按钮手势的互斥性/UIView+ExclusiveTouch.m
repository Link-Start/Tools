//
//  UIView+ExclusiveTouch.m
//  ExclusiveTouchDemo
//
//  Created by wangyongkang on 17/6/19.
//  Copyright © 2017年 王永康. All rights reserved.
//

#import "UIView+ExclusiveTouch.h"
#import <objc/runtime.h>

@implementation UIView (ExclusiveTouch)

@dynamic ygExclusiveTouch;

static const void *ygETKeyName = "ygExclusiveTouch";

#pragma mark - BOOL类型的动态绑定
- (BOOL)ygExclusiveTouch
{
    return [objc_getAssociatedObject(self, ygETKeyName) boolValue];
}

- (void)setYgExclusiveTouch:(BOOL)ygExclusiveTouch
{
    self.exclusiveTouch = ygExclusiveTouch;
    objc_setAssociatedObject(self, ygETKeyName, [NSNumber numberWithBool:ygExclusiveTouch], OBJC_ASSOCIATION_ASSIGN);
}

@end
