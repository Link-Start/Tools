//    MIT License
//
//    Copyright (c) 2019 https://liangdahong.com
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in all
//    copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//    SOFTWARE.

////////////////////
/// v3.1.4
////////////////////

#import <UIKit/UIKit.h>
#import "BMLongPressDragCellCollectionViewDelegate.h"
#import "BMLongPressDragCellCollectionViewDataSource.h"

/*
 - (NSArray<NSArray<id> *> *)dataSourceWithDragCellCollectionView:(__kindof BMLongPressDragCellCollectionView *)dragCellCollectionView {
     return self.dataSourceArray;
     // 此协议方法里返回数据源
 }

 - (void)dragCellCollectionView:(__kindof BMLongPressDragCellCollectionView *)dragCellCollectionView newDataArrayAfterMove:(nullable NSArray <NSArray <id> *> *)newDataArray {
     self.dataSourceArray = [newDataArray mutableCopy];
     // 此协议方法里保存数据源
 }
 
 // -------- -------- -------- -------- -------- -------- --------
 /// cell 将要交换时，询问是否能交换
 - (BOOL)dragCellCollectionViewShouldBeginExchange:(__kindof BMLongPressDragCellCollectionView *)dragCellCollectionView sourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    return sourceIndexPath.section == destinationIndexPath.section; // 不能跨分组移动,
    // return YES;  可以跨分组移动
 }
 // 实现了这个方法自己处理数据和cell的交换 上面两个方法代理方法就不用实现了
 - (void)dragCellCollectionViewBeginExchange:(__kindof BMLongPressDragCellCollectionView *)dragCellCollectionView sourceIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    if (sourceIndexPath.section != destinationIndexPath.section) { // 跨分区移动，上面的代理全部返回YES
    // 找到当前移动的item数据
        id *fromGroupModel = self.dataArray[fromIndexPath.section];
        id *item = fromGroupModel.items[sourceIndexPath.row];
    // 找到移动到的分组的数组
        id *toGroupModel = self.dataArray[destinationIndexPath.section];
    // 从原数组中删除 item数据
        [fromGroupModel.items removeObject:item];
    // 将 item数据 按照新的destinationIndexPath.item 位置 插入新分区数组
        [toGroupModel.items insertObject:item atIndex:destinationIndexPath.row];
    // 移动 cell
    [dragCellCollectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
        return;
    }
    // ---- 不跨分组/同一分区 移动 -----
    // 找到 当前移动的item数据
    id *item = self.dataArray[sourceIndexPath.row];
    // 从原数组中删除 item数据
    [self.dataArray removeObject:item];
    // 将 item数据 按照新的destinationIndexPath.item 位置 插入数组
    [self.dataArray insertObject:item atIndex:destinationIndexPath.row];
    // 移动 cell
    [dragCellCollectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
 }
 
 */
@interface BMLongPressDragCellCollectionView : UICollectionView

@property (nonatomic, weak) id<BMLongPressDragCellCollectionViewDelegate> delegate;
@property (nonatomic, weak) id<BMLongPressDragCellCollectionViewDataSource> dataSource;

/// 长按触发拖拽所需时间，默认是 0.5 秒。
@property (nonatomic, assign) NSTimeInterval minimumPressDuration;

/// 是否可以拖拽 默认为 YES。
@property (nonatomic, assign, getter=isCanDrag) IBInspectable BOOL canDrag;

/// 长按拖拽时拖拽中的的 Cell 缩放比例，默认是 1.2 倍。
@property (nonatomic, assign) IBInspectable CGFloat dragZoomScale;

/// 拖拽的 Cell 在拖拽移动时的透明度 默认是： 1.0 不透明。
@property (nonatomic, assign) IBInspectable CGFloat dragCellAlpha;

/// 拖拽到 UICollectionView 边缘时 UICollectionView 的滚动速度
/// 默认为: 8.0f ，建议设置 5.0f 到 15.0f 之间。
@property (nonatomic, assign) IBInspectable CGFloat dragSpeed;

/// 拖拽 View 的背景颜色，默认和被拖拽的 Cell 一样。
@property (nonatomic, strong) IBInspectable UIColor *dragSnapedViewBackgroundColor;

/// 移动到指定位置
/// @param indexPath 移动到的位置
/// 内部只会处理当前正在拖拽的情况，会把拖拽的 Cell 移动到指定位置，建议在停止手势时或者认为适当的时候使用。
- (void)dragMoveItemToIndexPath:(NSIndexPath *)indexPath;

@end
