//
//  LSDatePicker.m
//  LSProjectTool
//
//  Created by Xcode on 16/9/29.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#define kLSDatePickerScreenHeight ([UIScreen mainScreen].bounds.size.height)
#define kLSDatePickerScreenWidth ([UIScreen mainScreen].bounds.size.width)
#define kLSDatePickerHeight 256 //日期选择器的高度

#import "LSDatePicker.h"

@interface LSDatePicker ()

@property (nonatomic, strong) UIView *bgView;

@end

@interface LSDatePicker ()
///datePicker背景
@property (nonatomic, strong) UIView *datePickerView;

///调用这个日期选择器的控制的的view
@property (nonatomic, strong) UIView *view;

///datePicker 日期选择器
@property (nonatomic, strong) UIDatePicker *datePicker;

///右侧确定按钮
@property (nonatomic, strong) UIButton *confirmButton;
///左侧取消按钮
@property (nonatomic, strong) UIButton *cancelButton;

@property (copy, nonatomic) NSString *titleString;
///左侧按钮标题
@property (copy, nonatomic) NSString *leftString;
///右侧侧按钮标题
@property (copy, nonatomic) NSString *rightString;
@end

@implementation LSDatePicker
///初始化方法
- (instancetype)initWithSelectTitle:(NSString *)title viewOfDelegate:(UIView *)view delegate:(id<LSDatePickerDelegate>)delegate {
    if (self = [super init]) {
        _view = view;
        [_view addSubview:self.bgView];
        _bgView.frame = view.frame;
        _delegate=  delegate;
        _isBeforeTime = YES;
        _theTypeOfLSDatePicker = 3;
        
        if (title) {
            _leftString = title;
        } else {
            _leftString = @"取消";
        }
        _leftString = @"确定";
        
        [self addSubView];
   }
    
    return self;
}
///初始化方法
- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)titleStr viewOfDelegate:(UIView *)view andCancelStr:(NSString *)cancelStr andSureStr:(NSString *)sureStr {
    if (self = [super init]) {
        _view = view;
        _view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _isBeforeTime = YES;
        _theTypeOfLSDatePicker = 3;
        
        if (cancelStr) {
            _leftString = cancelStr;
        } else {
            _leftString = @"取消";
        }
        if (sureStr) {
            _rightString = sureStr;
        } else {
            _rightString = @"确定";
        }
        
        [self addSubView];
    }
    return self;
}

/*!
 *  @brief 回调
 *
 *  @param cancelBlock 取消
 *  @param sureBlock   确定
 */
- (void)pickerVIewClickCancelButtonBlock:(void(^)())cancelButtonBlock confirmButtonBlock:(void(^)(NSString *dateString, NSNumber *timeNumber))confirmButtonBlock {
    _cancelButtonBlock = cancelButtonBlock;
    _confirmButtonBlock = confirmButtonBlock;
}

///
- (void)addSubView {
    
//    [self createDatePickerBgView];
    [self.datePickerView addSubview:self.datePicker];
    //创建日期选择器
    [self createDatePicker];
    //创建左侧按钮
    [self createLeftButton];
    //创建右侧按钮
    [self createRightButton];
}

/////创建日期选择器 背景
//- (void)createDatePickerBgView {
//    //创建日期选择器 背景
//    _datePickerView=[[UIView alloc] initWithFrame:CGRectMake(0,_view.bounds.size.height,_view.bounds.size.width,_view.bounds.size.height*0.42243)];
//    _datePickerView.backgroundColor = [UIColor whiteColor];
//    [_view addSubview:_datePickerView];
//}

///创建日期选择器
- (void)createDatePicker {
    
    //生成日期选择器
    _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,_view.bounds.size.height*0.07042,_view.bounds.size.width,_view.bounds.size.height*0.42243)];
    _datePicker.date =[NSDate date];
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [_datePickerView addSubview:_datePicker];
}

///创建左侧按钮
- (void)createLeftButton {
    //创建button
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.frame = CGRectMake(0,0,_view.bounds.size.width/2,_view.bounds.size.height*0.07042);
    _cancelButton.tintColor = [UIColor darkGrayColor];
    _cancelButton.backgroundColor = [UIColor colorWithRed:30.0/255.0 green:144.0/255 blue:255.0/255 alpha:1];
    [_cancelButton setTitle:_leftString forState:UIControlStateNormal];
    [_datePickerView addSubview:_cancelButton];
    ///添加点击事件
    [_cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

///创建右侧按钮
- (void)createRightButton {
    //创建button
   _confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(_view.bounds.size.width/2,0,_view.bounds.size.width/2,_view.bounds.size.height*0.07042)];
    [_confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _confirmButton.backgroundColor=[UIColor colorWithRed:220.0/255.0 green:220.0/255 blue:220.0/255 alpha:1];
    
    //添加点击事件
    [_confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_datePickerView addSubview:_confirmButton];
}

//是否可选择以前的时间
- (void)setIsBeforeTime:(BOOL)isBeforeTime{
    
    if (isBeforeTime == NO) {
        [_datePicker setMinimumDate:[NSDate date]];
    } else {
        //dateWithTimeIntervalSince1970: *1000 是精确到毫秒，不乘就是精确到秒
        [_datePicker setMinimumDate:[NSDate dateWithTimeIntervalSince1970:0]];
    }
}

- (void)setMinDate:(NSDate *)minDate {
    _minDate = minDate;
    
    _datePicker.minimumDate = minDate;
}

/// datePicker显示类别
- (void)setTheTypeOfLSDatePicker:(LSDatePickType)theTypeOfLSDatePicker{
    if (theTypeOfLSDatePicker == 1) {
        //只显示时间
        _datePicker.datePickerMode = UIDatePickerModeTime;
    } else if(theTypeOfLSDatePicker == 2) {
        //只显示日期
        _datePicker.datePickerMode = UIDatePickerModeDate;
    } else if(theTypeOfLSDatePicker == 3) {
        //时间与日期都显示
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    } else if (theTypeOfLSDatePicker == 4) {
        _datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
    } else {
        NSLog(@"时间类别选择错误");
    }
}

#pragma mark - 按钮点击事件
///确定按钮点击事件
- (void)confirmButtonAction:(UIButton *)sender {
    //代理
    if (_delegate && [self.delegate respondsToSelector:@selector(LSDatePickerDidConfirm:Num:)]) {
        [self.delegate LSDatePickerDidConfirm:[self getsTheSelectedTimeString] Num:[self getNumber]];
    }
    //block
    if (_confirmButtonBlock) {
        _confirmButtonBlock([self getsTheSelectedTimeString], [self getNumber]);
    }
    
    //让视图消失
    [self dismissDatePicker];
    _datePicker.date = [NSDate date];
}

///取消按钮点击事件
- (void)cancelButtonAction:(UIButton *)sender {
    //隐藏日期选择器
    [self dismissDatePicker];
}

///获取被选择的时间字符串
- (NSString *)getsTheSelectedTimeString {
    return [NSString stringWithFormat:@"%@", [NSDate dateWithTimeInterval:(3600 * 8) sinceDate:[_datePicker date]]];
}

- (NSNumber *)getNumber {
    // 获取当前所处的时区
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:[[self getsTheSelectedTimeString] substringToIndex:16]];
    // 获取当前时区和指定时区的时间差
    NSInteger interval = [timeZone secondsFromGMTForDate:date];
    // 得到准确时间
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    //dateWithTimeIntervalSince1970: *1000 是精确到毫秒，不乘就是精确到秒
    long long currentTime = (long long)(([localeDate timeIntervalSince1970] - 28800) * 1000);
    NSNumber *timeNumber = [NSNumber numberWithDouble:currentTime];
    return timeNumber;
}

#pragma mark pickerView 出现/消失 动画效果
//出现
- (void)showDatePicker {
    [UIView animateWithDuration:0.3 animations:^ {
        _bgView.alpha = 1.0f;
         _datePickerView.frame=CGRectMake(0,_view.bounds.size.height-_view.bounds.size.height*0.42243,_view.bounds.size.width,_view.bounds.size.height*0.42243);
     }];
}
//隐藏日期选择器
- (void)dismissDatePicker{
    [UIView animateWithDuration:0.3 animations:^{
        _bgView.alpha = 0.0f;
        _datePickerView.frame=CGRectMake(0,_view.bounds.size.height,_view.bounds.size.width,_view.bounds.size.height*0.42243);
    }];
}

- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];

    }
    return _bgView;
}

- (UIDatePicker *)datePicker {
    if (!_datePicker) {
        //生成日期选择器
        _datePicker=[[UIDatePicker alloc]initWithFrame:CGRectMake(0,_view.bounds.size.height*0.07042,_view.bounds.size.width,_view.bounds.size.height*0.42243)];
        _datePicker.date = [NSDate date];
        _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
        //_datePicker.backgroundColor = [UIColor whiteColor]; 背景色是透明的。
        if (@available(iOS 13.4, *)) {
            _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//新发现这里不会根据系统的语言变了
            _datePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        } else {
            // Fallback on earlier versions
        }
    }
    return _datePicker;
}

- (void)dealloc {
    self.delegate = nil;
}
@end
