//
//  LSCountDown.h
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/13.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSCountDown : NSObject


/**
 倒计时：指定时间 与 当前时间之间的倒计时

 @param startDate 指定时间
 @param getDays   返回指定时间与当前时间之间相差的 天  数
 @param getHours  返回指定时间与当前时间之间相差的 小时 数
 @param getMinute 返回指定时间与当前时间之间相差的 分钟 数
 @param getSecond 返回指定时间与当前时间之间相差的 秒  数
 */
- (void)getCountDownWithStartDate:(NSDate *)startDate getDays:(void(^)(NSString *days))getDays getHours:(void(^)(NSString *hours))getHours getMinute:(void(^)(NSString *minute))getMinute getSecond:(void(^)(NSString *second))getSecond;
@end
