//
//  sssss.h
//  LSProjectTool
//
//  Created by Alex Yang on 2017/12/24.
//  Copyright © 2017年 Link-Start. All rights reserved.
//

#ifndef sssss_h
#define sssss_h

如何实现并发执行多个网络请求，统一处理？

本方案中，利用GCD创建队列组，提交多个任务到队列组，多个任务同时执行，监听队列组执行完毕，在主线程刷新UI。
注意： dispatch_group_enter() 、 dispatch_group_leave()将队列组中的任务未执行完毕的任务数目加减1（两个函数要配合使用）

示例：

- (void)exampleMoreNetwork{
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t serialQueue = dispatch_queue_create("magic_gcd_group", DISPATCH_QUEUE_SERIAL);
    
    // 网络请求1
    dispatch_group_enter(group);
    dispatch_group_async(group, serialQueue, ^{
        [[MagicNetworkManager shareManager] GET:@"网络请求1" Parameters:nil Success:^(NSURLResponse *response, id responseObject) {
            dispatch_group_leave(group);
        } Failure:^(NSURLResponse *response, id error) {
            dispatch_group_leave(group);
        }];
    });
    
    // 网络请求2
    dispatch_group_enter(group);
    dispatch_group_async(group, serialQueue, ^{
        [[MagicNetworkManager shareManager] GET:@"网络请求2" Parameters:nil Success:^(NSURLResponse *response, id responseObject) {
            dispatch_group_leave(group);
        } Failure:^(NSURLResponse *response, id error) {
            dispatch_group_leave(group);
        }];
    });
    
    // 所有网络请求结束
    dispatch_group_notify(group, serialQueue, ^{
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                // 主线程刷新UI
            });
        });
    });
    
}


#endif /* sssss_h */
