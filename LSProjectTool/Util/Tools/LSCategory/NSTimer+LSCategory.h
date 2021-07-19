//
//  NSTimer+LSCategory.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/6/2.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSTimer (LSCategory)

///暂停定时器
///暂停之后恢复定时器
///销毁定时器
- (void)invalidateTimer;


@end

NS_ASSUME_NONNULL_END
