//
//  ProxyObject.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/18.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "ProxyObject.h"

@implementation ProxyObject

+ (instancetype)proxyWithTarget:(id)target {
    ProxyObject* proxy = [[self class] alloc];
    proxy.target = target;
    return proxy;
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel{
    //消息转发(返回值methodSignature不能为空（调用这个方法的类没有实现这个方法就会为空）)
    return [self.target methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation{
    SEL sel = [invocation selector];
    if ([self.target respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.target];
    }
}

- (void)dealloc{
    NSLog(@"weakTimer------释放");
}

+ (NSTimer *)weak_lfjScheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    ProxyObject *proxyTimer = [ProxyObject proxyWithTarget:aTarget];
    proxyTimer.target = aTarget;
    return [NSTimer scheduledTimerWithTimeInterval:ti target:proxyTimer selector:aSelector userInfo:userInfo repeats:yesOrNo];
    //NSTimer 持有---->weakTimer 弱引用--->aTarget（当NSTimer 调用invalidate的时候释放weakTimer）
    //NSTimer 的target 都是强引用（即使使用__weak __typeof(&*self)weakself = self  对weakself也是强引用，weakself也会和NSTimer引起循环引用）
}



@end

@implementation ProxyTimer

- (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE(""){
    [anInvocation invokeWithTarget:self.target];
}
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE(""){
    //消息转发(返回值methodSignature不能为空（调用这个方法的类没有实现这个方法就会为空）)
    return [self.target methodSignatureForSelector:aSelector];
}

- (void)dealloc{
    NSLog(@"weakTimer------释放");
}


+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:ti target:[ProxyObject proxyWithTarget:aTarget] selector:aSelector userInfo:userInfo repeats:yesOrNo];
    return timer;
    //NSTimer 持有---->weakTimer 弱引用--->aTarget（当NSTimer 调用invalidate的时候释放weakTimer）
        //NSTimer 的target 都是强引用（即使使用__weak __typeof(&*self)weakself = self  对weakself也是强引用，weakself也会和NSTimer引起循环引用）
}
@end
