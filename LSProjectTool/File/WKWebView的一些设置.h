//
//  WKWebView的一些设置.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/15.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#ifndef WKWebView______h
#define WKWebView______h

https://www.jianshu.com/p/7a6414dae993
iOS WKWebView 图片自适应并且 禁止页面缩放

1.WKWebView 图片自适应

    NSString *js=@"var script = document.createElement('script');"

    "script.type = 'text/javascript';"

    "script.text = \"function ResizeImages() { "

    "var myimg,oldwidth;"

    "var maxwidth = %f;"

    "for(i=0;i"

    "myimg = document.images[i];"

    "if(myimg.width > maxwidth){"

    "oldwidth = myimg.width;"

    "myimg.width = %f;"

    "}"

    "}"

    "}\";"

    "document.getElementsByTagName('head')[0].appendChild(script);";

    js = [NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    js = [NSString stringWithFormat:@"%@%@",js,@""];

    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];


2 .禁止页面缩放

1.网上查了下资料很多都是通过js user-scalable=no 来实现的 这样也可以不过图片大小在个别网页就不自适应了，也不知道 怎么与上面的图片自适应代码组合成一段js 于是就放弃了。、

  NSString *injectionJSString = @"var script = document.createElement('meta');"
                                     "script.name = 'viewport';"
                                     "script.content=\"width=device-width, user-scalable=no\";"
                                     "document.getElementsByTagName('head')[0].appendChild(script);";
再次尝试使用 .wkWebView.scrollView代理方法来关闭缩放，结果成关闭缩放了，但是图片又不自适应了，灵机一动直接把交互性给关了了，然后就好了。。。就只设置了 1的图片自适应。另外吧wkWebView的交互给关闭了。
    self.wkWebView.userInteractionEnabled = NO;

全部代码



- (void)configWKWebView{
//    NSString *js = @" $('meta[name=description]').remove(); $('head').append( '' );";

    NSString *js=@"var script = document.createElement('script');"

    "script.type = 'text/javascript';"

    "script.text = \"function ResizeImages() { "

    "var myimg,oldwidth;"

    "var maxwidth = %f;"

    "for(i=0;i"

    "myimg = document.images[i];"

    "if(myimg.width > maxwidth){"

    "oldwidth = myimg.width;"

    "myimg.width = %f;"

    "}"

    "}"

    "}\";"

    "document.getElementsByTagName('head')[0].appendChild(script);";

    js = [NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    js = [NSString stringWithFormat:@"%@%@",js,@""];

    WKUserScript *script = [[WKUserScript alloc] initWithSource:js injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
    
    NSString *injectionJSString = @"var script = document.createElement('meta');"
                                       "script.name = 'viewport';"
                                       "script.content=\"width=device-width, user-scalable=no\";"
                                       "document.getElementsByTagName('head')[0].appendChild(script);";
    WKUserScript *injectionJSStringScript = [[WKUserScript alloc] initWithSource:injectionJSString injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];

    WKUserContentController *userController = [WKUserContentController new];
    NSMutableString *javascript = [NSMutableString string]; [javascript appendString:@"document.documentElement.style.webkitTouchCallout='none';"];//禁止长按
    [javascript appendString:@"document.documentElement.style.webkitUserSelect='none';"];//禁止选择
    
    WKUserScript *noneSelectScript = [[WKUserScript alloc] initWithSource:javascript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    
    
    WKWebViewConfiguration *config =[[WKWebViewConfiguration alloc]init];
    config.preferences = [WKPreferences new];
    
    config.preferences.minimumFontSize = 10;
    
    config.preferences.javaScriptEnabled = YES;
    
    config.preferences.javaScriptCanOpenWindowsAutomatically = YES;
    [userController addUserScript:script];
    [userController addUserScript:noneSelectScript];
    [userController addUserScript:injectionJSStringScript];
    config.userContentController = userController;
    
    self.wkWebView = [[WKWebView alloc]initWithFrame:CGRectZero configuration:config];
    self.wkWebView.scrollView.scrollEnabled = NO;
    self.wkWebView.scrollView.bounces = NO;
    self.wkWebView.userInteractionEnabled = NO;
//    self.wkWebView.navigationDelegate = self;
//    self.wkWebView.scrollView.delegate = self;
    //监听wekwebview 的高度来技术 tableview Cell 的高度
    [self.wkWebView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
  
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    /**  防止滚动一直刷新，出现闪屏  */
    if ([keyPath isEqualToString:@"contentSize"]&&self.wkWebView.scrollView == object) {
//        NSLog(@"----%f",self.wkWebViewHeight);
        
        if (self.wkWebViewHeight < self.wkWebView.scrollView.contentSize.height &&self.isMoreWebView) {
            //如果点击的展开就一直刷新 ，指导拿到最终高度
            self.wkWebViewHeight=  self.wkWebView.scrollView.contentSize.height;
            self.cellGoodsDetailsHeight =self.wkWebViewHeight;
            dispatch_async(dispatch_get_main_queue(), ^{
                // UI更新
                NSLog(@"-----刷新tableview---%f",self.wkWebViewHeight);
                [self.myTableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationNone];
            });
            
        }
        //记录wkWebview 内容的高度 点击展开的时候  直接刷新
        self.wkWebViewHeight=  self.wkWebView.scrollView.contentSize.height;

    }
}




#endif /* WKWebView______h */
