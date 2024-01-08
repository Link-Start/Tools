//
//  LSPagingItemFlowLayout.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/12/4.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#import "LSPagingItemFlowLayout.h"

@interface LSPagingItemFlowLayout ()


@end

@implementation LSPagingItemFlowLayout

- (void)prepareLayout {
    
    [super prepareLayout];

    self.itemCountPerRow = 4;
    self.rowPlanCount = 2;
}

///滚动范围
- (CGSize)collectionViewContentSize {
    CGSize size = CGSizeZero;
    NSInteger itemCount = 0;
    if ([self.collectionView.dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        itemCount = [self.collectionView.dataSource collectionView:self.collectionView numberOfItemsInSection:0];
    }
    if (CGSizeEqualToSize(size, CGSizeZero) && itemCount == 0) {
        return CGSizeZero;
    }
    /// 解决只有一行时布局错乱的问题,  感谢指出问题
    if (itemCount <= self.itemCountPerRow) {
      itemCount = self.itemCountPerRow + 1;
    }
    self.rowCount = (itemCount * 1.0 / self.itemCountPerRow)<=1?1:2;

    //宽度按整个collectionView的宽度取超过一页按两页算
    size.width = ceilf(itemCount* 1.0 / (self.itemCountPerRow * self.rowPlanCount)) * self.collectionView.frame.size.width;
    
    return size;
}

///子类必须重写此方法，并使用它返回视图与指定矩形相交的所有项的布局信息。
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    //获取UICollectionViewFlowLayout重写的相关排列
    NSArray *attributes = [super layoutAttributesForElementsInRect:rect];

    NSMutableArray *newAttributes = [NSMutableArray array];
    for(NSUInteger i = 0; i < attributes.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];

        UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [newAttributes addObject:attributes];
    }
    
    return newAttributes;
}

///子类必须重写此方法并使用它返回集合视图中项的布局信息。即修改x，y坐标
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath*)indexPath {
    
    NSUInteger item = indexPath.item;

    NSUInteger x;

    NSUInteger y;
    //计算向右，向下偏移的位置
    //目标布局
    //0-1-2-3  08-09-10-11
    //4-5-6-7  12-13-14-15
    [self targetPositionWithItem:item resultX:&x resultY:&y];
    //根据偏移量计算新的位置
    //                      (x,y)
    //原布局                 (0,0),(1,0),(2,0),(3,0)   (4,0),(5,0), (6,0),  (7,0)
    //0-2-4-6  8-10-12-14   0->0, 1->2, 2->4, 3->6    8->8, 9->10, 10->12, 11->14
    //                      (0,1),(1,1),(2,1),(3,1)   (4,1),(5,1),   (6,1)   (7,1)
    //1-3-5-7  9-11-13-15   4->1, 5->3, 6->5, 7->7    12->9, 13->11, 14->13, 15->15
    //根据偏移量计算将被替换的item
    NSUInteger item2 = [self originItemAtX:x y:y];

    //取得将被替换的item的indexPath
    NSIndexPath *theNewIndexPath = [NSIndexPath indexPathForItem:item2 inSection:indexPath.section];
    //取得将被替换的item的Attributes信息
    UICollectionViewLayoutAttributes *theNewAttr = [super layoutAttributesForItemAtIndexPath:theNewIndexPath];
    //交换取得的item的indexPath为当前indexPath
    theNewAttr.indexPath = indexPath;

    return theNewAttr;
}

///根据item计算目标item的位置
/// x横向偏移y竖向偏移
- (void)targetPositionWithItem:(NSUInteger)item resultX:(NSUInteger *)x resultY:(NSUInteger *)y {
    
    // 页数 = 当前顺序 / （一行个数 * 行数 ）
    NSUInteger page = item / (self.itemCountPerRow * self.rowCount);
    // x坐标 = 当前顺序 % 一行个数 + 页数 * 一行个数
    NSUInteger theX = item % self.itemCountPerRow + page * self.itemCountPerRow;
    // y坐标 = 当前顺序 / 一行个数 - 页数 * 行数
    NSUInteger theY = item / self.itemCountPerRow - page * self.rowCount;

    if(x != NULL) {
        *x = theX;
    }

    if(y != NULL) {
        *y = theY;
    }
}

///根据偏移量计算item
- (NSUInteger)originItemAtX:(NSUInteger)x y:(NSUInteger)y {
    
    //新的顺序 = x偏移 * 行数 + y偏移
    NSUInteger item = x * self.rowCount + y;
    return item;
}



@end
