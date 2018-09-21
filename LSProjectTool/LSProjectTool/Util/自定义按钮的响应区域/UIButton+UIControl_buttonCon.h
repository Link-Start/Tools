//
//  UIButton+UIControl_buttonCon.h
//  LSProjectTool
//
//  Created by Alex Yang on 2018/4/18.
//  Copyright © 2018年 Link-Start. All rights reserved.
//
//  此方法慎用
//  此方法与环信发送语音方法有冲突
//  此方法，在需要监听按钮不同状态(按下、取消、长按等)时需注释掉，否则影响按钮转态监听
//

#import <UIKit/UIKit.h>

@interface UIButton (UIControl_buttonCon)

#define defaultInterval .6//默认时间间隔

@property(nonatomic, assign) NSTimeInterval timeInterval;//用这个给重复点击加间隔
@property(nonatomic, assign) BOOL isIgnoreEvent;//YES不允许点击 NO允许点击

@end
