//
//  LSLayoutTool.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/11/29.
//  Copyright © 2021 Link-Start. All rights reserved.
//
//  UI自动布局的便捷方法, 主要有常用的 宽度, 高度, 字体大小设置. 非常用的封装在LSLayoutTool的struct里面.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSLayoutTool : NSObject



/// 横屏状态下的屏幕宽度
+ (CGFloat)autoScreenWidthInHorizontalScreenState;

@end

NS_ASSUME_NONNULL_END
