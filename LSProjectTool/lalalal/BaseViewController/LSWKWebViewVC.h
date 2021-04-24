//
//  LSWKWebViewVC.h
//  DaiKuan
//
//  Created by 刘晓龙 on 2019/1/24.
//  Copyright © 2019年 刘晓龙. All rights reserved.
//

#import "LSRootViewController.h"
#import <WebKit/WebKit.h>


/*
 在子VC viewDidLoad 中调用 addSubViews 方法
 **/

NS_ASSUME_NONNULL_BEGIN

@interface LSWKWebViewVC : LSRootViewController

@property (nonatomic, strong) UIProgressView *progressView;
@property (nonatomic, strong) WKWebView *wkWebView;

@property (nonatomic, copy) NSString *urlString;

///添加子视图
- (void)addSubViews;
@end

NS_ASSUME_NONNULL_END
