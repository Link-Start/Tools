//
//  LSWKWebViewVC.m
//  DaiKuan
//
//  Created by 刘晓龙 on 2019/1/24.
//  Copyright © 2019年 刘晓龙. All rights reserved.
//

#import "LSWKWebViewVC.h"
#import "DefineSystemSize.h"


@interface LSWKWebViewVC ()<WKUIDelegate, WKNavigationDelegate>


@end

@implementation LSWKWebViewVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSubViews];
    [self addLayout];
    
    [self.wkWebView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.wkWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", self.urlString]]]];
}

#pragma mark - 数据

#pragma mark- 按钮点击事件

#pragma mark - 代理方法
// 页面开始加载时调用
-(void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"开始加载网页");
    
    if (!self.title) {
        self.title = webView.title;
    }
    
    //开始加载网页时展示出progressView
    self.progressView.hidden = NO;
    //开始加载网页的时候将progressView的Height恢复为1.5倍
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    //防止progressView被网页挡住
    [self.view bringSubviewToFront:self.progressView];
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    //这里修改导航栏的标题，动态改变
    //self.title = webView.title;
    
    //关闭手势缩放
    NSString *injectionJSString = @"var script = document.createElement('meta');"
    "script.name = 'viewport';"
    "script.content=\"width=device-width, user-scalable=no\";" "document.getElementsByTagName('head')[0].appendChild(script);";
    [webView evaluateJavaScript:injectionJSString completionHandler:nil];
    
    NSLog(@"加载完成");
    //加载完成后隐藏progressView
    //self.progressView.hidden = YES;
}

/////页面加载失败时调用         在提交的主帧期间发生错误时调用
//- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error {
//
//}

// 接收到服务器跳转请求之后再执行
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
    //    NSLog(@"接收到服务器跳转请求之后再执行，%@",webView.URL);
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"在收到响应后，%@",webView.URL);
    NSLog(@"在收到响应后，%@",navigationResponse.response.URL);

    WKNavigationResponsePolicy actionPolicy = WKNavigationResponsePolicyAllow;
    //这句是必须加上的，不然会异常
    decisionHandler(actionPolicy);
    
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    NSLog(@"在发送请求之前，%@",webView.URL);
    
    //    self.title = webView.title;
    WKNavigationActionPolicy actionPolicy = WKNavigationActionPolicyAllow;
    
    
    if (navigationAction.navigationType==WKNavigationTypeBackForward) {//判断是返回类型
        
    }
    
//    if ([navigationAction.request.URL.path rangeOfString:@"type=09&id="].location != NSNotFound){//选中服务
//
//        NSString *string = navigationAction.request.URL.path;
//        NSRange startRange = [string rangeOfString:@"type=09&id="];
//        NSString *result = [string substringFromIndex:(startRange.location+startRange.length)];
//        self.spid = result;
//
//
//        decisionHandler(WKNavigationActionPolicyCancel);
//    } else {
    
    //这句是必须加上的，不然会异常
      decisionHandler(WKNavigationActionPolicyAllow);
//    }
}



- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"网页由于某些原因加载失败");
    
}

///页面加载失败时调用         在提交的主帧期间发生错误时调用
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    NSLog(@"加载失败,失败原因:%@",[error description]);
}
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView {
    NSLog(@"网页加载内容进程终止");
//    [webView reload];
}


///在监听方法中获取网页加载的进度，并将进度赋给progressView.progress
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        self.progressView.progress = self.wkWebView.estimatedProgress;
        if (self.progressView.progress == 1) {
            /*
             *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
             *动画时长0.25s，延时0.3s后开始动画
             *动画结束后将progressView隐藏
             */
            __weak typeof (self)weakSelf = self;
            [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                weakSelf.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
            } completion:^(BOOL finished) {
                weakSelf.progressView.hidden = YES;
            }];
        }
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - 自定义方法

#pragma mark - 添加子视图
- (void)addSubViews {
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progressView];
}

- (void)addLayout {
    
}

#pragma mark - 懒加载
- (WKWebView *)wkWebView {
    
    if (!_wkWebView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, kLS_TopHeight, kLS_ScreenWidth, kLS_ScreenHeight-kLS_TopHeight-kLS_iPhoneX_Home_Indicator_Height) configuration:config];
        
        // 是否允许手势左滑返回上一级, 类似导航控制的左滑返回
        _wkWebView.allowsBackForwardNavigationGestures = YES;
        //可返回的页面列表, 存储已打开过的网页
        //        WKBackForwardList * backForwardList = [_wkWebView backForwardList];
        //页面后退
        [_wkWebView goBack];
        //页面前进
        [_wkWebView goForward];
        //刷新当前页面
        [_wkWebView reload];
        
        
        // UI代理
        self.wkWebView.UIDelegate = self;
        // 导航代理
        self.wkWebView.navigationDelegate = self;
        
        if (@available(iOS 11.0, *)) {
            self.wkWebView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _wkWebView;
}


- (UIProgressView *)progressView {
    if (!_progressView) {
        //进度条初始化
        _progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, kLS_TopHeight, kLS_ScreenWidth, 2)];
        _progressView.progressTintColor = [UIColor blueColor];
        //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
        _progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
        
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
        [self.wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    @catch (NSException *exception) {
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
