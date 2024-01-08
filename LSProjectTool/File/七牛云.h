//
//  七牛云.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/11/21.
//  Copyright © 2023 Link-Start. All rights reserved.
//
// 七牛云开发者API文档：https://developer.qiniu.com/dora/1313/video-frame-thumbnails-vframe
//
//
//


#ifndef ____h
#define ____h

七牛云：
https://www.cms88.com/cms/148.html
https://blog.csdn.net/qq_16494241/article/details/122965108

如何利用七牛云自动生成视频封面图

1、七牛云如何获取视频封面
//假设有一视频地址：http://www.cms88com/video.mp4
//视频地址后面拼接?vframe/jpg/offset/1
//那么就会得到视频 第1秒 图的地址，作为封面：http://www.cms88.com/video.mp4?vframe/jpg/offset/1
//七牛云同时也支持一些细节定制：
//  例如：?vframe/jpg/offset/7/w/480/h/360
//    vframe/ ：输出的截图格式（jpg,png）  --------- jpg格式
//    offset/ ：指定截取视频的时刻，单位：秒 --------- 7：第7秒
//    w/      ：图片宽                   --------- 宽
//    h/      ：图片高                   --------- 高
// w/480/h/360 可忽略
//最终得到视频图片：http://www.cms88.com/video.mp4?vframe/jpg/offset/7/w/480/h/360

2、获取图片缩略图
//假设有一图片地址：http://www.cms88.com/logo.png
//图片地址后面拼接，w和h可以调整宽高，例如：?imageView2/1/w/100/h/200
//那么就会得到缩略图地址：http://www.cms88.com/logo.png?imageView2/1/w/100/h/200







// iOS
https://github.com/pili-engineering/QPlayer2-IOS

#endif /* ____h */


/**
 处理.mp4的视频在电脑浏览器、安卓手机可以正常播放，ios设备无法播放的问题
 https://blog.csdn.net/VC520530/article/details/108883902
 
 处理MP4视频在IOS设备无法播放的问题
 今天遇到了这个问题，业务人员上传视频后发现在ios设备无法播放，在安卓设备可以正常播放，复现了下，确实有这个问题，项目的视频都是上传到七牛云，拷贝出视频链接，直接丢到浏览器也可以正常播放。还是老样子，面向百度编程，查询到了ios设备对视频的压缩级别支持的原因。


 参考博文

 我这项目的视频存储在七牛云上，处理其实也很简单，直接在七牛后台对视频转码下就行了。为了防止以后遇到这种问题，咨询了下七牛的技术支持，没想到老哥直接说暂时没有判断视频压缩级别的接口。。。
 然而通过对比七牛的?avinfo的返回json，发现转码后可以播放与之前不能播放的视频，level 可以明显看出，


 结合文档中说的关于H264压缩级别的

 Although the protocol specification does not limit the video and audio formats, the current Apple implementation supports the following formats:
 Video:
 H.264 Baseline Level 3.0, Baseline Level 3.1, Main Level 3.1, and High Profile Level 4.1.
 个人盲猜level字段可能就是指的是压缩级别，30估计就是文档中的3.0了，并不能确定，错了的话希望大佬可以指点下。
 我目前的解决方式就是视频上传后调用?avinfo判断下这个字段，大于等于41的就调用了下七牛的转码队列。目前为止能解决问题。以后出问题再说吧。。。
 ————————————————
 版权声明：本文为CSDN博主「胡亥。」的原创文章，遵循CC 4.0 BY-SA版权协议，转载请附上原文出处链接及本声明。
 原文链接：https://blog.csdn.net/VC520530/article/details/108883902
 */
