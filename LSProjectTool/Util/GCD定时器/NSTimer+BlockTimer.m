//
//  NSTimer+BlockTimer.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/18.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "NSTimer+BlockTimer.h"

@implementation NSTimer (BlockTimer)
/*
该方案主要要点：
将计时器所应执行的任务封装成"Block"，在调用计时器函数时，把block作为userInfo参数传进去。
userInfo参数用来存放"不透明值"，只要计时器有效，就会一直保留它。
在传入参数时要通过copy方法，将block拷贝到"堆区"，否则等到稍后要执行它的时候，该blcok可能已经无效了。
计时器现在的target是NSTimer类对象，这是个单例，因此计时器是否会保留它，其实都无所谓。此处依然有保留环，然而因为类对象（class object）无需回收，所以不用担心。
*/

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats blockTimer:(void (^)(NSTimer *))block{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timered:) userInfo:[block copy] repeats:repeats];
    return timer;
}

+ (void)timered:(NSTimer*)timer {
    void (^block)(NSTimer *timer)  = timer.userInfo;
    if (block) {
        block(timer);
    }
    
}




@end
