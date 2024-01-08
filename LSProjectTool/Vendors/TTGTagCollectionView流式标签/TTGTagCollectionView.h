//
//  TTGTagCollectionView.h
//  Pods
//
//  Created by zorro on 15/12/26.
//
//  流式标签  https://github.com/zekunyan/TTGTagCollectionView


#import <UIKit/UIKit.h>

@class TTGTagCollectionView;

/**
 * Tags scroll direction
 */
typedef NS_ENUM(NSInteger, TTGTagCollectionScrollDirection) {
    /// 垂直
    TTGTagCollectionScrollDirectionVertical = 0, // Default
    /// 水平
    TTGTagCollectionScrollDirectionHorizontal = 1
};

/**
 * Tags alignment
 */
typedef NS_ENUM(NSInteger, TTGTagCollectionAlignment) {
    /// 左对齐
    TTGTagCollectionAlignmentLeft = 0,                           // Default
    /// 中间对齐
    TTGTagCollectionAlignmentCenter,                             // Center
    /// 右对齐
    TTGTagCollectionAlignmentRight,                              // Right
    /// 扩展水平间距 填充
    TTGTagCollectionAlignmentFillByExpandingSpace,               // Expand horizontal spacing and fill
    /// 扩展宽度 填充
    TTGTagCollectionAlignmentFillByExpandingWidth,               // Expand width and fill
    /// 展开宽度填充，最后一行除外
    TTGTagCollectionAlignmentFillByExpandingWidthExceptLastLine  // Expand width and fill, except last line
};

/**
 * Tags delegate
 */
@protocol TTGTagCollectionViewDelegate <NSObject>
/// 必须
@required
/// 用于标记索引的大小
- (CGSize)tagCollectionView:(TTGTagCollectionView *)tagCollectionView sizeForTagAtIndex:(NSUInteger)index;

/// 可选的
@optional
/// 应该选择标记
- (BOOL)tagCollectionView:(TTGTagCollectionView *)tagCollectionView shouldSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;
/// 已经选择标记
- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView didSelectTag:(UIView *)tagView atIndex:(NSUInteger)index;
/// 更新内容大小
- (void)tagCollectionView:(TTGTagCollectionView *)tagCollectionView updateContentSize:(CGSize)contentSize;
@end

/**
 * Tags dataSource
 */
@protocol TTGTagCollectionViewDataSource <NSObject>
@required
- (NSUInteger)numberOfTagsInTagCollectionView:(TTGTagCollectionView *)tagCollectionView;

- (UIView *)tagCollectionView:(TTGTagCollectionView *)tagCollectionView tagViewForIndex:(NSUInteger)index;
@end

@interface TTGTagCollectionView : UIView
@property (nonatomic, weak) id <TTGTagCollectionViewDataSource> dataSource;
@property (nonatomic, weak) id <TTGTagCollectionViewDelegate> delegate;

/// 内部滚动视图 Inside scrollView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/// 标签滚动方向，默认为垂直方向。 Tags scroll direction, default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

/// 标签布局对齐方式，默认为左侧。 Tags layout alignment, default is left.
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

/// 行数。0表示没有限制，默认值为0表示垂直，1表示水平。
/// Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;
/// 忽略NumberOfLines值的实际行数。 The real number of lines ignoring the numberOfLines value
@property (nonatomic, assign, readonly) NSUInteger actualNumberOfLines;

/// 标记之间的水平间距，默认为4 Horizontal and vertical space between tags, default is 4.
@property (nonatomic, assign) CGFloat horizontalSpacing;
/// 标记之间的垂直间距，默认为4
@property (nonatomic, assign) CGFloat verticalSpacing;

// Content inset, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// 真正的标签内容大小，只读。 The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;

/// 手动内容高度 Manual content height
/// 默认值=NO，设置将更新内容 Default = NO, set will update content
@property (nonatomic, assign) BOOL manualCalculateHeight;
/// 首选最大布局宽度。默认值为0，设置将更新内容。 Default = 0, set will update content
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

/// 滚动指示器 Scroll indicator
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
/// 滚动指示器 Scroll indicator
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/// 点击空白区域回调 Tap blank area callback
@property (nonatomic, copy) void (^onTapBlankArea)(CGPoint location);
/// 点击所有区域回调 Tap all area callback
@property (nonatomic, copy) void (^onTapAllArea)(CGPoint location);


/// 重新加载所有标记单元格 Reload all tag cells
- (void)reload;

/**
 * Returns the index of the tag located at the specified point.
 * If item at point is not found, returns NSNotFound.
 */
/// 返回位于指定点的标记的索引。
/// 若未找到点上的项，则返回NSNotFound。
- (NSInteger)indexOfTagAt:(CGPoint)point;

@end
