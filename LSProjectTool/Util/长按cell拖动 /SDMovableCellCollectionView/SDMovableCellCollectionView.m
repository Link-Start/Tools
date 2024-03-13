//
//  SDMovableCellCollectionView.m
//  NPC
//
//  Created by liushuo on 2023/2/25.
//  Copyright © 2023 NPC.work. All rights reserved.
//

#import "SDMovableCellCollectionView.h"

@interface SDMovableCellCollectionView ()

@property (nonatomic, strong) UIImageView *snapshot;
@property (nonatomic, strong) CADisplayLink *edgeScrollLink;
@property (nonatomic, strong) UIImpactFeedbackGenerator *generator NS_AVAILABLE_IOS(10_0);
@property (nonatomic, strong) NSMutableArray <NSMutableArray *> *tempDataSource;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPressGesture;
@property (nonatomic, assign) CGFloat gestureMinimumPressDuration;
@property (nonatomic, assign) CGFloat currentScrollSpeedPerFrame;
@property (nonatomic, assign) CGFloat gesturePointOffsetX;
@property (nonatomic, assign) CGFloat gesturePointOffsetY;
@property (nonatomic, strong) NSMutableArray *tempSectionArray;

/// 长按的 cell的 indexPath
@property (nonatomic, strong) NSIndexPath *oldIndexPath;
/// 移动到的 indexPath
@property (nonatomic, strong) NSIndexPath *currentIndexPath;

@property (nonatomic, strong) NSIndexPath *startIndexPath;

@end

@implementation SDMovableCellCollectionView

@dynamic dataSource, delegate;

- (void)dealloc {
    NSLog(@"%s",__FUNCTION__);
    self.dataSource = nil;
    self.delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
//        self.rowHeight = 0;
//        self.estimatedRowHeight = 0;
//        self.estimatedSectionHeaderHeight = 0;
//        self.estimatedSectionFooterHeight = 0;
        self.generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
        [self initData];
        [self addGesture];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview == nil) {
        [self stopEdgeScroll];
    }
}

- (void)initData {
    _gestureMinimumPressDuration = 0.5f;
    _canEdgeScroll = YES;
    _edgeScrollTriggerRange = 150.f;
    _maxScrollSpeedPerFrame = 20;
    _canHintWhenCannotMove = YES;
    _canFeedback = NO;
}

#pragma mark Gesture
/// 添加手势
- (void)addGesture {
    _longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(processGesture:)];
    _longPressGesture.minimumPressDuration = _gestureMinimumPressDuration;
    [self addGestureRecognizer:_longPressGesture];
}

/// 长按手势事件
- (void)processGesture:(UILongPressGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: // 手势开始
        {
            [self gestureBegan:gesture];
        }
            break;
        case UIGestureRecognizerStateChanged:// 手势变化
        {
            if (!_canEdgeScroll) {
                [self gestureChanged:gesture];
            }
        }
            break;
        case UIGestureRecognizerStateEnded:// 手势结束
        case UIGestureRecognizerStateCancelled:// 手势取消
        {
            [self gestureEndedOrCancelled:gesture];
        }
            break;
        default:
            break;
    }
}

/// 手势开始
- (void)gestureBegan:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    NSIndexPath *selectedIndexPath = [self indexPathForItemAtPoint:point];
    
    if (!selectedIndexPath) {
        // 用户长按非cell区域，可以做其他处理
        return;
    }
    
    NSIndexPath *temSelectedIndexPath = [NSIndexPath indexPathForItem:selectedIndexPath.item inSection:selectedIndexPath.section];
    _startIndexPath = temSelectedIndexPath;
    self.oldIndexPath = temSelectedIndexPath;

    // 用户长按的cell
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:temSelectedIndexPath];
    cell.alpha = 1.0;

    // 判断是否可以移动cell，
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(collectionView:canMoveItemAtIndexPath:)]) {
        // ********** 如果cell不能移动
        if (![self.dataSource collectionView:self canMoveItemAtIndexPath:temSelectedIndexPath]) {
            //It is not allowed to move the cell, then shake it to prompt the user.
            // 当cell不允许被移动的时候，
            [self gestureBeganNotMoveCellHandle:cell indexPath:temSelectedIndexPath];
            return;
        }
    }
    // 判断是否可以移动cell，
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:canMoveCellAtIndexPath:)]) {
        // ********** 如果cell不能移动
        if (![self.dataSource collectionView:self canMoveItemAtIndexPath:temSelectedIndexPath]) {
            //It is not allowed to move the cell, then shake it to prompt the user.
            // 当cell不允许被移动的时候，
            [self gestureBeganNotMoveCellHandle:cell indexPath:temSelectedIndexPath];
            return;
        }
    }
    
//    // 设置是否可以分组/分区区移动
//    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:canMoveCellToOtherSection:)]) {
//        BOOL canMove = [self.delegate collectionView:self canMoveCellToOtherSection:temSelectedIndexPath];
//        NSInteger itemNum = [self numberOfItemsInSection:temSelectedIndexPath.section]; // 当前分组/分区的 item 数量
//        if (!canMove && (itemNum == 1)) { //  不能跨分组/分区移动，当前分组/分区只有一个item元素
//            // 当cell不允许被移动的时候，
//            [self gestureBeganNotMoveCellHandle:cell indexPath:temSelectedIndexPath];
//            return;
//        }
//    }
    
    // ********** cell可以移动
    
    // 长按拖拽cell将要开始移动
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:willMoveCellAtIndexPath:)]) {
        [self.delegate collectionView:self willMoveCellAtIndexPath:temSelectedIndexPath];
    }
    if (_canEdgeScroll) {//是否允许拖动到屏幕边缘，启用边缘滚动，默认为YES
        [self startEdgeScroll];
    }
    //Get a data source every time you move
    // 数据源约束: 多组数组嵌套且为可变数组
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(dataSourceArrayInCollectionView:)]) {
        _tempDataSource = [self.dataSource dataSourceArrayInCollectionView:self];
    }

    if (self.canFeedback) {
        [self.generator prepare];
        [self.generator impactOccurred];
    }
    
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(snapshotViewWithCell:)]) {
        UIView *snapView = [self.dataSource snapshotViewWithCell:cell];
        _snapshot = [self snapshotViewWithInputView:snapView];
    } else {
        _snapshot = [self snapshotViewWithInputView:cell];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customizeMovalbeCell:)]) {
        [self.delegate collectionView:self customizeMovalbeCell:_snapshot];
    } else {
        _snapshot.layer.shadowColor = [UIColor grayColor].CGColor;
        _snapshot.layer.masksToBounds = NO;
        _snapshot.layer.cornerRadius = 0;
        _snapshot.layer.shadowOffset = CGSizeMake(-5, 0);
        _snapshot.layer.shadowOpacity = 0.4;
        _snapshot.layer.shadowRadius = 5;
    }
    
//    _snapshot.frame = CGRectMake((cell.frame.size.width - _snapshot.frame.size.width)/2.0f, cell.frame.origin.y + (cell.frame.size.height - _snapshot.frame.size.height)/2.0, _snapshot.frame.size.width, _snapshot.frame.size.height);
    _snapshot.frame = cell.frame;
    [self addSubview:_snapshot];
    
    // 记录手势中心偏移
    self.gesturePointOffsetX = point.x - _snapshot.center.x;
    self.gesturePointOffsetY = point.y - _snapshot.center.y;

    cell.hidden = YES;
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:customizeStartMovingAnimation:fingerPoint:)]) {
        [self.delegate collectionView:self customizeStartMovingAnimation:_snapshot fingerPoint:point];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.snapshot.transform = CGAffineTransformScale(self.snapshot.transform, 1.1, 1.1);
        }];
    }
}

/// 不能移动 cell
- (void)gestureBeganNotMoveCellHandle:(UICollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    // 当cell不允许被移动的时候，
    if (self.canHintWhenCannotMove) {// 长按时提示
        CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.x"];
        shakeAnimation.duration = 0.25;
        shakeAnimation.values = @[@(-20), @(20), @(-10), @(10), @(0)];
        [cell.layer addAnimation:shakeAnimation forKey:@"shake"];
    }
    
    // 尝试长按拖拽不能移动的cell 这个代理方法可以加个toast或者其他处理 与设置`canHintWhenCannotMove`不冲突
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:tryMoveUnmovableCellAtIndexPath:)]) {
        [self.delegate collectionView:self tryMoveUnmovableCellAtIndexPath:indexPath];
    }
    cell.alpha = 0.7;
}

/// 手势变化
- (void)gestureChanged:(UILongPressGestureRecognizer *)gesture {
    CGPoint point = [gesture locationInView:gesture.view];
    point.x -= self.gesturePointOffsetX;
    point.y -= self.gesturePointOffsetY;
    point = CGPointMake([self limitSnapshotCenterX:point.x], [self limitSnapshotCenterY:point.y]);
    //point = CGPointMake(_snapshot.center.x, [self limitSnapshotCenterY:point.y]);
    //Let the screenshot follow the gesture
    _snapshot.center = point;
    
    NSIndexPath *currentIndexPath = [self indexPathForItemAtPoint:point];
    if (!currentIndexPath) {
        // 用户移动到 非cell区域，可以做其他处理
        return;
    }
    
    NSIndexPath *temCurrentIndexPath = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:currentIndexPath.section];

    // 设置是否可以跨分组/分区移动
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:canMoveCellToOtherSection:)]) {
        // ******* 如果cell不能移动到当前 indexPath
        BOOL canMove = [self.delegate collectionView:self canMoveCellToOtherSection:temCurrentIndexPath];
        if (!canMove && (temCurrentIndexPath.section != self.oldIndexPath.section)) {
            if (_canEdgeScroll) {
                [self stopEdgeScroll]; // 这里不能让它滚动 ，不然cell会莫名其妙的消失
            }
            return;
        }
    }
    //    selectedCell.hidden = YES;
    self.currentIndexPath = nil;
    self.currentIndexPath = temCurrentIndexPath;
    // ********** cell可以移动到当前位置
    
    // 如果长按的cell的indexPath，和当前移动到的indexPath 不相同 , 即cell确实移动到了新的 indexPath 位置
    if (temCurrentIndexPath && ![_startIndexPath isEqual:temCurrentIndexPath]) {
        //Exchange data source and cell，交换数据 和 cell
        [self updateDataSourceAndCellFromIndexPath:_startIndexPath toIndexPath:temCurrentIndexPath];
        if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:didMoveCellFromIndexPath:toIndexPath:)]) {
            [self.delegate collectionView:self didMoveCellFromIndexPath:_startIndexPath toIndexPath:temCurrentIndexPath];
        }
        _startIndexPath = temCurrentIndexPath;
    }
}

/// 手势结束/手势取消
- (void)gestureEndedOrCancelled:(UILongPressGestureRecognizer *)gesture {
    if (_canEdgeScroll) {
        [self stopEdgeScroll];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(collectionView:endMoveCellAtIndexPath:)]) {
        [self.delegate collectionView:self endMoveCellAtIndexPath:self.oldIndexPath];
    }
    
    UICollectionViewCell *cell = [self cellForItemAtIndexPath:self.oldIndexPath];
    if (!self.currentIndexPath) {
        cell = [self cellForItemAtIndexPath:self.oldIndexPath];
    } else {
        cell = [self cellForItemAtIndexPath:self.currentIndexPath];
    }
    
    if (!self.canHintWhenCannotMove) {
        //这里，如果不加判断，当某个分组只有一个数据不能移动时时,上一次选中的cell，会闪烁一下
        cell.alpha = 0.7;
    }

    [UIView animateWithDuration:0.3 animations:^{
        self.snapshot.transform = CGAffineTransformIdentity;
        self.snapshot.frame = cell.frame;
//        self.snapshot.frame = CGRectMake((cell.frame.size.width - self.snapshot.frame.size.width)/2.0f, cell.frame.origin.y + (cell.frame.size.height - self.snapshot.frame.size.height)/2.0, self.snapshot.frame.size.width, self.snapshot.frame.size.height);
    } completion:^(BOOL finished) {
        cell.hidden = NO;
        [self.snapshot removeFromSuperview];
        self.snapshot = nil;
    }];
    // 延时后更新整个数据源
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self reloadData];
    });
}

#pragma mark Private action
- (UIImageView *)snapshotViewWithInputView:(UIView *)inputView {
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.alpha = 0.85;
    return snapshot;
}

// 为方便业务拓展，数据交换需实现代理方法：didMoveCellFromIndexPath
- (void)updateDataSourceAndCellFromIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
//    if ([self numberOfSections] == 1) {
//        //only one section
//        [_tempDataSource[fromIndexPath.section] exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
//        [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//    } else {
//        //multiple sections
//        //先将cell的数据模型从之前的数组中移除，然后再插入新的数组
//        id fromData = _tempDataSource[fromIndexPath.section][fromIndexPath.row];
//        //id toData = _tempDataSource[toIndexPath.section][toIndexPath.row];
//        NSMutableArray *fromArray = _tempDataSource[fromIndexPath.section];
//        NSMutableArray *toArray = _tempDataSource[toIndexPath.section];
//        [fromArray removeObject:fromData];
//        [toArray insertObject:fromData atIndex:toIndexPath.row];
//
//        if (@available(iOS 11.0, *)) {
//            if (_currentScrollSpeedPerFrame > 10) {
//                [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//            } else {
//                // move的效果比delete+insert更丝滑
//                [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//            }
//        } else {
//            [self moveRowAtIndexPath:fromIndexPath toIndexPath:toIndexPath];
//        }
//    }
}

- (CGFloat)limitSnapshotCenterX:(CGFloat)targetX {
    CGFloat minValue = _snapshot.bounds.size.width/2.0 + self.contentOffset.x;
    CGFloat maxValue = self.contentOffset.x + self.bounds.size.width - _snapshot.bounds.size.width/2.0;
    return MIN(maxValue, MAX(minValue, targetX));
}

- (CGFloat)limitSnapshotCenterY:(CGFloat)targetY {
    CGFloat minValue = _snapshot.bounds.size.height/2.0 + self.contentOffset.y;
    CGFloat maxValue = self.contentOffset.y + self.bounds.size.height - _snapshot.bounds.size.height/2.0;
    return MIN(maxValue, MAX(minValue, targetY));
}

- (CGFloat)limitContentOffsetY:(CGFloat)targetOffsetY {
    CGFloat minContentOffsetY;
    if (@available(iOS 11.0, *)) {
        minContentOffsetY = -self.adjustedContentInset.top;
    } else {
        minContentOffsetY = -self.contentInset.top;
    }

    CGFloat maxContentOffsetY = minContentOffsetY;
    CGFloat contentSizeHeight = self.contentSize.height;
    if (@available(iOS 11.0, *)) {
        contentSizeHeight += self.adjustedContentInset.top + self.adjustedContentInset.bottom;
    } else {
        contentSizeHeight += self.contentInset.top + self.contentInset.bottom;
    }
    if (contentSizeHeight > self.bounds.size.height) {
        maxContentOffsetY += contentSizeHeight - self.bounds.size.height;
    }
    return MIN(maxContentOffsetY, MAX(minContentOffsetY, targetOffsetY));
}

#pragma mark EdgeScroll
- (void)startEdgeScroll {
    _edgeScrollLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(processEdgeScroll)];
    [_edgeScrollLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)processEdgeScroll {
    CGFloat minOffsetY = self.contentOffset.y + _edgeScrollTriggerRange;
    CGFloat maxOffsetY = self.contentOffset.y + self.bounds.size.height - _edgeScrollTriggerRange;
    CGPoint touchPoint = _snapshot.center;

    if (touchPoint.y < minOffsetY) {
        //Cell is moving up
        CGFloat moveDistance = (minOffsetY - touchPoint.y)/_edgeScrollTriggerRange*_maxScrollSpeedPerFrame;
        _currentScrollSpeedPerFrame = moveDistance;
        self.contentOffset = CGPointMake(self.contentOffset.x, [self limitContentOffsetY:self.contentOffset.y - moveDistance]);
    } else if (touchPoint.y > maxOffsetY) {
        //Cell is moving down
        CGFloat moveDistance = (touchPoint.y - maxOffsetY)/_edgeScrollTriggerRange*_maxScrollSpeedPerFrame;
        _currentScrollSpeedPerFrame = moveDistance;
        self.contentOffset = CGPointMake(self.contentOffset.x, [self limitContentOffsetY:self.contentOffset.y + moveDistance]);
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];

    [self gestureChanged:_longPressGesture];
}

- (void)stopEdgeScroll {
    _currentScrollSpeedPerFrame = 0;
    if (_edgeScrollLink) {
        [_edgeScrollLink invalidate];
        _edgeScrollLink = nil;
    }
}

@end
