//
//  NSTimer+BlockTimer.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/18.
//  Copyright © 2021 Link-Start. All rights reserved.
//

//https://www.jianshu.com/p/5fb71be280e0
//打破timer对target的强引用。
//方式一：来自《Effective Objective-C》第52条：别忘了NSTimer会保留其目标对象

/**
 - (void)viewDidLoad {
     [super viewDidLoad];
     __weak id weakSelf = self;
     NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer *timer) {
         NSLog(@"block %@",weakSelf);
     }];
 }
 
 
 解释：将强引用的target变成了NSTimer的类对象。类对象本身是单例的，是不会释放的，所以强引用也无所谓。执行的block通过userInfo传递给定时器的响应函数timered:。循环引用被打破的结果是：

 timer的使用者强引用timer。
 timer强引用NSTimer的类对象。
 timer的使用者在block中通过weak的形式使用，因此是被timer弱引用。

 */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (BlockTimer)

+ (NSTimer*)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats blockTimer:(void (^)(NSTimer *))block;



@end

NS_ASSUME_NONNULL_END
