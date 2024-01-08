//
//  UIViewController+UIModalPresentFullScreen.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/12/7.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//  只需将本Category类放入工程即可解决。
//  解决三方平台无法修改源代码问题

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (UIModalPresentFullScreen)

@end

NS_ASSUME_NONNULL_END


/**
 iOS 13.0 之 presentViewController 模态全屏适配解决方案
 https://blog.csdn.net/mapboo/article/details/106327897
 
 
 在iOS 13.0 之前，模态显示视图默认是全屏，但是iOS 13.0 之后，默认是Sheet卡片样式的非全屏，即：
 之前，modalPresentationStyle值默认为：UIModalPresentationFullScreen；
 之后，modalPresentationStyle默认值为：UIModalPresentationAutomatic；
 
 解决方案：
 第一种：在每个方法中添加/修改控制器属性值modalPresentationStyle为UIModalPresentationFullScreen即可解决，代码如下：
 -(void)openTypeDetailVC:(int)row{
     ITQuestionDetailViewController *detailVC = [[ITQuestionDetailViewController alloc] init];
     detailVC.modalPresentationStyle = UIModalPresentationFullScreen;
     [self presentViewController:detailVC animated:YES completion:nil];
 }

 第二种：利用OC运行时(Runtime)特性做全局替换修改，免得采用方法一导致遗漏某个页面，同时也能修改第三方代码中的模态显示，如腾讯广告首页开屏等，原理就是在运行时检查方法，然后做IMP交互，让方法重载，执行自定义代码，
 
 只需将本Category类放入工程即可解决。
 解决三方平台无法修改源代码问题
 
 
 
 */
