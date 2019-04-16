//
//  LSDatePickerTableView.h
//  LSProjectTool
//
//  Created by Xcode on 16/9/30.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSAlertRootView.h"
@interface LSDatePickerTableView : UIView

@property (nonatomic, copy) void (^selectedDate)();


///
- (instancetype)initWithCurrentView:(UIView *)currentView;

///选择日期
- (void)setSelectedDate:(void (^)())selectedDate;




@end
