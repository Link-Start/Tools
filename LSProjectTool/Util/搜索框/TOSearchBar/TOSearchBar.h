//
//  TOSearchBar.h
//
//  Copyright 2015-2016 Timothy Oliver. All rights reserved.
//
//
// UISearchBar的基本重新实现，主题更简单，动画更好。
// https://github.com/TimOliver/TOSearchBar

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


/// searchBar 样式
typedef NS_ENUM(NSInteger, TOSearchBarStyle) {
    TOSearchBarStyleLight = 0,
    TOSearchBarStyleDark = 1
};

/// 对齐类型
typedef NS_ENUM(NSUInteger, TOSearchBarAlignment) {
    /// 靠左
    TOSearchBarAlignmentLeft,
    /// 文字居中
    TOSearchBarAlignmentTextCenter,
    /// icon和文字居中
    TOSearchBarAlignmentIconAndTextCenter,
    /// 靠右
    TOSearchBarAlignmentRight,
};

@class TOSearchBar;

@protocol TOSearchBarDelegate <NSObject>

@optional

/// 在文本字段获得焦点之前调用，并且可以选择拒绝这样做。应该开始编辑
- (BOOL)searchBarShouldBeginEditing:(TOSearchBar *)searchBar;

/// 在文本字段获得焦点后立即调用。                                     已经开始编辑
- (void)searchBarDidBeginEditing:(TOSearchBar *)searchBar;

/// 在文本字段失去焦点之前调用，并且可以选择拒绝这样做。应该结束编辑
- (BOOL)searchBarShouldEndEditing:(TOSearchBar *)searchBar;

/// 在文本字段失去焦点后立即调用。                                     已经结束编辑
- (void)searchBarDidEndEditing:(TOSearchBar *)searchBar;

/// 联想结束
- (void)searchBar:(TOSearchBar *)searchBar textAssociateEnd:(nullable NSString *)searchText;


/// 在每次更改文本字段中的文本后立即调用。                         文本已经改变
- (void)searchBar:(TOSearchBar *)searchBar textDidChange:(nullable NSString *)searchText;

/// 在文本编辑期间调用，可用于选择性地约束字段可以接受的字符类型。     文本编辑中
- (BOOL)searchBar:(TOSearchBar *)searchBar shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

/// 当点击“清除”按钮以确认可以继续时调用。                                               点击清除按钮
- (void)searchBarClearButtonTapped:(TOSearchBar *)searchBar;

/// 在用户点击“搜索”按钮后调用。可用于设置该事件的操作。                     点击搜索按钮
- (void)searchBarSearchButtonTapped:(TOSearchBar *)searchBar;

@end

IB_DESIGNABLE
@interface TOSearchBar : UIControl


/// 此视图的颜色样式。设置此项将为每个子视图设置一系列默认颜色值。
/// 如果需要，可以进一步对各个视图进行自定义配置。
@property (nonatomic, assign) IBInspectable TOSearchBarStyle style;

/// 对齐方式
@property (nonatomic, assign) IBInspectable TOSearchBarAlignment alignment;
/// searchBar的搜索框的高度是否等于 自身高度
@property (nonatomic ,assign) BOOL isSelfHeight;

/// 用于响应事件的委托对象，代理
@property (nullable, nonatomic, weak) id<TOSearchBarDelegate> delegate;

/// 用户输入的搜索文本
@property (nullable, nonatomic, copy) IBInspectable NSString *text;

/// 占位符文本的内容。默认为“搜索”
@property (null_resettable, nonatomic, copy) IBInspectable NSString *placeholderText;

/// 搜索栏每侧插入多少点，
@property (nonatomic, assign) IBInspectable CGFloat horizontalInset;

/// textField 当前是否显示键盘，是否正在编辑中
@property (nonatomic, assign) BOOL editing;

/// textField 是否包含任何文本，是否输入的有内容
@property (nonatomic, readonly) BOOL hasSearchText;

/// 编辑时显示“取消”按钮
@property (nonatomic, assign) IBInspectable BOOL showsCancelButton;

/// 占位符内容的色调颜色（图标和文本）
@property (nullable, nonatomic, strong) IBInspectable UIColor *placeholderTintColor UI_APPEARANCE_SELECTOR;

/// 圆形背景矩形的色调颜色
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *barBackgroundTintColor UI_APPEARANCE_SELECTOR;

/// 用户点击 textField 时背景的色调颜色
@property (nullable, nonatomic, strong) IBInspectable UIColor *selectedBarBackgroundTintColor UI_APPEARANCE_SELECTOR;

/// textField 当前或具有内容时背景的色调颜色
@property (nullable, nonatomic, strong) IBInspectable UIColor *highlightedBarBackgroundTintColor UI_APPEARANCE_SELECTOR;

/// 用户将输入搜索文本的主 textField                                 搜索框 textField
@property (nonatomic, readonly) UITextField *searchTextField;

/// textField 文本 左侧的辅助图标视图
@property (nullable, nonatomic, readonly) UIImageView *iconView;
/// 文本字段文本左侧的辅助图标视图
@property (nonatomic, strong) UIImage *leftImage;

/// 搜索框 为空时显示的初始“搜索”文本标签                    占位文本label
@property (nonatomic, strong, readonly) UILabel *placeholderLabel;

/// 如果指定，可以取消文本外输入的“取消”按钮               取消按钮
@property (nullable, nonatomic, readonly) UIButton *cancelButton;

/** The 'clear' button that will clear any text in the text field */
/// 清除文本字段中任何文本的“清除”按钮                          清除按钮
@property (nonatomic, strong, readonly) UIButton *clearButton;


/// 创建此类的新实例，指定框架和样式。
/// @param frame 此视图的整个框架（理想高度为44点）
/// @param style 视图的颜色样式（浅色或深色）
- (instancetype)initWithFrame:(CGRect)frame style:(TOSearchBarStyle)style;


/// 创建此类的新实例，指定样式
/// @param style 视图的颜色样式（浅色或深色）
- (instancetype)initWithStyle:(TOSearchBarStyle)style;

@end

NS_ASSUME_NONNULL_END
