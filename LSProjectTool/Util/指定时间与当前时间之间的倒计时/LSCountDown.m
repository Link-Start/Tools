//
//  LSCountDown.m
//  LSProjectTool
//
//  Created by Alex Yang on 2018/1/13.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import "LSCountDown.h"

@interface LSCountDown ()
{
    dispatch_source_t _ls_timer;
}
@end

@implementation LSCountDown


- (void)getCountDownWithStartDate:(NSDate *)startDate getDays:(void(^)(NSString *days))getDays getHours:(void(^)(NSString *hours))getHours getMinute:(void(^)(NSString *minute))getMinute getSecond:(void(^)(NSString *second))getSecond {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    //结束时间
    NSDate *endDate = [dateFormatter dateFromString:[self getCurrentyyyyMMdd]];
//    NSDate *endDate_tomorrow = [[NSDate alloc] initWithTimeIntervalSinceReferenceDate:([endDate timeIntervalSinceReferenceDate] + 24 * 3600)];
    if (!startDate) {
        startDate = [NSDate date];
    }
    ////获取两个时间的时间差
    NSTimeInterval timeInterval = [endDate timeIntervalSinceDate:startDate];
    
    if (_ls_timer == nil) {
        __block int timeout = timeInterval;//倒计时
        
        if (timeout != 0) {
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            _ls_timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
            dispatch_source_set_timer(_ls_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
            dispatch_source_set_event_handler(_ls_timer, ^{
                if(timeout <= 0){ //倒计时结束，关闭
                    dispatch_source_cancel(_ls_timer);
                    _ls_timer = nil;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (getDays) {
                            getDays(@"");
                        }
                        if (getHours) {
                            getHours(@"00");
                        }
                        if (getMinute) {
                            getMinute(@"00");
                        }
                        if (getSecond) {
                            getSecond(@"00");
                        }
                    });
                } else {
                    int days = (int)(timeout/(3600*24));
                    if (days == 0) {
                        if (getDays) {
                            getDays(@"0");
                        }
                    }
                    int hours = (int)((timeout-days*24*3600)/3600);
                    int minute = (int)(timeout-days*24*3600-hours*3600)/60;
                    int second = timeout-days*24*3600-hours*3600-minute*60;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (days == 0) {
                            if (getDays) {
                                getDays(@"0");
                            }
                        } else {
                            if (getDays) {
                                getDays([NSString stringWithFormat:@"%d",days]);
                            }
                        }
                        if (hours < 10) {
                            if (getHours) {
                                getHours([NSString stringWithFormat:@"0%d",hours]);
                            }
                        } else {
                            if (getHours) {
                                getHours([NSString stringWithFormat:@"%d",hours]);
                            }
                        }
                        if (minute < 10) {
                            if (getMinute) {
                                getMinute([NSString stringWithFormat:@"0%d",minute]);
                            }
                        } else {
                            if (getMinute) {
                                getMinute([NSString stringWithFormat:@"%d",minute]);
                            }
                        }
                        if (second < 10) {
                            if (getSecond) {
                                getSecond([NSString stringWithFormat:@"0%d",second]);
                            }
                        } else {
                            if (getSecond) {
                                getSecond([NSString stringWithFormat:@"%d",second]);
                            }
                        }
                    });
                    timeout--;
                }
            });
            dispatch_resume(_ls_timer);
        }
    }
}

/**
 *  获取当天的年月日的字符串
 *  这里测试用
 *  @return 格式为年-月-日
 */
- (NSString *)getCurrentyyyyMMdd {
    // date方法返回的就是当前时间(now)
    NSDate *now = [NSDate date];
    NSDateFormatter *formateDay = [[NSDateFormatter alloc] init];
    formateDay.dateFormat = @"yyyy-MM-dd";
    NSString *dayStr = [formateDay stringFromDate:now];
    
    NSLog(@"%@", dayStr);
    return dayStr;
}

@end
