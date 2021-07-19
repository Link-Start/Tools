//
//  LSWKWebView.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/19.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import "LSWKWebView.h"
#import <WebKit/WebKit.h>

@interface LSWKWebView ()<WKNavigationDelegate, WKUIDelegate>

///WKWebView
@property (nonatomic, strong) WKWebView *wkWebView;
///进度条
@property (nonatomic, strong) UIProgressView *progressView;

@end

@implementation LSWKWebView

static CGFloat const navigationBarHeight = 64;
static CGFloat const progressViewHeight = 2;

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.wkWebView];
        [self addSubview:self.progressView];
    }
    return self;
}

+ (instancetype)wkWebViewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

#pragma mark -
///加载web
- (void)loadRequest:(NSURLRequest *)request {
    [self.wkWebView loadRequest:request];
}
///加载HTML
- (void)loadHTMLString:(NSString *)HTMLString {
    [self.wkWebView loadHTMLString:HTMLString baseURL:nil];
}
///刷新数据
- (void)reloadData {
    [self.wkWebView reload];
}

#pragma mark -
- (void)setProgressViewColor:(UIColor *)progressViewColor {
    _progressViewColor = progressViewColor;
    
    if (progressViewColor) {
        _progressView.tintColor = progressViewColor;
    }
}

- (void)setIsNavigationBarAndTranslucent:(BOOL)isNavigationBarAndTranslucent {
    _isNavigationBarAndTranslucent = isNavigationBarAndTranslucent;
    if (isNavigationBarAndTranslucent == YES) {//导航栏存在且具有穿透效果
        _progressView.frame = CGRectMake(0, navigationBarHeight, self.frame.size.width, progressViewHeight);
    } else {
        _progressView.frame = CGRectMake(0, 0, self.frame.size.width, progressViewHeight);
    }
}

#pragma mark - 代理方法
///页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if (self.wkDelegate && [self.wkDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.wkDelegate wkWebViewDidStartLoad:self];
    }
}
///页面加载失败时调用             在开始加载数据时 发生错误时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation withError:(NSError *)error {
}
///当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation {
    if (self.wkDelegate && [self.wkDelegate respondsToSelector:@selector(webView:didCommitNavigation:)]) {
        [self.wkDelegate wkWebView:self didCommitWithUrl:self.wkWebView.URL];
    }
    self.navigationItemTitle = self.wkWebView.title;
}
///页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    self.navigationItemTitle = self.wkWebView.title;
    if (self.wkDelegate && [self.wkDelegate respondsToSelector:@selector(wkWebView:didFinishLoadWithUrl:)]) {
        [self.wkDelegate wkWebView:self didFinishLoadWithUrl:self.wkWebView.URL];
    }
    self.progressView.alpha = 0.0;
}
///页面加载失败时调用    (失败)        在提交的主帧期间发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
    if (self.wkDelegate && [self.wkDelegate respondsToSelector:@selector(wkWebView:didFailLoadaWithError:)]) {
        [self.wkDelegate wkWebView:self didFailLoadaWithError:error];
    }
    self.progressView.alpha = 0.0;
}


#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"wkWebViewURL地址:%@", self.wkWebView.URL);
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && (object == self.wkWebView)) {
        self.progressView.alpha = 1.0;
        BOOL animated = self.wkWebView.estimatedProgress > self.progressView.progress;
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        if (self.wkWebView.estimatedProgress >= 0.97) {
            [UIView animateWithDuration:0.1 delay:0.3 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.progressView.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0 animated:NO];
            }];
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - 懒加载
- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        _wkWebView = [[WKWebView alloc] initWithFrame:self.bounds];
        _wkWebView.navigationDelegate = self;
        _wkWebView.UIDelegate = self;
//        if (@available(iOS 11.0, *)) {
//            self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        } else {
//            self.automaticallyAdjustsScrollViewInsets = NO;
//        }
        
        //KVO
        [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:nil];
    }
    return _wkWebView;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.trackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
        //高度默认有导航栏且有穿透效果
        _progressView.frame = CGRectMake(0, navigationBarHeight, self.frame.size.width, progressViewHeight);
        //设置进度条颜色
        _progressView.tintColor = [UIColor blueColor];
        
//        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
//        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f)
        
        //iOS14，UIProgressView默认高度变为4，之前是2，如果产品要求保持之前的高度，需要进行适配
        // 适配iOS14，UIProgressView高度变为2
        if (CGRectGetHeight(_progressView.frame) == 4) {
            _progressView.transform = CGAffineTransformMakeScale(1.0, 0.5);
        }
    }
    return _progressView;
}


- (void)dealloc {
    //KVO没有添加监听的情况下移除观察者导致崩溃
    @try {
        [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    @catch (NSException *exception) {
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
