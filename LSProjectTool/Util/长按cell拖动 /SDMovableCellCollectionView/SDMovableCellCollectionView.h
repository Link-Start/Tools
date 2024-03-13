//
//  SDMovableCellCollectionView.h
//  NPC
//
//  Created by liushuo on 2023/2/25.
//  Copyright © 2023 NPC.work. All rights reserved.
//
//  collectionView 长按拖拽
//  支持跨分组移动
// 

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SDMovableCellCollectionView;

@protocol SDMovableCellCollectionViewDataSource <UICollectionViewDataSource>

/// 必须的
@required
/**
 *  Get the data source array of the collectionView, each time you start the call to get the latest data source.
 *  The array in the data source must be a mutable array, otherwise it cannot be exchanged
 *  The format of the data source:@[@[sectionOneArray].mutableCopy, @[sectionTwoArray].mutableCopy, ....].mutableCopy
 *  Even if there is only one section, the outermost layer needs to be wrapped in an array, such as:@[@[sectionOneArray].mutableCopy].mutableCopy
 *  数据源约束: 多组数组嵌套且为可变数组
 */
- (NSMutableArray <NSMutableArray *> *)dataSourceArrayInCollectionView:(SDMovableCellCollectionView *)collectionView;

/// 可选择的
@optional

/// 返回自定义截图的部分
- (UIView *)snapshotViewWithCell:(UICollectionViewCell *)cell;

@end

@protocol SDMovableCellCollectionViewDelegate <UICollectionViewDelegate>
@optional

/// 将要开始移动，判断是否可以移动cell，和系统的功能相同
- (BOOL)collectionView:(SDMovableCellCollectionView *)collectionView canMoveCellAtIndexPath:(NSIndexPath *)fromIndexPath;

/// The cell that will start moving the indexPath location
/// 长按拖拽cell将要开始移动
- (void)collectionView:(SDMovableCellCollectionView *)collectionView willMoveCellAtIndexPath:(NSIndexPath *)indexPath;

/// 设置是否可以跨分组/分区移动
/// toIndexPath：将要移动到的 indexPath
- (BOOL)collectionView:(SDMovableCellCollectionView *)collectionView canMoveCellToOtherSection:(NSIndexPath *)toIndexPath;

/// Move cell `fromIndexPath` to `toIndexPath` completed
/// 移动cell换了位置下标，在这里进行数据 交换
- (void)collectionView:(SDMovableCellCollectionView *)collectionView didMoveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

/// Move cell ended
/// 移动cell结束，在这里调用cell移动完成之后需要修改数据的接口
- (void)collectionView:(SDMovableCellCollectionView *)collectionView endMoveCellAtIndexPath:(NSIndexPath *)indexPath;

/// The user tries to move a cell that is not allowed to move. You can make some prompts to inform the user.
/// 尝试长按拖拽不能移动的cell 这个代理方法可以加个toast或者其他处理 与设置`canHintWhenCannotMove`不冲突
- (void)collectionView:(SDMovableCellCollectionView *)collectionView tryMoveUnmovableCellAtIndexPath:(NSIndexPath *)indexPath;

/// Customize the screenshot style of the movable cell
/// 自定义移动的cell截图的样式 加阴影啥的
- (void)collectionView:(SDMovableCellCollectionView *)collectionView customizeMovalbeCell:(UIImageView *)movableCellsnapshot;

/// Custom start moving cell animation
/// 自定义cell拖拽移动的动画
- (void)collectionView:(SDMovableCellCollectionView *)collectionView customizeStartMovingAnimation:(UIImageView *)movableCellsnapshot fingerPoint:(CGPoint)fingerPoint;

@end


@interface SDMovableCellCollectionView : UICollectionView

@property (nonatomic, weak) id<SDMovableCellCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id<SDMovableCellCollectionViewDelegate> delegate;
/// 长按手势
@property (nonatomic, strong, readonly) UILongPressGestureRecognizer *longPressGesture;
/// 长按手势选中的 indexPath
@property (nonatomic, strong, readonly) NSIndexPath *startIndexPath;
/**
 *  Whether to allow dragging to the edge of the screen, turn on edge scrolling, default YES
 *  是否允许拖动到屏幕边缘，启用边缘滚动，默认为YES
 */
@property (nonatomic, assign) BOOL canEdgeScroll;

/**
 *  Edge scroll trigger range, default 150, the faster the edge is closer to the edge
 *  边缘滚动触发范围，默认为150，越靠近边缘滚得越快
 */
@property (nonatomic, assign) CGFloat edgeScrollTriggerRange;

/**
 *  When the CADisplayLink callback, self.contentOffsetY can scroll max speed, default 20. the faster the edge closer
 *  当CADisplayLink回调时，self.contentOffsetY可以滚动的最大速度，默认为20 帧/s。
 */
@property (nonatomic, assign) CGFloat maxScrollSpeedPerFrame;

/**
 * 当cell不允许被移动的时候，长按时是否提示。默认为YES。
 */
@property (nonatomic, assign) BOOL canHintWhenCannotMove;

/**
 * 是否允许震动反馈。默认为NO。
 */
@property (nonatomic, assign) BOOL canFeedback NS_AVAILABLE_IOS(10_0);




@end

NS_ASSUME_NONNULL_END

/**
 #pragma mark -  **************************************
 // 是否可以高亮
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
     return YES;
 }

 // 高亮时调用
 - (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
     UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
     cell.alpha = 0.7;
 }

 // 高亮结束调用
 - (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
     UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
     cell.alpha = 1.0;
 }

 #pragma mark - SDMovableCellTableViewDelegate, SDMovableCellTableViewDataSource
 /// 数据源
 - (NSMutableArray<NSMutableArray *> *)dataSourceArrayInCollectionView:(SDMovableCellCollectionView *)collectionView {
     if (self.isAllGroupList == YES) { //全部
         return self.allGroupListDetailsArray;
     }
     return self.otherGroupListDetailsArray;
 }

 // 将要开始移动，判断是否可以移动cell，和系统的功能相同
 - (BOOL)collectionView:(UICollectionView *)collectionView canMoveCellAtIndexPath:(NSIndexPath *)indexPath {
 //    return YES;
 }

 // 移动cell换了位置下标
 - (void)collectionView:(SDMovableCellCollectionView *)collectionView didMoveCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    
 //    if (fromIndexPath.section != toIndexPath.section) { // 跨分组移动，上面的代理全部返回YES
 //        VisualPromotionGroupModel *fromGroupModel = self.allGroupListDetailsArray[fromIndexPath.section];
 //        VisualPromotionGroupItems *item = fromGroupModel.items[fromIndexPath.row];
 //        VisualPromotionGroupModel *toGroupModel = self.allGroupListDetailsArray[toIndexPath.section];
 //
 //        [fromGroupModel.items removeObject:item];
 //        [toGroupModel.items insertObject:item atIndex:toIndexPath.row];
 //        [collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
 //        return;
 //    }
     
     if (self.isAllGroupList == YES) { //全部
         VisualPromotionGroupModel *groupModel = self.allGroupListDetailsArray[fromIndexPath.section];
         VisualPromotionGroupItems *item = groupModel.items[fromIndexPath.row];
         [groupModel.items removeObject:item];
         [groupModel.items insertObject:item atIndex:toIndexPath.row];
         [collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
     }  else {
         VisualPromotionGroupItems *item = self.otherGroupListDetailsArray[fromIndexPath.row];
         [self.otherGroupListDetailsArray removeObject:item];
         [self.otherGroupListDetailsArray insertObject:item atIndex:toIndexPath.row];
         [collectionView moveItemAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
     }
 }

 // 移动cell结束
 - (void)collectionView:(SDMovableCellCollectionView *)collectionView endMoveCellAtIndexPath:(NSIndexPath *)indexPath {
     
     if (self.collectionView.startIndexPath.item == indexPath.item) { // 没有移动
         return;
     }
     
     if (self.isAllGroupList == YES) { //全部
         VisualPromotionGroupModel *groupModel = self.allGroupListDetailsArray[indexPath.section];
         [self longPressMoveSortItemWithCurrentItems:groupModel.items];
     }  else {
         [self longPressMoveSortItemWithCurrentItems:self.otherGroupListDetailsArray];
     }
     
 }

 #pragma mark -  **************************************

 */
