//
//  LSTextView.h
//  LSProjectTool
//
//  Created by Xcode on 16/11/23.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import <UIKit/UIKit.h>


/// text的类型
typedef NS_ENUM(NSInteger, LSTextViewInputType) {
    ///控件根据文本内容自动调整高度
    LSTextViewInputTypeAutomaticAdjustmentHeight = 0,
    ///限制文本长度
    LSTextViewInputTypeLimitedTextLength
};

#pragma mark - 限制文本长度
@class LSTextView;

typedef void (^LSTextViewHandler)(LSTextView *textView);


IB_DESIGNABLE // 动态刷新
@interface LSTextView : UITextView

///设置文本最大长度
@property (nonatomic, assign) IBInspectable NSInteger maxLength;
///圆角半径
@property (nonatomic, assign) IBInspectable CGFloat cornerRadius;
///边框宽度
@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
///边框颜色
@property (nonatomic, strong) IBInspectable UIColor *borderColor;
///placeholder
@property (nonatomic, copy) IBInspectable NSString *placeholder;
///placeholder 颜色
@property (nonatomic, strong) IBInspectable UIColor *placeholderColor;
///placeholder 字体
@property (nonatomic, strong) IBInspectable UIFont *placeholderFont;
///设置类型 限制文本长度/控件根据内容自动调整高度 默认：限制文本长度
@property (nonatomic, assign) LSTextViewInputType textViewType;

/// 便利构造器 创建 LSTextView 实例
+ (instancetype)textView;

#pragma mark - 控件根据内容自动调整高度
/// textView 最大行数  默认 1 行
@property (nonatomic, assign) NSInteger maxNumberOfLines;
///必须在这里改变控件textView的高度，否则控件的高度不会变
- (void)textViewHeightChangeBlock:(void(^)(NSString *text, CGFloat textHeight))textViewHeightChangeBlock;

#pragma mark - 限制文本长度
///文本改变 的block回调
- (void)textViewTextDidChangedHander:(void(^)(LSTextView *textView))textViewChangeHandler;


#pragma mark - 链式编程测试
+ (instancetype)ls_textView:(void (^)(LSTextView *textView))initBlock;
- (LSTextView *)ls_and;
- (LSTextView *)ls_width;
///设置文本最大长度
- (LSTextView *(^)(NSInteger maxLength))ls_maxLength;
///圆角半径
- (LSTextView *(^)(CGFloat cornerRadius))ls_cornerRadius;
///边框宽度
- (LSTextView *(^)(CGFloat borderWidth))ls_borderWidth;
///边框颜色
- (LSTextView *(^)(UIColor *borderColor))ls_borderColor;
///placeholder
- (LSTextView *(^)(NSString *placeholder))ls_placeholder;
///placeholder 颜色
- (LSTextView *(^)(UIColor *placeholderColor))ls_placeholderColor;
///placeholder 字体
- (LSTextView *(^)(UIFont *placeholderFont))ls_placeholderFont;
///设置类型 限制文本长度/控件根据内容自动调整高度 默认：限制文本长度
- (LSTextView *(^)(LSTextViewInputType textViewType))ls_textViewType;
///设置最大行数
- (LSTextView *(^)(NSInteger maxNumberOfLines))ls_maxNumberOfLines;

@end
