//
//  UITextField的代理相关方法.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2019/1/21.
//  Copyright © 2019年 Link-Start. All rights reserved.
//

#ifndef UITextField________h
#define UITextField________h

#pragma mark - 1.只能输入0~9的数字，并且小数点后面两位 第一位不能输入0
/**
 *  textField的代理方法，监听textField的文字改变
 *  textField.text是当前输入字符之前的textField中的text
 *
 *  @param textField textField
 *  @param range     当前光标的位置
 *  @param string    当前输入的字符
 *
 *  @return 是否允许改变
 */
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    BOOL isHaveDian = YES;
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        NSLog(@"single = %c",single);
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            //            [MBProgressHUD bwm_showTitle:@"您的输入格式不正确" toView:self hideAfter:1.0];
            return NO;
        }
        
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            //            [MBProgressHUD bwm_showTitle:@"最多只能输入一个小数点" toView:self hideAfter:1.0];
            return NO;
        }
        
        // 第一位不能输入0
        if ((textField.text.length == 0) && (single == '0')) {
            NSLog(@"第一位不能输入0");
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    //                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    //                    [MBProgressHUD bwm_showTitle:@"第二个字符需要是小数点" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            // 由于range.location是NSUInteger类型的，所以这里不能通过(range.location - ran.location)>2来判断
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    //                    [MBProgressHUD bwm_showTitle:@"小数点后最多有两位小数" toView:self hideAfter:1.0];
                    return NO;
                }
            }
        }
        
    }
    
    return YES;
}





/// 监测 textField 编辑情况
- (void)addTextFieldEventEdit {
    [self.liveNickNameView.centerTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)textFieldDidChange:(UITextField *)textField {
    if (textField == self.liveNickNameView.centerTextField) { //昵称
        NSLog(@"主播昵称：%@", textField);
    }
}
#endif /* UITextField________h */


