//
//  UIButton+UIControl_buttonCon.h
//  LSProjectTool
//
//  Created by Alex Yang on 2018/4/18.
//  Copyright © 2018年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (UIControl_buttonCon)

#define defaultInterval .6//默认时间间隔

@property(nonatomic, assign) NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic, assign) BOOL isIgnoreEvent;//YES不允许点击 NO允许点击

@end
