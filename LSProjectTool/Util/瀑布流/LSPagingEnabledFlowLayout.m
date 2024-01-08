//
//  LSPagingEnabledFlowLayout.m
//  LSProjectTool
//
//  Created by 刘晓龙 on 2023/9/18.
//  Copyright © 2023 Link-Start. All rights reserved.
//

#import "LSPagingEnabledFlowLayout.h"
#import <objc/message.h>

@interface LSPagingEnabledFlowLayout ()


@end

@implementation LSPagingEnabledFlowLayout

- (void)prepareLayout {
    [super prepareLayout];
    
    CGSize itemSize_ = self.itemSize;
    id<UICollectionViewDelegateFlowLayout> layoutDelegate = (id<UICollectionViewDelegateFlowLayout>)self.collectionView.delegate;
    if ([layoutDelegate respondsToSelector:@selector(collectionView:layout:sizeForItemAtIndexPath:)]) {
        itemSize_ = [layoutDelegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    
    CGFloat contentInset = self.collectionView.frame.size.width - itemSize_.width;
    
    self.collectionView.decelerationRate = UIScrollViewDecelerationRateFast;
    if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setInterpageSpacing:")]) {
        ((void(*)(id,SEL,CGSize))objc_msgSend)(self.collectionView, NSSelectorFromString(@"_setInterpageSpacing:"), CGSizeMake(-(contentInset-self.minimumLineSpacing/2), 0));
    }
    if ([self.collectionView respondsToSelector:NSSelectorFromString(@"_setPagingOrigin:")]) {
        ((void(*)(id,SEL,CGPoint))objc_msgSend)(self.collectionView, NSSelectorFromString(@"_setPagingOrigin:"), CGPointMake(0, 0));
    }
}


@end











/*********************************************************** 下面这方法好像不行 **************************************************************/
/////////// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
/// 分页，这方法好像不行
// https://zhuanlan.zhihu.com/p/640946352
/////////// XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//#import "LSPagingEnabledFlowLayout.h"
//
//@interface LSPagingEnabledFlowLayout ()
//
//@property (nonatomic, assign) CGPoint lastOffset;
//
//@end
//
//@implementation LSPagingEnabledFlowLayout
//
//- (instancetype)init {
//    self = [super init];
//    if (self) {
//        _lastOffset = CGPointZero;
//    }
//    return self;
//}
//
//// 这个方法的返回值，决定了 CollectionView 停止滚动时的偏移量
//- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
//
//    // 分页的 width
//    CGFloat pageSpace = [self stepSpace];
//    CGFloat offsetMax = self.collectionView.contentSize.width - (pageSpace + self.sectionInset.right) + self.minimumLineSpacing;
//    CGFloat offsetMin = 0;
//
//    // 修改之前记录的位置，如果小于最小的contentsize或者最大的contentsize则重置值
//    if (_lastOffset.x < offsetMin) {
//        _lastOffset.x = offsetMin;
//    } else if (_lastOffset.x > offsetMax) {
//        _lastOffset.x = offsetMax;
//    }
//
//    // 目标位移点距离当前点距离的绝对值
//    CGFloat offsetForCurrentPointX = fabs(proposedContentOffset.x - _lastOffset.x);
//    CGFloat velocityX = velocity.x;
//
//    // 判断当前滑动方向，向左 true, 向右 fasle
//    BOOL directionLeft = (proposedContentOffset.x - _lastOffset.x) > 0;
//
//    CGPoint newProposedContentOffset = CGPointZero;
//
//    if ((offsetForCurrentPointX > pageSpace/8.0)
//        && (_lastOffset.x >= offsetMin)
//        && (_lastOffset.x <= offsetMax)) {
//
//        /***********  1.  **********/
////        // 分页因子，用于计算滑过的cell数量
////        NSInteger pageFactor = 0;
////        if (velocityX != 0) {
////            // 滑动
////            // 速率越快，cell 滑过的数量越多
////            pageFactor = fabs(velocityX);
////        } else {
////            // 拖动
////            pageFactor = fabs(offsetForCurrentPointX / pageSpace);
////        }
////        // 设置 pageFactor 的上限为2，防止滑动速率过大，导致翻页过多
////        pageFactor = pageFactor < 1 ? 1 : (pageFactor < 3 ? 1 : 2);
////
////        CGFloat pageOffsetX = pageSpace * pageFactor;
////        newProposedContentOffset = CGPointMake(_lastOffset.x + (directionLeft?pageOffsetX:-pageOffsetX), proposedContentOffset.y);
//
//        /***********  2.  **********/
//        CGFloat pageOffsetX = directionLeft ? pageSpace : -pageSpace;
//        newProposedContentOffset = CGPointMake(_lastOffset.x + pageOffsetX, proposedContentOffset.y);
//    } else {
//        // 滚动距离小于翻页步距，则不进行翻页
//        newProposedContentOffset = CGPointMake(_lastOffset.x, _lastOffset.y);
//    }
//
//    _lastOffset.x = newProposedContentOffset.x;
//    return newProposedContentOffset;
//}
//
///// 每滑动一页的间距
//- (CGFloat)stepSpace {
//    return self.itemSize.width + self.minimumLineSpacing;
//}
//
//@end
