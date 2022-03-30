//
//  YYLabel+LXLAdpativeFont.m
//  Pension
//
//  Created by 刘晓龙 on 2021/12/21.
//  Copyright © 2021 ouba. All rights reserved.
//

#import "YYLabel+LXLAdpativeFont.h"
#import "NSObject+KJRuntime.h"


@implementation YYLabel (LXLAdpativeFont)


+ (void)load
{
//    [[self class] runtimeReplaceFunctionWithSelector:@selector(initWithCoder:) swizzleSelector:@selector(customInitWithCoder:) isClassMethod:NO];
    
    kRuntimeMethodSwizzling([self class], @selector(initWithCoder:), @selector(customInitWithCoder:));
}

- (instancetype)customInitWithCoder:(NSCoder *)coder
{
    if ([self customInitWithCoder:coder]) {
        ///此时调用fontWithName:size:方法，实际上调用的是方法交换后的customFontWithName:size:
        self.font = [UIFont fontWithName:self.font.familyName size:self.font.pointSize];
    }
    return self;
}


@end
