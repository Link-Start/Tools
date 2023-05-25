//
//  系统 震动、声音效果.h
//  LSProjectTool
//
//  Created by Xcode on 16/8/23.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#ifndef ___________h
#define ___________h


#endif /* ___________h */


#pragma mark- 震动、声音效果
//导入 AudioToolBox.framework
#import "AudioToolbox/AudioToolbox.h"
//#import <AudioToolbox/AudioToolbox.h>


+ (void)systemVibrate {  //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    
//    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);//在不支持震动的设备上(iPod)会播放一段特殊的声音
//    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)//
}


// https://blog.csdn.net/qq_43441647/article/details/128395874
//在需要出发震动的地方写上代码：
//AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);//默认震动效果
//如果想要其他震动效果，可参考：
//// 普通短震，3D Touch 中 Pop 震动反馈
//AudioServicesPlaySystemSound(1520);
//// 普通短震，3D Touch 中 Peek 震动反馈
//AudioServicesPlaySystemSound(1519);
//// 连续三次短震
//AudioServicesPlaySystemSound(1521);

//OS 10之后提供了一套Objective-C的接口
//UIImpactFeedbackGenerator

//UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
//[generator impactOccurred];



//*****************************************************************************************
// https://juejin.cn/post/6844903997606723591
//CoreHaptics 是 iOS13 中的新API，同时只有 iPhone 8 及之后的机型支持。CoreHaptics 提供了更加细腻，可控的震动表达方式，可以令APP产生一种全新的体验。
//震动主要分成两类：
//Transient：简短的震动，像敲击之类的震动。
//Continuous：持续震动，像弦乐器发出的震动

#define SOUNDID  1109  //1012 -iphone   1152 ipad  1109 ipad
+ (void)systemSound { //声音效果
    AudioServicesPlaySystemSound(SOUNDID);
}
