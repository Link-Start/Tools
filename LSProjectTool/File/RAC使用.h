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







iOS 移除view上添加的阴影
在iOS中，如果你想移除view上添加的阴影，可以通过设置view的shadow相关属性为空值来实现。以下是一些常用的属性，你可以根据需要进行设置：
1.layer.shadowOpacity: 设置为0表示完全不显示阴影。
2.layer.shadowRadius: 设置阴影的模糊半径，设置为0可以移除阴影的模糊效果。
3.layer.shadowOffset: 设置阴影的偏移量，通常设置为CGSize.zero。
4.layer.shadowColor: 设置阴影的颜色，如果不想要阴影，可以将其设置为nil。
示例代码：
yourView.layer.shadowOpacity = 0;
yourView.layer.shadowRadius = 0;
yourView.layer.shadowOffset = CGSizeZero;
yourView.layer.shadowColor = nil;
这段代码会移除yourView上的阴影。如果你想移除多个view的阴影，只需对每个view应用上述设置即可。

