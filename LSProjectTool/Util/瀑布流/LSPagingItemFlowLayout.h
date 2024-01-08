//
//  LSPagingItemFlowLayout.h
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/12/4.
//  Copyright © 2023 Link-Start. All rights reserved.
//
//
//
// iOS UICollectionView横向滑动并且横向加载数据
// https://www.jianshu.com/p/619dda11ad6e




#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LSPagingItemFlowLayout : UICollectionViewFlowLayout

//一行中cell的个数
@property(nonatomic, assign)NSUInteger itemCountPerRow;
//一页显示多少行
@property(nonatomic, assign)NSUInteger rowCount;
//一页计划设置显示多少行
@property(nonatomic, assign)NSUInteger rowPlanCount;

@end

NS_ASSUME_NONNULL_END

/**
 
 主要通过下面这4个方法，对自定义UICollectionViewFlowLayout进行定制操作。

 ///子类可以重写它，并使用它来设置数据结构或执行稍后执行布局所需的任何初始计算。
 -(void)prepareLayout;
 ///滚动范围
 -(CGSize)collectionViewContentSize;
 ///子类必须重写此方法，并使用它返回视图与指定矩形相交的所有项的布局信息。
 -(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect;
 ///子类必须重写此方法并使用它返回集合视图中项的布局信息。即修改x，y坐标
 -(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath;

 */
