//
//  LSLabel.h
//  RuiTuEBusiness
//
//  Created by Alex Yang on 2018/2/9.
//  Copyright © 2018年 Naive. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE

@interface LSLabel : UILabel

///给一定范围内的字符串加删除线
@property (nonatomic, assign) IBInspectable NSRange ls_deleteLineRange;
@property (nonatomic, strong) IBInspectable UIColor *ls_deleteLineColor;

///给一定范围内的字符串加 下划线
@property (nonatomic, assign) IBInspectable NSRange ls_underLineRange;
@property (nonatomic, strong) IBInspectable UIColor *ls_underLineColor;

@end
