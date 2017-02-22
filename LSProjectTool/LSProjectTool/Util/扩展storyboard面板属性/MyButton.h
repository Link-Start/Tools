//
//  MyButton.h
//  DianDianXiYi
//
//  Created by Xcode on 16/8/2.
//  Copyright © 2016年 mycard. All rights reserved.
//

///可以扩展 storyboard 的属性面板


#import <UIKit/UIKit.h>

IB_DESIGNABLE // 动态刷新

@interface MyButton : UIButton

/**
 *  加上IBInspectable就可以可视化显示相关的属性
 */
/** 可视化设置边框宽度 */
@property (nonatomic, assign)IBInspectable CGFloat borderWidth;

/** 可视化设置边框颜色 */
@property (nonatomic, strong)IBInspectable UIColor *borderColor;

/** 可视化设置圆角 */
@property (nonatomic, assign)IBInspectable CGFloat cornerRadius;


@end
