//
//  JX_GCDTimer.m
//  TimerComparison
//
//  Created by Joeyxu on 6/12/15.
//  Copyright (c) 2015 com.tencent. All rights reserved.
//

/**
 CADisplayLink是一个能让我们以和屏幕刷新率同步的频率将特定的内容画到屏幕上的定时器类。 CADisplayLink以特定模式注册到runloop后， 每当屏幕显示内容刷新结束的时候，runloop就会向 CADisplayLink指定的target发送一次指定的selector消息， CADisplayLink类对应的selector就会被调用一次。
 NSTimer以指定的模式注册到runloop后，每当设定的周期时间到达后，runloop会向指定的target发送一次指定的selector消息。
 dispatch_source直接和底层内核交互，准确性更高。
 2、精确度
 dispatch_source > CADisplayLink > NSTimer

 3、常见应用

 CADisplayLink使用场合相对专一，适合做UI的不停重绘，比如自定义动画引擎或者视频播放的渲染。
 NSTimer的使用范围要广泛的多，各种需要单次或者循环定时处理的任务都可以使用。
 dispatch_source对计时精确性要求比较高应用。
 ————————————————
 版权声明：本文为CSDN博主「rattanchen」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
 原文链接：https://blog.csdn.net/weixin_38633659/article/details/113870567
 */

#import "JX_GCDTimerManager.h"

@interface JX_GCDTimerManager()
@property (nonatomic, strong) NSMutableDictionary *timerContainer;
@property (nonatomic, strong) NSMutableDictionary *actionBlockCache;
//@property (nonatomic, strong) NSTimer *timer;
@end

@implementation JX_GCDTimerManager

#pragma mark - Public Method

+ (JX_GCDTimerManager *)sharedInstance
{
    static JX_GCDTimerManager *_gcdTimerManager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken,^{
        _gcdTimerManager = [[JX_GCDTimerManager alloc] init];
    });
    
    return _gcdTimerManager;
}

- (void)scheduledDispatchTimerWithName:(NSString *)timerName
                          timeInterval:(double)interval
                                 queue:(dispatch_queue_t)queue
                               repeats:(BOOL)repeats
                          actionOption:(ActionOption)option
                                action:(dispatch_block_t)action
                    returnToMainThread:(dispatch_block_t)returnToMainThread
{
    if (nil == timerName)
        return;
    
    if (nil == queue) //获取一个全局的并发队列
        queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    if (!timer) {
        
        /*定义一个定时器
        第一个参数:说明定时器的类型
        第四个参数:GCD的回调任务添加到那个队列中执行，如果是主队列则在主线程执行*/
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_resume(timer); //开启定时器
        [self.timerContainer setObject:timer forKey:timerName];
    }
    
     /**     *
     第一个参数:给哪个定时器设置时间
     第二个参数:定时器立即启动的开始时间
     第三个参数:定时器开始之后的间隔时间
     第四个参数:定时器间隔时间的精准度,传入0代表最精准,尽量让定时器精准, timer精度为0.1秒
     注意: dispatch 的定时器接收的时间是 纳秒
     */
    dispatch_source_set_timer(timer, dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC), interval * NSEC_PER_SEC, 0.1 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    
    switch (option) {
            
        case AbandonPreviousAction:// 废除同一个timer之前的任务
        {
            /* 移除之前的action */
            [weakSelf removeActionCacheForTimer:timerName];
            
            //定时器的回调方法
            dispatch_source_set_event_handler(timer, ^{
                action();
                
                //如果定时器不循环调用
                if (!repeats) {
                    [weakSelf cancelTimerWithName:timerName];
                }
            });
        }
            break;
            
        case MergePreviousAction: // 将同一个timer之前的任务合并到新的任务中
        {
            /* cache本次的action */
            [self cacheAction:action forTimer:timerName];
            
            //定时器的回调方法
            dispatch_source_set_event_handler(timer, ^{
                NSMutableArray *actionArray = [self.actionBlockCache objectForKey:timerName];
                [actionArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    dispatch_block_t actionBlock = obj;
                    actionBlock();
                }];
                [weakSelf removeActionCacheForTimer:timerName];
                
                //如果定时器不循环调用
                if (!repeats) {
                    [weakSelf cancelTimerWithName:timerName];
                }
            });
        }
            break;
            
        default:
            break;
    }
    
    //自主线程中修改UI界面
    dispatch_async(dispatch_get_main_queue(), ^{
        if (returnToMainThread) {
            returnToMainThread();
        }
    });
    
}

//取消定时器
- (void)cancelTimerWithName:(NSString *)timerName {
    
    dispatch_source_t timer = [self.timerContainer objectForKey:timerName];
    
    if (!timer) {
        return;
    }
    
    [self.timerContainer removeObjectForKey:timerName];
    dispatch_source_cancel(timer);
    
    [self.actionBlockCache removeObjectForKey:timerName];
}

- (BOOL)existTimer:(NSString *)timerName
{
    if ([self.timerContainer objectForKey:timerName]) {
        return YES;
    }
    return NO;
}

#pragma mark - Property

- (NSMutableDictionary *)timerContainer
{
    if (!_timerContainer) {
        _timerContainer = [[NSMutableDictionary alloc] init];
    }
    return _timerContainer;
}

- (NSMutableDictionary *)actionBlockCache
{
    if (!_actionBlockCache) {
        _actionBlockCache = [[NSMutableDictionary alloc] init];
    }
    return _actionBlockCache;
}

#pragma mark - Action Cache

- (void)cacheAction:(dispatch_block_t)action forTimer:(NSString *)timerName
{
    id actionArray = [self.actionBlockCache objectForKey:timerName];
    
    if (actionArray && [actionArray isKindOfClass:[NSMutableArray class]]) {
        [(NSMutableArray *)actionArray addObject:action];
    }else {
        NSMutableArray *array = [NSMutableArray arrayWithObject:action];
        [self.actionBlockCache setObject:array forKey:timerName];
    }
}

- (void)removeActionCacheForTimer:(NSString *)timerName
{
    if (![self.actionBlockCache objectForKey:timerName])
        return;
    
    [self.actionBlockCache removeObjectForKey:timerName];
}

@end
