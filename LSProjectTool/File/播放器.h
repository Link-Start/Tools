//
//  播放器.h
//  LSProjectTool
//
//  Created by Xcode on 16/12/14.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef ____h
#define ____h


#endif /* ____h */

1.MPMoviePlayerController在iOS9被Apple废弃了
2.MPMoviePlayerViewController在iOS9以后也被抛弃



/// ------------------------------------------------------------------------------------------------------------------------------------
https://stackoverflow.com/questions/69792214/ios15-webview-using-video-causes-crashes-webavplayercontroller-valueforunde

//使用“视频”的iOS15 Webview会导致崩溃 - `WebAVPlayerController valueForUndefinedKey - playingOnMatchPointDevice `
//iOS15 Webview的HTML使用视频标签，会发生以下崩溃：
[<WebAVPlayerController 0x282f41420> valueForUndefinedKey:]：该类不符合PlayingOnMatchPointDevice键的键值编码。

解决方法：
//在默认配置中，WKWebView加载页面，内部视频播放只能在用户活动操作后播放，并且必须全屏播放。这种配置可能无法满足业务需求，网络视频应该在页面中内联自动播放。因此，您应该设置WKWebViewConfiguration，具体代码如下：
WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
configuration.allowsInlineMediaPlayback = YES;
if (@available(iOS 10.0, *)) {
    configuration.mediaTypesRequiringUserActionForPlayback = WKAudiovisualMediaTypeNone;
} else {
    configuration.requiresUserActionForMediaPlayback = NO;
}

//您的网页也需要设置视频，例如
<video width="320" height="240" controls="" webkit-playsinline="true" playsinline="true">
   <source src="https://xx.com.xxx.mp4" type="video/mp4">
</video>
/// ------------------------------------------------------------------------------------------------------------------------------------



https://github.com/yangKJ/Rickenbacker/blob/master/README_CN.md
Mediatror

该模块主要就是提供设计组件化中间层

设计组件化中间层有两种比较有代表性的方案：

基于URL注册跳转的方式，参考蘑菇街开源 MGJRouter
基于Objective-C运行时的Mediator方式，参考 CTMediator
简单谈谈二者优势区别：

URL注册的方式在使用上非常繁琐而且很多时候其实没有必要。首先每一个页面跳转都需要事先注册好URL，这里会牵涉到非常多字符串硬编码。
基于runtime的Mediator方式，首先它不需要注册，省去了很多比对字符串的过程，其次它可以非常容易的传递各种参数来进行组建间通信。
因此这边最终选择提供方案也是Mediator方式；






https://github.com/lyujunwei/MGJRouter
已经有几款不错的 Router 了，如 JLRoutes, HHRouter, 但细看了下之后发现，还是不太满足需求。

JLRoutes 的问题主要在于查找 URL 的实现不够高效，通过遍历而不是匹配。还有就是功能偏多。
HHRouter 的 URL 查找是基于匹配，所以会更高效，MGJRouter 也是采用的这种方法，但它跟 ViewController 绑定地过于紧密，一定程度上降低了灵活性。

于是就有了 MGJRouter。






