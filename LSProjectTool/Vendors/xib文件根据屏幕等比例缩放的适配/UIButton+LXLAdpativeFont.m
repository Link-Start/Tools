//
//  UIButton+LXLAdpativeFont.m
//  Pension
//
//  Created by 刘晓龙 on 2021/12/20.
//  Copyright © 2021 ouba. All rights reserved.
//

#import "UIButton+LXLAdpativeFont.h"
#import "NSObject+KJRuntime.h"


@implementation UIButton (LXLAdpativeFont)



+ (void)load
{
//    [[self class] runtimeReplaceFunctionWithSelector:@selector(initWithCoder:) swizzleSelector:@selector(customInitWithCoder:) isClassMethod:NO];
    
    kRuntimeMethodSwizzling([self class], @selector(initWithCoder:), @selector(customInitWithCoder:));

}

- (instancetype)customInitWithCoder:(NSCoder *)coder
{
    if ([self customInitWithCoder:coder]) {
        if (self.titleLabel != nil) {
            self.titleLabel.font = [UIFont fontWithName:self.titleLabel.font.familyName size:self.titleLabel.font.pointSize];
        }
    }
    return self;
}
@end
