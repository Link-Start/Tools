//
// LSNoInputAccessoryView.h
// Pension
//
// reated by 刘晓龙 on 2021/9/9.
// Copyright © 2021 ouba. All rights reserved.
//

// https://www.jianshu.com/p/bdc58322b50c


#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
//#import "UIView+SNFoundation.h"


NS_ASSUME_NONNULL_BEGIN

@interface LSNoInputAccessoryView : NSObject

/// 去掉 wkWebView 中输入框弹出的键盘上面的toolBar工具条
- (void)removeInputAccessoryViewFromWKWebView:(WKWebView *)webView;

@end

NS_ASSUME_NONNULL_END
