//
//  LSDatePickerTableView.m
//  LSProjectTool
//
//  Created by Xcode on 16/9/30.
//  Copyright © 2016年 Link-Start. All rights reserved.
//


#define kLSDatePickerTableWidth ([[UIScreen mainScreen] bounds].size.width)
#define kLSDatePickerTableHeitht ([[UIScreen mainScreen] bounds].size.height)
#define kLSDatePickerTableSpace 200

#import "LSDatePickerTableView.h"

@interface LSDatePickerTableView ()<UITableViewDelegate, UITableViewDataSource>

///背景
@property (nonatomic, strong) UIView *contentView;

///左侧tableview
@property (nonatomic, strong) UITableView *leftTableView;
///右侧tableview
@property (nonatomic, strong) UITableView *rightTableView;

@end

@implementation LSDatePickerTableView

- (instancetype)initWithCurrentView:(UIView *)currentView {
    self = [super init];
    if (self) {
        
        if (!_contentView) {
            _contentView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        }
        
        _contentView.backgroundColor = [UIColor blackColor];
        _contentView.alpha = 0.5;
        
        [currentView addSubview:self];
        
        [self addSubview:_contentView];
        [self addSubviews];
    }
    return self;
}

- (void)addSubviews {
    //创建左侧的tableview
    [self createLeftTableView];
    //创建右侧的tableview
    [self createRightTableView];
}

///创建左侧的tableview
- (void)createLeftTableView {

    if (!_leftTableView) {
        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(50, kLSDatePickerTableSpace, kLSDatePickerTableWidth/2 - 50, kLSDatePickerTableHeitht - kLSDatePickerTableSpace*2) style:UITableViewStylePlain];
        
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        
        [_contentView addSubview:_leftTableView];
    }
    

    self.leftTableView.backgroundColor = [UIColor redColor];
    _leftTableView.userInteractionEnabled = YES;
}

///创建右侧的tableview
- (void)createRightTableView {
    
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(kLSDatePickerTableWidth/2, kLSDatePickerTableSpace, kLSDatePickerTableWidth/2 - 50, kLSDatePickerTableHeitht - kLSDatePickerTableSpace*2) style:UITableViewStylePlain];
        [_contentView addSubview:_rightTableView];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.scrollEnabled = YES;
    }
    _rightTableView.userInteractionEnabled = YES;

}

///确定
- (void)confirmButtonAction:(UIButton *)sender {
    NSIndexPath *leftSelectIndexPath = self.leftTableView.indexPathForSelectedRow;
    NSIndexPath *rightSelectIndexPath = self.rightTableView.indexPathForSelectedRow;
    
    if (leftSelectIndexPath) {
        if (rightSelectIndexPath) {
            if (_selectedDate) {
                
                NSString *chooseDate = [self.leftTableView cellForRowAtIndexPath:leftSelectIndexPath].textLabel.text;
                NSString *chooseTime = [self.rightTableView cellForRowAtIndexPath:rightSelectIndexPath].textLabel.text;
                
                NSString *endTime = @"";
                
                if (chooseTime.length == 11) {
                    endTime = [chooseTime substringFromIndex:6];
                } else {
                    endTime = [chooseTime substringFromIndex:5];
                }
                
                NSString *dateString = [chooseDate substringToIndex:10];
                
                //NSString 转换为 NSDate
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                [formatter dateFromString:@"yyyy-MM-dd HH:mm"];
                NSDate *date = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@", dateString, endTime]];
                
                if ([date compare:[NSDate date]] == NSOrderedDescending) {
                    self.selectedDate([NSString stringWithFormat:@"%@ %@", chooseDate, chooseTime]);
                    [self removeFromSuperview];
                } else {
                    NSLog(@"该时间段已过，请重新选择");
                }
                
            }
        } else {
            NSLog(@"请选择时间");
        }
    } else {
        NSLog(@"请选择一个日期");
    }
}

///关闭
- (void)cancelButtonAction:(UIButton *)sender {
    //从父视图移除
//    [self removeFromSuperview];
}


#pragma mark - tableView 代理方法
//返回分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
//返回每个分区cell的数量
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"%@", tableView);
    return tableView == _leftTableView ? 7 : 12;
}
//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier = @"selectedDateCellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    //取消cell的选中状态
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.font = [UIFont systemFontOfSize:13];//字体大小
    if (tableView == _rightTableView) {
        cell.textLabel.text = [NSString stringWithFormat:@"%ld:00-%ld:00", (8 + indexPath.row) * 1 ,(9 + indexPath.row) * 1];
        
    } else {
        NSDate *day = [[NSDate date] dateByAddingTimeInterval:(NSTimeInterval)(60*60*24*indexPath.row)];
        cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", [self getStringDate:day], [self getDayOfWeekTitle:day]];
    }
    
    return cell;
}
//cell的点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 33;
}

- (NSString *)getStringDate:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd";
    return [formatter stringFromDate:date];
}

- (NSString *)getDayOfWeekTitle:(NSDate *)date {
    
    NSInteger day = [self getDayOfWeek:date];
    
    NSString *title = @"";
    switch (day) {
        case 1:
            title = @"星期一";
            break;
        case 2:
            title = @"星期二";
            break;
        case 3:
            title = @"星期三";
            break;
        case 4:
            title = @"星期四";
            break;
        case 5:
            title = @"星期五";
            break;
        case 6:
            title = @"星期六";
            break;
        case 7:
            title = @"星期日";
            break;
            
        default:
            break;
    }
    
    
    return @"";
}

- (NSInteger)getDayOfWeek:(NSDate *)date {
    
    NSCalendar *myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [myCalendar component:NSCalendarUnitWeekday fromDate:date];
    
    
    
    return [myCalendar firstWeekday];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}


#pragma mark - 懒加载

- (void)dealloc {
    
}

@end
