//
//  AppDelegate+configuration.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2019/1/30.
//  Copyright © 2019年 Link-Start. All rights reserved.
//

#import "AppDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppDelegate (configuration)

- (void)initWindow;

///初始化 配置
- (void)initBasicConfiguration;

//获取IDFA 权限
- (void)obtainIDFA;

/// 读取并识别 粘贴板 内容
- (void)readAndRecognizePastedboardContent;

@end

NS_ASSUME_NONNULL_END
