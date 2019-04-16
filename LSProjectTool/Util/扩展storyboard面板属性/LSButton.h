//
//  LSButton.h
//  RuiTuEBusiness
//
//  Created by Link_Start on 2018/2/9.
//  Copyright © 2018年 Naive. All rights reserved.
//
///可以扩展 storyboard 的属性面板

#import <UIKit/UIKit.h>

//typedef <#returnType#>(^<#name#>)(<#arguments#>);
// 返回值(^block名称)(参数);

typedef NS_ENUM(NSUInteger, LSButtonStyle){
    ///默认图片在左
    LSButtonStyleNormal = 0,
    ///图片在右
    LSButtonStyleImageRight,
    ///图片在上
    LSButtonStyleImageTop,
    ///图片在下
    LSButtonStyleImageBottom,
    
    LSButtonStyleImageLeft = LSButtonStyleNormal,
};



IB_DESIGNABLE // 动态刷新

@interface LSButton : UIButton

/**
 *  加上IBInspectable就可以可视化显示相关的属性
 */

/********** 边框、切圆角 **********/
/** 可视化设置边框宽度 */
@property (nonatomic, assign) IBInspectable CGFloat ls_borderWidth;
/** 可视化设置边框颜色 */
@property (nonatomic, strong) IBInspectable UIColor *ls_borderColor;
/** 可视化设置圆角 */
@property (nonatomic, assign) IBInspectable CGFloat ls_cornerRadius;

/********** 下划线 **********/
@property (nonatomic, strong) IBInspectable UIColor *ls_underlineColor;
/********** button文字与图片位置 **********/
/** 图片和文字位置 */
@property (nonatomic, assign) IBInspectable LSButtonStyle ls_style;
///文字与图片之间的间距，默认是0
@property (nonatomic, assign) IBInspectable CGFloat ls_padding;
///图片距离button的边距，如果图片比较大的，此时有效果；如果图片比较小，没有效果，默认居中；
@property (nonatomic, assign) IBInspectable CGFloat ls_space;

/********** button isSelected状态下的背景色、文字颜色 **********/
///button 是否是isSelected 状态
@property (nonatomic, assign) IBInspectable BOOL ls_isSelected;
///button isSelected=YES 状态的背景色
@property (nonatomic, strong) IBInspectable UIColor *ls_isSelectedBgColor;
///button isSelected=YES 状态文字颜色
@property (nonatomic, strong) IBInspectable UIColor *ls_isSelectedTitleColor;
///button isSelected=NO 状态的背景色
@property (nonatomic, strong) IBInspectable UIColor *ls_isNotSelectedBgColor;
///button isSelected=NO 状态文字颜色
@property (nonatomic, strong) IBInspectable UIColor *ls_isNotSelectedTitleColor;






- (LSButton *)ls_with;
- (LSButton *)ls_and;

@end
