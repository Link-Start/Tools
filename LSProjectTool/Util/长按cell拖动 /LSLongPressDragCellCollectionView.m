//
//  LSLongPressDragCellCollectionView.m
//  Pension
//
//  Created by 刘晓龙 on 2024/1/30.
//  Copyright © 2024 ouba. All rights reserved.
//

#import "LSLongPressDragCellCollectionView.h"

@interface LSLongPressDragCellCollectionView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;

@property (nonatomic, assign) CGFloat gestureMinimumPressDuration;

/// 长按手势选中的 indexPath
@property (nonatomic, strong) NSIndexPath *longPressIndexPath;
/// 长按手势选中的 cell
@property (nonatomic, strong) UICollectionViewCell *longPressCell;

@end

@implementation LSLongPressDragCellCollectionView

@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        self.rowHeight = 0;
//        self.estimatedRowHeight = 0;
//        self.estimatedSectionHeaderHeight = 0;
//        self.estimatedSectionFooterHeight = 0;
//        self.generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [self initData];
        [self addLongPressGestureRecognizer];// 添加长按手势
    }
    return self;
}

- (void)initData {
    _gestureMinimumPressDuration = 0.5f;
//    _canEdgeScroll = YES;
//    _edgeScrollTriggerRange = 150.f;
//    _maxScrollSpeedPerFrame = 20;
//    _canHintWhenCannotMove = YES;
//    _canFeedback = NO;
    
}

#pragma mark Gesture
/// 添加长按手势
- (void)addLongPressGestureRecognizer {
    // 初始化长按手势识别器
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognizerAction:)];
    longPressGesture.minimumPressDuration = self.gestureMinimumPressDuration;
    [self addGestureRecognizer:longPressGesture];
    self.longPressGesture = longPressGesture;
}

/// 实现手势识别器的方法
- (void)longPressGestureRecognizerAction:(UILongPressGestureRecognizer *)longPressGesture {
//    if (gesture.state == UIGestureRecognizerStateBegan) {
//        CGPoint location = [gesture locationInView:self];
//        NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
//        if (indexPath == nil) {
//            // 用户长按非cell区域，可以做其他处理
//        } else {
//            //用户长按cell
//            self.longPressIndexPath  = indexPath;
//            // 找到当前的cell
//            UICollectionViewCell *temCell = [self cellForItemAtIndexPath:indexPath];
//            self.longPressCell = temCell;
//            [self startLongPressAnimation:self.longPressCell];
//            // 用户长按cell，启用移动模式
//            [self beginInteractiveMovementForItemAtIndexPath:indexPath];
//        }
//    } else if (gesture.state == UIGestureRecognizerStateChanged) {
//        // 当手势改变时更新移动位置
//        [self updateInteractiveMovementTargetPosition:[gesture locationInView:self]];
//    } else if (gesture.state == UIGestureRecognizerStateEnded) {
//        // 手势结束时，结束移动操作
//        [self endInteractiveMovement];
//    } else {
//        // 取消移动操作
//        [self cancelInteractiveMovement];
//    }
    
    // 获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint location = [longPressGesture locationInView:self];
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
    
    //根据长按手势的状态进行处理。
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan: // 手势开始
        {
            if (!indexPath) {
                // 用户长按非cell区域，可以做其他处理
                break;
            }
            // 用户长按cell
            self.longPressIndexPath  = indexPath;//记录长按的cell，
            
            // 找到当前长按的cell
            UICollectionViewCell *temCell = [self cellForItemAtIndexPath:indexPath];
            self.longPressCell = temCell;
            [self startLongPressAnimation:self.longPressCell];
            
            // 用户长按cell，启用移动模式，【开始移动的时候调用此方法】
            // 可以获取相应的datasource方法设置特殊的indexpath 能否移动,如果能移动返回的是YES ,不能移动返回的是NO
            [self beginInteractiveMovementForItemAtIndexPath:indexPath];
        }
            break;
        case UIGestureRecognizerStateChanged:// 手势变化
        {
//            CGPoint location = [longPress locationInView:self];
//            NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
            if (!indexPath) {
                // 用户移动到 非cell区域，可以做其他处理
                break;
            }
            // 设置是否可以分组/分区区移动
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldCanMoveItemToOtherSection:)]) {
                BOOL canMove = [self.delegate collectionView:self shouldCanMoveItemToOtherSection:indexPath];
                //  不能跨分组/分区移动，&&  不在同一个分组/分区
                if (!canMove && (indexPath.section != self.longPressIndexPath.section)) { // 如果不在同一个分组/分区
                    [self cancelInteractiveMovement]; // 取消移动操作,
                    break;
                }
            }
            
            // 更新移动过程的位置，【当手势改变时更新移动位置】
            [self updateInteractiveMovementTargetPosition:location];
        }
            break;
        case UIGestureRecognizerStateEnded:// 手势结束
        {
            // 手势结束时，结束移动操作，【结束移动的时候调用此方法】
            [self endInteractiveMovement];
            
            [self endShareAnimation:self.longPressCell];
            
//            CGPoint location = [longPress locationInView:self];
//            NSIndexPath *indexPath = [self indexPathForItemAtPoint:location];
            if (!indexPath) {
                // 用户移动到 非cell区域，可以做其他处理
                break;
            }
            
            // 同一个分组/分区的同一个位置
            if (indexPath == self.longPressIndexPath) { // 没有移动
                break;
            }
            // 设置是否可以分组/分区区移动
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldCanMoveItemToOtherSection:)]) {
                BOOL canMove = [self.delegate collectionView:self shouldCanMoveItemToOtherSection:indexPath];
                //  不能跨分组/分区移动 &&  不在同一个分组/分区
                if (!canMove && (indexPath.section != self.longPressIndexPath.section)) { // 如果不在同一个分组/分区
                    break;
                }
            }
            
            // 长按手势结束，移动cell结束，其他操作 处理
            [self endMoveCellAtIndexPath:indexPath];//先结束手势，然后走交换数据的方法
            break;
        }
        case UIGestureRecognizerStateCancelled:// 手势取消
        {
            // 取消移动操作,【取消移动的时候调用，会返回最原始的位置。在手势结束的状态使用此方法,好像并不会有返回原始位置的动作】
            [self cancelInteractiveMovement];
            [self endShareAnimation:self.longPressCell];
        }
            break;
        default:
            break;
    }
}

#pragma mark - 长按手势结束
/// 长按手势结束/移动cell手势结束，
/// 最好不要在这里 调用接口，
/// 因为当cell，移动过程中挤走其他cell，但是cell最后移动到非cell区域，手势变化那里做了判断处理进行拦截，导致走不到这个方法，
///         但是会走- (void)collectionView:moveItemAtIndexPath:toIndexPath:这个代理方法，因此可以在交换数据之后进行接口调用，更新后台数据/或者保存数据到本地
- (void)endMoveCellAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"处理其他逻辑");
    // 外部处理其他操作
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:endMoveCellAtIndexPath:)]) {
        [self.delegate collectionView:self endMoveCellAtIndexPath:indexPath];
    }
}

// 长按手势结束之后，才会走下面的代理方法
//- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;


#pragma mark - 动画
/// 开始抖动
- (void)startLongPressAnimation:(UICollectionViewCell *)cell {
    CABasicAnimation *animation = [cell.layer animationForKey:@"rotation"];
    if (animation == nil) {
        [self shakeAnimation:cell];
    } else {
        [self resumeShakeAnimation:cell];
    }
}
/// 抖动动画
- (void)shakeAnimation:(UICollectionViewCell *)cell {
    // 创建动画对象,绕Z轴旋转
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    // 设置属性，周期时长
    [animation setDuration:0.1];
    //抖动角度
    animation.fromValue = @(-M_1_PI/2);
    animation.toValue = @(M_1_PI/2);
    //重复次数，无限大
    animation.repeatCount = HUGE_VAL;
    //恢复原样
    animation.autoreverses = YES;
    // 锚点设置为图片中心，绕中心抖动
    cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
    [cell.layer addAnimation:animation forKey:@"rotation"];
}
/// 重新开始
- (void)resumeShakeAnimation:(UICollectionViewCell *)cell {
    cell.layer.speed = 1.0;
}
/// 结束动画
- (void)endShareAnimation:(UICollectionViewCell *)cell {
    if (self.longPressCell) {
        [self.longPressCell.layer removeAllAnimations];
    }
}

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

#pragma mark - 设置 indexPath 的cell是否可以移动
/// 在开始移动的时候会调用这个方法，如果有特殊的单元格不想被移动可以return NO， 如果没有限制就返回YES
/// indexPath：collectionView中想要移动的 indexpath
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 设置不能移动不能抖动 的 indexPath，
    if (self.delegate && [self.delegate respondsToSelector:@selector(excludeIndexPathsWhenMoveDragCellCollectionView:)]) {
        NSArray<NSIndexPath *> *excludeIndexPaths = [self.delegate excludeIndexPathsWhenMoveDragCellCollectionView:self];
        __block BOOL flag = NO;
        [excludeIndexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.item == indexPath.item && obj.section == indexPath.section) {
                flag = YES;
                *stop = YES;
            }
        }];
        return flag;
    }
    
    // 根据indexpath判断单元格是否可以移动，如果都可以移动，直接就返回YES ,不能移动的返回NO
    // 这里可以根据你的逻辑来决定哪些item可以移动，哪些不可以
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldCanMoveItemAtIndexPath:)]) {
        BOOL canMove = [self.delegate collectionView:self shouldCanMoveItemAtIndexPath:indexPath];
        if (!canMove) {
            // 抖动动画
            [self shakeAnimationX:indexPath];
        }
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.alpha = 0.7;
        return canMove;
    }
    
    // 判断是否可以跨分组/分区区移动
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldCanMoveItemToOtherSection:)]) {
        BOOL canMove = [self.delegate collectionView:self shouldCanMoveItemToOtherSection:indexPath];
        NSInteger itemNum = [self numberOfItemsInSection:indexPath.section]; // 当前分组/分区的 item 数量
        //  不能跨分组/分区移动，&& 当前分组/分区只有一个item元素
        if (!canMove && (itemNum == 1)) { // 如果当前分组/分区只有一个item元素
            // 抖动动画
            [self shakeAnimationX:indexPath];
        }
        return canMove;
    }
    
    
    //返回YES，表示所有的item都可以移动
    return YES;
}

/// 抖动动画
- (void)shakeAnimationX:(NSIndexPath *)indexPath {
    // 抖动动画
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
    shakeAnimation.duration = 0.25;
    shakeAnimation.values = @[@(-20), @(20), @(-10), @(10), @(0)];
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:indexPath];
    [cell.layer addAnimation:shakeAnimation forKey:@"shake"];
}
 
#pragma mark - 移动结束后代理/长按手势结束后走下面的代理方法
/// UICollectionViewDataSource中实现项目移动后的数据更新，   在这里调用接口更新数据/保存数据到本地
/// 移动结束的时候会调用此datasource，想要拖拽完成之后数据正确必须实现此方法，使用新的路径更新数据源，如果不实现此方法，刚刚移动cell中的数据不会重新排列
/// sourceIndexPath：原始移动的indexpath
/// destinationIndexPath：移动到目标位置的indexpath
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    // 移动数据源中的对象
    
    // 判断是否可以跨分区/分区移动
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:shouldCanMoveItemToOtherSection:)]) {
        BOOL canMove = [self.delegate collectionView:self shouldCanMoveItemToOtherSection:sourceIndexPath];
        // 不能跨分组/分区移动  && 不在同一个分组/分区
        if (!canMove && sourceIndexPath.section != destinationIndexPath.section) {
            return;
        }
    }
    
    

    /***2 种排序方式，
     第一种只是交换2个cell位置，
     第二种是将前面的cell都往后移动一格，再将cell插入指定位置【只需更新数据源，不要使用[collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];方法】
     ***/
//    // 1.
//    [self.dataArray exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    
//    // 2. 只需更新数据源，不要使用[collectionView moveItemAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];方法
//    id objc = [self.dataArray objectAtIndex:sourceIndexPath.item];
//    //从资源数组中移除该数据
//    [self.dataArray removeObject:objc];
//    //将数据插入到资源数组中的目标位置上
//    [self.dataArray insertObject:objc atIndex:destinationIndexPath.item];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didMoveCellFromIndexPath:toIndexPath:)]) {
        [self.delegate collectionView:self didMoveCellFromIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    }
    
    // 如果使用的是自动布局，可能还需要更新任何与布局相关的代码
 
    // 调用接口，更新数据。/ 保存数据到本地
    NSLog(@"在这里调用接口更新数据/保存数据到本地。");
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
