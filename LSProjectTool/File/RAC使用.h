//
//  RAC使用.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/8.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#ifndef RAC___h
#define RAC___h

// 监测输入框，改变btn状态
- (void)bindSignl{
    [[RACSignal combineLatest:@[self.phoneField.rac_textSignal,self.passwordField.rac_textSignal] reduce:^(NSString *phone,NSString *password){
        return @((password.length>=6&&password.length<=16)&&(phone.length>=6&&phone.length<=18));
    }]subscribeNext:^(id  _Nullable x) {
         BOOL isFinish = [x boolValue];
         self.loginBtn.enabled = isFinish;
         [self.loginBtn setBackgroundColor:isFinish?ThemeColor:[UIColor colorWithHexString:@"#F5F5F5"]];
    }];
}

#endif /* RAC___h */
