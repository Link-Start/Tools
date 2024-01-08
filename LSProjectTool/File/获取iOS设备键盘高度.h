//
//  获取iOS设备键盘高度.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/7.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef __iOS_______h
#define __iOS_______h



主要是利用键盘弹出时的通知。

　　1、首先先随便建一个工程。

　　2、在工程的 -(void)viewDidload;函数中添加键盘弹出和隐藏的通知，具体代码如下：


//增加监听，当键盘出现或改变时收出消息
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillShow:)
                                             name:UIKeyboardWillShowNotification
                                           object:nil];

//增加监听，当键退出时收出消息
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillHide:)
                                             name:UIKeyboardWillHideNotification
                                           object:nil];


3、当得到通知时写2个函数，来响应通知 -(void)keyboardWillShow; -(void)keyboardWillHide;



在这2个函数中可以得到键盘的一些属性，具体代码如下：
- (void)keyboardWillShow:(NSNotification *)notif {
    //获取键盘的高度
    /*
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375
     
     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414
     
     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320
     
     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768
     
     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */
    NSDictionary *userInfo = [notif userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
    //键盘弹出的时长
    CGFloat duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    // 弹出的键盘的 frame
    CGRect endFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];


//    [UIView animateWithDuration:duration animations:^{
//        CGFloat h = (kScreenHeight/2-endFrame.size.height-125);
//        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(h);
//        }];
//
//    }];
    
    //Duration: 动画持续时间
//delay: 动画执行延时
//usingSpringWithDamping: 震动效果，范围 0.0f~1.0f，数值越小,「弹簧」的震动效果越明显.当“dampingRatio”为1时，动画将平滑地减速到其最终模型值，而不会振荡
//initialSpringVelocity: 初始速度，数值越大一开始移动越快
//options: 动画的过渡效果
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1.0 initialSpringVelocity:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGFloat h = (kScreenHeight/2-endFrame.size.height-125);
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(h);
        }];
    } completion:^(BOOL finished) {
        
    }];
    
    [self.view layoutIfNeeded];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notif {
  
    CGFloat duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [self.bgView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.view.mas_centerY).mas_offset(0);
        }];
    }];
    [self.view layoutIfNeeded];
}








/**********************************************************************************************************************************************************/



//[IQKeyboardManager sharedManager].shouldResignOnTouchOutside = NO;

//增加监听，当键盘出现或改变时收出消息
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillShow:)
                                             name:UIKeyboardWillShowNotification
                                           object:nil];

//增加监听，当键退出时收出消息
[[NSNotificationCenter defaultCenter] addObserver:self
                                         selector:@selector(keyboardWillHide:)
                                             name:UIKeyboardWillHideNotification
                                           object:nil];

//self.originalFrame = self.containBgView.frame;
}


- (void)keyboardWillShow:(NSNotification *)notif {
//获取键盘的高度

// 弹出的键盘的 frame
CGRect endFrame = [notif.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//键盘弹起时的动画效果
UIViewAnimationOptions option = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
//键盘弹出的时长
CGFloat duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];

[UIView animateWithDuration:duration delay:0 options:option animations:^{
    CGRect frame = self.containBgView.frame;
//    frame.origin.y = (endFrame.origin.y-frame.size.height);//
    if (endFrame.origin.y-self.containerBgView.height > 0) {
        frame.origin.y = endFrame.origin.y-frame.size.height;
    } else {
        frame.origin.y = 0;
    }
    self.containBgView.frame = frame;
} completion:^(BOOL finished) {
    [self layoutIfNeeded];
}];
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)notif {

UIViewAnimationOptions option = [notif.userInfo[UIKeyboardAnimationCurveUserInfoKey] intValue];
NSTimeInterval duration = [notif.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
[UIView animateWithDuration:duration delay:0 options:option animations:^{
    CGRect frame = self.containBgView.frame;
//    frame.origin.y = self.originalFrame.origin.y;
    frame.origin.y = (self.view.height-self.containBgView.height)/2
    self.containBgView.frame = frame;
    
} completion:^(BOOL finished) {
    [self layoutIfNeeded];
}];
}



#endif /* __iOS_______h */
