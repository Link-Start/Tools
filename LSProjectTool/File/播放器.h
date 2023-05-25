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
