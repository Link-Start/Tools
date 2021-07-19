//
//  JYEqualCellSpaceFlowLayout.h
//  UICollectionViewDemo
//
//  Created by 飞迪1 on 2017/10/13.
//  Copyright © 2017年 CHC. All rights reserved.
//
// collectionView 自适应宽度

#import <UIKit/UIKit.h>

IB_DESIGNABLE // 动态刷新

typedef NS_ENUM(NSInteger,AlignType){
    AlignWithLeft,//左对齐
    AlignWithCenter,//居中对齐
    AlignWithRight //靠右对齐
};
@interface JYEqualCellSpaceFlowLayout : UICollectionViewFlowLayout
//两个Cell之间的距离
@property (nonatomic,assign) IBInspectable CGFloat betweenOfCell;
//cell对齐方式
@property (nonatomic,assign) IBInspectable AlignType cellType;

-(instancetype)initWthType : (AlignType)cellType;
//全能初始化方法 其他方式初始化最终都会走到这里
-(instancetype)initWithType:(AlignType) cellType betweenOfCell:(CGFloat)betweenOfCell;

@end
