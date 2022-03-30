//
//  UITextField+LXLAdpativeFont.m
//  Pension
//
//  Created by 刘晓龙 on 2021/12/20.
//  Copyright © 2021 ouba. All rights reserved.
//

#import "UITextField+LXLAdpativeFont.h"
#import "NSObject+KJRuntime.h"


@implementation UITextField (LXLAdpativeFont)




+ (void)load
{
//    [[self class] runtimeReplaceFunctionWithSelector:@selector(initWithCoder:) swizzleSelector:@selector(customInitWithCoder:) isClassMethod:NO];
    
    kRuntimeMethodSwizzling([self class], @selector(initWithCoder:), @selector(customInitWithCoder:));

}

- (instancetype)customInitWithCoder:(NSCoder *)coder
{
    if ([self customInitWithCoder:coder]) {
        self.font = [UIFont fontWithName:self.font.familyName size:self.font.pointSize];
    }
    return self;
}

@end
