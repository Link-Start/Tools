//
//  UITextField+LSCursor.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/5/11.
//  Copyright © 2023 Link-Start. All rights reserved.
//  光标

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (LSCursor)

/// 获取光标位置
- (NSInteger)ls_getCursorPosition;
/// 从当前位置偏移
- (void)ls_makeOffsetFromCurrentPosition:(NSInteger)offset;
/// 从头偏移
- (void)ls_makeOffsetFromBeginningPosition:(NSInteger)offset;

@end

NS_ASSUME_NONNULL_END
