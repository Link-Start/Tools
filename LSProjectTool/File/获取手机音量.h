//
//  获取手机音量.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/10/9.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#ifndef _______h
#define _______h

// iOS 获取/同步系统音量：https://juejin.cn/post/7210020384045187133
// ios获取系统音量 iphone调节系统音量 转载：https://blog.51cto.com/u_16099318/6847378
// iOS 系统服务声音大小 iphone怎么调系统音量： https://blog.51cto.com/u_16099200/6841629?articleABtest=0
// ios 获取是否静音模式_iOS音量和静音按键状态获取：https://blog.csdn.net/weixin_36295010/article/details/114178902
// iOS正确监听手机静音键和侧边音量键的方法示例：https://www.uoften.com/article/207567.html
// _如何判断手机是否为静音模式：https://blog.csdn.net/weasleyqi/article/details/11593313?spm=1001.2101.3001.6650.15&utm_medium=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-15-11593313-blog-114178902.235%5Ev38%5Epc_relevant_anti_vip&depth_1-utm_source=distribute.pc_relevant.none-task-blog-2%7Edefault%7EBlogCommendFromBaidu%7ERate-15-11593313-blog-114178902.235%5Ev38%5Epc_relevant_anti_vip&utm_relevant_index=16
// 在iOS 5之前，通过使用音频路由来检测播放类型来检测设备是否静音是相对简单的：https://github.com/Rich2k/RBDMuteSwitch

// 由于iOS15 之后AVSystemController_SystemVolumeDidChangeNotification通知不再回调, 所以我们通过MPVolumeView来获取
// 我们需要定义2个Slider,一个用于获取MPVolumeView的slider子视图,也用于控制系统音量，另一个Slider用来展示,以及接受控制事件.



通过MPVolumeView

这个方法是苹果官方推荐的方法。MPVolumeView是Media Player Framework中的一个UI组件，直接包含了对系统音量和Airplay设备的音频镜像路由的控制功能。MPVolumeView的使用很简单，只需要将其加入到一个父视图中，给予父视图合适的大小，再创建MPVolumeView示例，将其加入到父视图中即可

但是他的缺点也是很明显的：
1>MPVolumeView的可定制化是很低的，里面提供了很少的几个方法，并且几乎都是用图片来定制界面
2>将其假如到我们的视图层级之后，显示的是一个滑块(UISlider),在APP中，大多时候音量的控制我们是要自己定制的，如在视频的播放中

解决方法：
但是MPVolumeView的子视图中包含一个MPVolumeSlider的subview用来控制音量。这个MPVolumeSlider是一个私有类，我们无法手动创建此类，但这个类是UISlider的子类。于是我们便可以将这个控件给提取出来，便可以间接的控制系统音量，可以遍历它的子视图找到MPVolumeSlider



我们只要改变得到的volumeViewSlider 的value 就可以间接的控制系统的音量
如下：
/*
 *获取系统音量滑块
 */
+(UISlider*)getSystemVolumSlider{
    static UISlider * volumeViewSlider = nil;
    if (volumeViewSlider == nil) {
        MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectMake(10, 50, 200, 4)];
        
        for (UIView* newView in volumeView.subviews) {
            if ([newView.class.description isEqualToString:@"MPVolumeSlider"]){
                volumeViewSlider = (UISlider*)newView;
                break;
            }
        }
    }
    return volumeViewSlider;
}


/*
 *获取系统音量大小
 */
+(CGFloat)getSystemVolumValue{
    return [[self getSystemVolumSlider] value];
}
/*
 *设置系统音量大小
 */
+(void)setSysVolumWith:(double)value{
    [self getSystemVolumSlider].value = value;
}

#endif /* _______h */
