//
//  LSWKWebView.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/19.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSWKWebView;

NS_ASSUME_NONNULL_BEGIN

@protocol LSWKWebViewDelegate <NSObject>
@optional
///页面开始加载时调用
- (void)wkWebViewDidStartLoad:(LSWKWebView *)wkWebView;
///页面开始返回时调用
- (void)wkWebView:(LSWKWebView *)wkWebView didCommitWithUrl:(NSURL *)url;
///页面加载失败时调用
- (void)wkWebView:(LSWKWebView *)wkWebView didFailLoadaWithError:(NSError *)error;
///页面加载完成之后调用
- (void)wkWebView:(LSWKWebView *)wkWebView didFinishLoadWithUrl:(NSURL *)url;


@end

@interface LSWKWebView : UIView

///进度条颜色(默认蓝色)
@property (nonatomic, strong) UIColor *progressViewColor;
///导航栏标题
@property (nonatomic, strong) NSString *navigationItemTitle;
///导航栏存在且有穿透效果(默认导航栏存在且有穿透效果)
@property (nonatomic, assign) BOOL isNavigationBarAndTranslucent;
///代理
@property (nonatomic, weak) id<LSWKWebViewDelegate> wkDelegate;


/// 类方法创建 LSWKWebView
+ (instancetype)wkWebViewWithFrame:(CGRect)frame;
/// 加载web
- (void)loadRequest:(NSURLRequest *)request;
///加载HTML
- (void)loadHTMLString:(NSString *)HTMLString;
///刷新数据
- (void)reloadData;



@end

NS_ASSUME_NONNULL_END
