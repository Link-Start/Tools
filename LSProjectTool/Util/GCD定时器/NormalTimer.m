//
//  NormalTimer.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/18.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "NormalTimer.h"

@implementation NormalTimer


- (void)timered:(NSTimer*)timer{
    [self.target performSelector:self.selector withObject:timer];
}


- (void)dealloc{
    NSLog(@"timer dealloc");
}

@end


@implementation NSTimer(NormalTimer)
+ (NSTimer *)scheduledNormalTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    NormalTimer* normalTimer = [[NormalTimer alloc] init];
    normalTimer.target = aTarget;
    normalTimer.selector = aSelector;
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:ti target:normalTimer selector:@selector(timered:) userInfo:userInfo repeats:yesOrNo];
    return timer;
}
@end
