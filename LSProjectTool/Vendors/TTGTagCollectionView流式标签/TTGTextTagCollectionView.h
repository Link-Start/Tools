//
// Created by zorro on 15/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TTGTagCollectionView.h"

/// TTGTextTagConfig

@interface TTGTextTagConfig : NSObject;
/// 文本字体 Text font
@property (strong, nonatomic) UIFont *textFont;

/// 文本颜色 Text color
@property (strong, nonatomic) UIColor *textColor;
/// 选中的文本颜色
@property (strong, nonatomic) UIColor *selectedTextColor;

/// 背景色 Background color
@property (strong, nonatomic) UIColor *backgroundColor;
/// 选中的背景色
@property (strong, nonatomic) UIColor *selectedBackgroundColor;


/// 渐变背景色 Gradient background color
@property (assign, nonatomic) BOOL enableGradientBackground;
/// 渐变背景起始颜色
@property (strong, nonatomic) UIColor *gradientBackgroundStartColor;
/// 渐变背景结束颜色
@property (strong, nonatomic) UIColor *gradientBackgroundEndColor;
/// 选中的渐变背景开始颜色
@property (strong, nonatomic) UIColor *selectedGradientBackgroundStartColor;
/// 选中的渐变背景结束颜色
@property (strong, nonatomic) UIColor *selectedGradientBackgroundEndColor;
/// 渐变背景起点
@property (assign, nonatomic) CGPoint gradientBackgroundStartPoint;
/// 渐变背景终点
@property (assign, nonatomic) CGPoint gradientBackgroundEndPoint;

// Corner radius
/// 圆角半径
@property (assign, nonatomic) CGFloat cornerRadius;
/// 选中的圆角半径
@property (assign, nonatomic) CGFloat selectedCornerRadius;
/// 右上角
@property (assign, nonatomic) Boolean cornerTopRight;
/// 左上角
@property (assign, nonatomic) Boolean cornerTopLeft;
/// 右下角
@property (assign, nonatomic) Boolean cornerBottomRight;
/// 左下角
@property (assign, nonatomic) Boolean cornerBottomLeft;

// Border
/// 边框宽度
@property (assign, nonatomic) CGFloat borderWidth;
/// 选中的边框宽度
@property (assign, nonatomic) CGFloat selectedBorderWidth;
/// 边框颜色
@property (strong, nonatomic) UIColor *borderColor;
/// 选中的 边框颜色
@property (strong, nonatomic) UIColor *selectedBorderColor;

// Shadow.
/// 阴影颜色。 默认是[UIColor black]
@property (nonatomic, copy) UIColor *shadowColor;    // Default is [UIColor black]
/// 阴影偏移。 默认是(2，2)
@property (nonatomic, assign) CGSize shadowOffset;   // Default is (2, 2)
/// 阴影半径。默认是2f
@property (nonatomic, assign) CGFloat shadowRadius;  // Default is 2f
/// 阴影不透明度。默认是0.3f
@property (nonatomic, assign) CGFloat shadowOpacity; // Default is 0.3f

/// 宽度和高度上的额外空间，将扩展每个标签的大小。 Extra space in width and height, will expand each tag's size
@property (assign, nonatomic) CGSize extraSpace;

/// 文本标记的最大宽度。0及以下表示没有最大宽度。 Max width for a text tag. 0 and below means no max width.
@property (assign, nonatomic) CGFloat maxWidth;
/// 文本标记的最小宽度。0及以下表示没有最小宽度。 Min width for a text tag. 0 and below means no min width.
@property (assign, nonatomic) CGFloat minWidth;

/// 精确宽度。0及以下设置无效果。 Exact width. 0 and below means no work
@property (nonatomic, assign) CGFloat exactWidth;
/// 准确的高度。0及以下设置无效果。 Exact height. 0 and below means no work
@property (nonatomic, assign) CGFloat exactHeight;

/// 额外数据。您可以使用它将您想要的任何对象绑定到每个标记。 Extra data. You can use this to bind any object you want to each tag.
@property (nonatomic, strong) NSObject *extraData;

@end

/// TTGTextTagCollectionView

@class TTGTextTagCollectionView;

@protocol TTGTextTagCollectionViewDelegate <NSObject>
@optional

- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    canTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
              currentSelected:(BOOL)currentSelected
                    tagConfig:(TTGTextTagConfig *)config;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected
                    tagConfig:(TTGTextTagConfig *)config;

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
            updateContentSize:(CGSize)contentSize;

/// 已废弃 Deprecated
- (BOOL)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    canTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
              currentSelected:(BOOL)currentSelected __attribute__((deprecated("Use the new method")));
/// /// 已废弃
- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView
                    didTapTag:(NSString *)tagText
                      atIndex:(NSUInteger)index
                     selected:(BOOL)selected __attribute__((deprecated("Use the new method")));
@end

@interface TTGTextTagCollectionView : UIView
/// 代理 Delegate
@property (weak, nonatomic) id <TTGTextTagCollectionViewDelegate> delegate;

/// 内部滚动视图 Inside scrollView
@property (nonatomic, strong, readonly) UIScrollView *scrollView;

/// 定义 tag 是否可以被选择 Define if the tag can be selected.
@property (assign, nonatomic) BOOL enableTagSelection;

/// 默认 tag 配置 Default tag config
@property (nonatomic, strong) TTGTextTagConfig *defaultConfig;

/// tags滚动方向，默认为垂直。 Tags scroll direction, default is vertical.
@property (nonatomic, assign) TTGTagCollectionScrollDirection scrollDirection;

///tags 布局对齐方式，默认是靠左。 Tags layout alignment, default is left.
@property (nonatomic, assign) TTGTagCollectionAlignment alignment;

/// 行数。0表示没有限制，默认值为0表示垂直，1表示水平。 Number of lines. 0 means no limit, default is 0 for vertical and 1 for horizontal.
@property (nonatomic, assign) NSUInteger numberOfLines;
/// 忽略numberOfLines值的实际行数。 The real number of lines ignoring the numberOfLines value
@property (nonatomic, assign, readonly) NSUInteger actualNumberOfLines;

/// tag选择限制，默认为0，表示没有限制。 Tag selection limit, default is 0, means no limit
@property (nonatomic, assign) NSUInteger selectionLimit;

/// tags之间的水平间距，默认值是4。 Horizontal and vertical space between tags, default is 4.
@property (assign, nonatomic) CGFloat horizontalSpacing;
/// tags之间的垂直间距，默认值是4。
@property (assign, nonatomic) CGFloat verticalSpacing;

// Content inset, like padding, default is UIEdgeInsetsMake(2, 2, 2, 2).
@property (nonatomic, assign) UIEdgeInsets contentInset;

/// 真正的tags内容大小，只读。 The true tags content size, readonly
@property (nonatomic, assign, readonly) CGSize contentSize;

/// 手动内容高度 Manual content height
/// 默认值=NO，设置将更新内容 Default = NO, set will update content
@property (nonatomic, assign) BOOL manualCalculateHeight;
/// 首选最大布局宽度。默认值=0，设置将更新内容 Default = 0, set will update content
@property (nonatomic, assign) CGFloat preferredMaxLayoutWidth;

/// 水平滚动指示器， Scroll indicator
@property (nonatomic, assign) BOOL showsHorizontalScrollIndicator;
/// 垂直滚动指示器
@property (nonatomic, assign) BOOL showsVerticalScrollIndicator;

/// 点击空白区域回调 Tap blank area callback
@property (nonatomic, copy) void (^onTapBlankArea)(CGPoint location);
/// 点击所有区域回调 Tap all area callback
@property (nonatomic, copy) void (^onTapAllArea)(CGPoint location);

/// 重新加载 Reload
- (void)reload;

/// 添加一个默认配置的tag。 Add tag with default config
- (void)addTag:(NSString *)tag;
/// 添加一组默认配置的tags
- (void)addTags:(NSArray <NSString *> *)tags;

/// 添加一个自定义配置的tag。 Add tag with custom config
- (void)addTag:(NSString *)tag withConfig:(TTGTextTagConfig *)config;
/// 添加一组 自定义配置的tags
- (void)addTags:(NSArray <NSString *> *)tags withConfig:(TTGTextTagConfig *)config;

/// 插入一个默认配置的tag。 Insert tag with default config
- (void)insertTag:(NSString *)tag atIndex:(NSUInteger)index;
/// 插入一组默认配置的tags。
- (void)insertTags:(NSArray <NSString *> *)tags atIndex:(NSUInteger)index;

/// 插入一个自定义配置的 tag。 Insert tag with custom config
- (void)insertTag:(NSString *)tag atIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config;
/// 插入一组自定义配置的tags
- (void)insertTags:(NSArray <NSString *> *)tags atIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config;

/// 删除 tag。 Remove tag
- (void)removeTag:(NSString *)tag;
/// 删除某个下标的 tag。
- (void)removeTagAtIndex:(NSUInteger)index;
/// 删除所有的 tags。
- (void)removeAllTags;

/// 更新tag的选定状态。 Update tag selected state
- (void)setTagAtIndex:(NSUInteger)index selected:(BOOL)selected;

/// 更新某一个 tag 的配置。 Update tag config
- (void)setTagAtIndex:(NSUInteger)index withConfig:(TTGTextTagConfig *)config;
/// 更新某个范围的 tag 的配置。
- (void)setTagsInRange:(NSRange)range withConfig:(TTGTextTagConfig *)config;

/// 根据下标获取tag。 Get tag
- (NSString *)getTagAtIndex:(NSUInteger)index;
/// 根据范围获取 tags。
- (NSArray <NSString *> *)getTagsInRange:(NSRange)range;

/// 获取某个下标对应的配置。 Get tag config
- (TTGTextTagConfig *)getConfigAtIndex:(NSUInteger)index;
/// 获取某个范围内的配置。
- (NSArray <TTGTextTagConfig *> *)getConfigsInRange:(NSRange)range;

/// 获取所有的tags。 Get all
- (NSArray <NSString *> *)allTags;

- (NSArray <NSString *> *)allSelectedTags;

- (NSArray <NSString *> *)allNotSelectedTags;

/**
 * Returns the index of the tag located at the specified point.
 * If item at point is not found, returns NSNotFound.
 */
- (NSInteger)indexOfTagAt:(CGPoint)point;

@end
