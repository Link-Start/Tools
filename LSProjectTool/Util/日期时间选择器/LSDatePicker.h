//
//  LSDatePicker.h
//  LSProjectTool
//
//  Created by Xcode on 16/9/29.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
/***********************************************************************************/
/********************** 使用时 必须把 LSDatePicker的实例对象 作为属性 **********************/
/**
 @property (nonatomic, strong) LSDatePicker *datePicker;

 - (void)viewWillDisappear:(BOOL)animated {
     [super viewWillDisappear:animated];
     if (_datePicker) {
         [_datePicker popDatePicker];
     }
 }
 
 {
 if (!_datePicker) {
     UIWindow * keyWindow = [UIApplication sharedApplication].keyWindow;
     _datePicker =[[CDPDatePicker alloc] initWithSelectTitle:nil viewOfDelegate:keyWindow delegate:self];
 }
 _datePicker.theTypeOfDatePicker = 2;//只有年月日
 
 [self.datePicker pushDatePicker];
 }
 */
/***********************************************************************************/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/************ 枚举 **************/
//NS_ENUM，定义状态等普通枚举
typedef NS_ENUM(NSUInteger, LSDatePickType) {
    ///只有时间
    LSDatePickType_1 = 1,//只有时间
    ///年月日
    LSDatePickType_2 = 2,//年月日
    ///年月日加时间
    LSDatePickType_3 = 3,//年月日加时间
    
    DatePickType_4 = 4
};

/*********************** @beif 代理 ***********************/
@protocol LSDatePickerDelegate <NSObject>
///代理方法  年月日加时间:(0,16)
-(void)LSDatePickerDidConfirm:(NSString *)dateString Num:(NSNumber *)timeNumber;
@end


@interface LSDatePicker : NSObject

/***********************@beif 代理 ***********************/
@property (nonatomic, weak) id<LSDatePickerDelegate> delegate;

/***********************@beif block ***********************/
@property (copy, nonatomic) void(^cancelButtonBlock)();
@property (copy, nonatomic) void(^confirmButtonBlock)(NSString *dateString, NSNumber *timeNumber);

/// 是否可选择今天以前的时间,默认为YES
@property (nonatomic, assign) BOOL isBeforeTime;
/// 最小时间
@property (nonatomic, strong) NSDate *minDate;

/// datePicker显示类别,分别为1=只显示时间,2=只显示日期，3=显示日期和时间(默认为3)
@property (nonatomic, assign) LSDatePickType theTypeOfLSDatePicker;


///初始化方法
- (instancetype)initWithSelectTitle:(NSString *)titleStr viewOfDelegate:(UIView *)view delegate:(id<LSDatePickerDelegate>)delegate;

/*!
 *  @brief 初始化方法
 *
 *  @param title  中间文字
 *  @param cancel 左侧按钮 默认取消
 *  @param sure   右侧按钮 默认确定
 *
 *  @return 
 */
- (instancetype)initWithpickerViewWithCenterTitle:(NSString *)titleStr viewOfDelegate:(UIView *)view andCancelStr:(NSString *)cancelStr andSureStr:(NSString *)sureStr;

/*!
 *  @brief 回调
 *
 *  @param cancelBlock 取消
 *  @param sureBlock   确定
 */
- (void)pickerVIewClickCancelButtonBlock:(void(^)())cancelButtonBlock confirmButtonBlock:(void(^)(NSString *dateString, NSNumber *timeNumber))confirmButtonBlock;

///显示视图
- (void)showDatePicker;
///让视图消失
- (void)dismissDatePicker;

@end
