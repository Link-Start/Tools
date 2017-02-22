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

#define SOUNDID  1109  //1012 -iphone   1152 ipad  1109 ipad
+ (void)systemVibrate {  //震动
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)systemSound { //声音效果
    AudioServicesPlaySystemSound(SOUNDID);
}
