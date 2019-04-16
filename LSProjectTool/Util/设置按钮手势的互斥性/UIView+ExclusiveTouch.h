//
//  UIView+ExclusiveTouch.h
//  ExclusiveTouchDemo
//
//  Created by wangyongkang on 17/6/19.
//  Copyright © 2017年 . All rights reserved.

//setExclusiveTouch  是UIView的一个属性，默认为NO（不互斥），设置UIView 接收手势的互斥性为YES，防止多个响应区域被“同时”点击，“同时”响应的问题
//在AppDelegate的didFinishLaunchingWithOptions方法最前面（创建视图之前）调用分类中的方法设置ygExclusiveTouch。可以实现全局设置点击区域的互斥性

#import <UIKit/UIKit.h>
#import <UIKit/UIView.h>

@interface UIView (ExclusiveTouch)<UIAppearance, UIAppearanceContainer>

@property(nonatomic, assign) BOOL ygExclusiveTouch UI_APPEARANCE_SELECTOR; // default is NO

@end
