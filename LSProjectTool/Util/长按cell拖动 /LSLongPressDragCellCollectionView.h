//
//  LSLongPressDragCellCollectionView.h
//  Pension
//
//  Created by 刘晓龙 on 2024/1/30.
//  Copyright © 2024 ouba. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class LSLongPressDragCellCollectionView;


@protocol LSLongPressDragCellCollectionViewDelegate <UICollectionViewDelegate>



/// 设置不能移动的 indexPath，不能抖动
/// 某些indexPaths是不需要交换和晃动的，常见的比如添加按钮等，传入这些indexPaths数组排出交换和抖动操作
/// @param return   需要排除的indexPath数组，该数组中的indexPath无法长按抖动和交换
- (NSArray<NSIndexPath *> *)excludeIndexPathsWhenMoveDragCellCollectionView:(__kindof LSLongPressDragCellCollectionView *)collectionView;

/// 开始移动时，用于确定是否可以移动指定的item，
/// indexPath:开始移动时 cell的 indexPath
- (BOOL)collectionView:(__kindof LSLongPressDragCellCollectionView *)collectionView
                                        shouldCanMoveItemAtIndexPath:(NSIndexPath *)indexPath;

/// 设置是否可以跨分组/分区移动
/// toIndexPath：将要移动到的 indexPath
- (BOOL)collectionView:(__kindof LSLongPressDragCellCollectionView *)collectionView
                                    shouldCanMoveItemToOtherSection:(NSIndexPath *)toIndexPath;

/// 长按手势结束，
/// 结束移动cell，可以做其他操作，最好不要在这里调用接口
/// toIndexPath：cell移动到的 indexPath
- (void)collectionView:(__kindof LSLongPressDragCellCollectionView *)collectionView
                                        endMoveCellAtIndexPath:(NSIndexPath *)toIndexPath;

/// 已经移动cell，最好在这里调用接口/或者保存数据到本地
/// fromIndexPath：起始位置indexPath
/// toIndexPath：结束位置的indexPath
- (void)collectionView:(__kindof LSLongPressDragCellCollectionView *)collectionView
                                    didMoveCellFromIndexPath:(NSIndexPath *)fromIndexPath
                                                toIndexPath:(NSIndexPath *)toIndexPath;



@end



@interface LSLongPressDragCellCollectionView : UICollectionView

/// 长按手势
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;

/// 长按手势选中的 indexPath
@property (nonatomic, strong, readonly) NSIndexPath *longPressIndexPath;


@property (nonatomic, weak) id<LSLongPressDragCellCollectionViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
