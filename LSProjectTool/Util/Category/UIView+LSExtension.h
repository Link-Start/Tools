//
//  UIView+LSExtension.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2021/5/20.
//  Copyright © 2021 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (LSExtension)

///设置圆角
- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
@end

NS_ASSUME_NONNULL_END
