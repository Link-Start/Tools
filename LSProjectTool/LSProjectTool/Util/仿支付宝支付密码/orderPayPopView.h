//
//  orderPayPopView.h
//  RuiTuEBusiness
//
//  Created by Alex Yang on 2018/1/17.
//  Copyright © 2018年 Naive. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orderPayPopView : UIView
{
    
    UIViewController *_ls_vc;
}

/*!
 *  @brief block块 结束编辑
 */
@property (nonatomic, copy) void(^AlertViewEndInput)(NSString *pwd, orderPayPopView *v);
///忘记密码
@property (nonatomic, copy) void (^AlertViewForgetPwd)(orderPayPopView *v);

/*!
 *  @brief 初始化方法
 */
- (instancetype)initWithViewController:(UIViewController *)vc yue:(NSString *)yue;


- (void)show;

- (void)exitToBottom;
@end

