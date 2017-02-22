//
//  AuthcodeView.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/1.
//  Copyright © 2016年 Link-Start. All rights reserved.
//
// iOS本地动态验证码生成

#import <UIKit/UIKit.h>

@interface AuthcodeView : UIView

@property (strong, nonatomic) NSArray *dataArray;//字符素材数组

@property (strong, nonatomic) NSMutableString *authCodeStr;//验证码字符串

@end






//使用方法

////显示验证码界面
//authCodeView = [[AuthcodeView alloc] initWithFrame:CGRectMake(30, 100, self.view.frame.size.width-60, 40)];
//[self.view addSubview:authCodeView];


////判断输入的是否为验证图片中显示的验证码
//if ([_input.text isEqualToString:authCodeView.authCodeStr]) {
//    //正确弹出警告款提示正确
//    UIAlertView *alview = [[UIAlertView alloc] initWithTitle:@"恭喜您 ^o^" message:@"验证成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//    [alview show];
//    
//} else {
//    
//    //验证不匹配，验证码和输入框抖动
//    CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
//    anim.repeatCount = 1;
//    anim.values = @[@-20,@20,@-20];
//    [_input.layer addAnimation:anim forKey:nil];
//}
