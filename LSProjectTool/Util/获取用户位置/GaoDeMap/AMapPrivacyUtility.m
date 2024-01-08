//
//  AMapPrivacyUtility.m
//  officialDemoNavi
//
//  Created by menglong on 2021/10/29.
//  Copyright © 2021 AutoNavi. All rights reserved.
//

#import "AMapPrivacyUtility.h"
#import <UIKit/UIKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
@implementation AMapPrivacyUtility

+ (void)showPrivacyInfoInWindow:(UIWindow *)window {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSMutableAttributedString *privacyInfo = [[NSMutableAttributedString alloc] initWithString:@"\n亲，感谢您对XXX一直以来的信任！我们依据最新的监管要求更新了XXX《隐私权政策》，特向您说明如下\n1.为向您提供交易相关基本功能，我们会收集、使用必要的信息；\n2.基于您的明示授权，我们可能会获取您的位置（为您提供附近的商品、店铺及优惠资讯等）等信息，您有权拒绝或取消授权；\n3.我们会采取业界先进的安全措施保护您的信息安全；\n4.未经您同意，我们不会从第三方处获取、共享或向提供您的信息；" attributes:@{
        NSParagraphStyleAttributeName:paragraphStyle,
    }];

    [privacyInfo addAttribute:NSLinkAttributeName
                        value:@"《隐私权政策》"
                        range:[[privacyInfo string] rangeOfString:@"《隐私权政策》"]];

    UIAlertController *privacyInfoController = [UIAlertController alertControllerWithTitle:@"温馨提示(隐私合规示例)" message:@"" preferredStyle:UIAlertControllerStyleAlert];

    [privacyInfoController setValue:privacyInfo forKey:@"attributedMessage"];
    
    
    UIAlertAction *agreeAllAction = [UIAlertAction actionWithTitle:@"同意(下次不提示)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"agreeStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //更新用户授权高德SDK隐私协议状态. since 2.8.0
        [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
        
        // 同意高德地图隐私协议
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_agreeGaoDeMapPrivacyAgreement" object:nil];
    }];
    
    
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //更新用户授权高德SDK隐私协议状态. since 2.8.0
        [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusDidAgree];
        // 同意高德地图隐私协议
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_agreeGaoDeMapPrivacyAgreement" object:nil];
    }];

    UIAlertAction *notAgreeAction = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"agreeStatus"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //更新用户授权高德SDK隐私协议状态. since 2.8.0
        [AMapLocationManager updatePrivacyAgree:AMapPrivacyAgreeStatusNotAgree];
    }];

    [privacyInfoController addAction:agreeAllAction];
    [privacyInfoController addAction:agreeAction];
    [privacyInfoController addAction:notAgreeAction];
    
    [window.rootViewController presentViewController:privacyInfoController animated:YES completion:^{
        //更新App是否显示隐私弹窗的状态，隐私弹窗是否包含高德SDK隐私协议内容的状态. since 2.8.0
        [AMapLocationManager updatePrivacyShow:AMapPrivacyShowStatusDidShow privacyInfo:AMapPrivacyInfoStatusDidContain];
    }];

}

+ (void)handlePrivacyAgreeStatus {
    //判断是否同意了隐私协议下次不提示
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"agreeStatus"]){
        //添加隐私合规弹窗
        [self showPrivacyInfoInWindow:[UIApplication sharedApplication].delegate.window];
    }
}
@end
