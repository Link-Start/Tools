////
////  FSTextView.h
////  FSTextView
////
////  Created by Steven on 2016/9/27.
////  Copyright © 2016年 Steven. All rights reserved.
//// https://github.com/lifution/FSTextView
////
//// https://github.com/iThinkerYZ/YZInputView
//
//#import <UIKit/UIKit.h>
//
/////NS_ENUM，定义状态等普通枚举
//typedef NS_ENUM(NSUInteger, LSTextViewInputType) {
//    ///控件根据文本内容自动调整高度
//    AutomaticAdjustmentHeight  = 0,
//    ///限制文本长度
//    LimitedTextLength
//};
//
//#pragma mark - 限制文本长度
//@class FSTextView;
//
//typedef void(^FSTextViewHandler)(FSTextView *textView);
//
//IB_DESIGNABLE // 动态刷新
//@interface FSTextView : UITextView
//
///*! @brief 便利构造器创建FSTextView实例.
// */
//+ (instancetype)textView;
//
///*! @brief 设定文本改变Block回调. (切记弱化引用, 以免造成内存泄露.)
// */
//- (void)addTextDidChangeHandler:(FSTextViewHandler)eventHandler;
//
///*! @brief 设定达到最大长度Block回调. (切记弱化引用, 以免造成内存泄露.)
// */
//- (void)addTextLengthDidMaxHandler:(FSTextViewHandler)maxHandler;
//
//
//@property (nonatomic, assign) IBInspectable NSUInteger maxLength; ///< 最大限制文本长度, 默认为无穷大(即不限制).
//
//@property (nonatomic, assign) IBInspectable CGFloat    cornerRadius; ///< 圆角半径.
//@property (nonatomic, assign) IBInspectable CGFloat    borderWidth; ///< 边框宽度.
//@property (nonatomic, strong) IBInspectable UIColor   *borderColor; ///< 边框颜色.
//
//@property (nonatomic, copy)   IBInspectable NSString *placeholder; ///< placeholder, 会自适应TextView宽高以及横竖屏切换, 字体默认和TextView一致.
//@property (nonatomic, strong) IBInspectable UIColor  *placeholderColor; ///< placeholder文本颜色, 默认为#C7C7CD.
//@property (nonatomic, strong) IBInspectable UIFont   *placeholderFont; ///< placeholder文本字体, 默认为UITextView的默认字体.
//
/////设置类型 限制文本长度 / 控件根据文本内容自动调整高度 默认：限制文本长度
//@property (nonatomic, assign) LSTextViewInputType textViewType;
//
//
//
//#pragma mark - 控件高度根据文本内容自动调整
///**
// *  textView最大行数
// */
//@property (nonatomic, assign) NSUInteger maxNumberOfLines;
//
///**
// *  必须在这里面改变控件textView的高度 否则控件高度不会变
// *  文字高度改变block → 文字高度改变会自动调用
// *  block参数(text) → 文字内容
// *  block参数(textHeight) → 文字高度
// */
//@property (nonatomic, strong) void(^yz_textHeightChangeBlock)(NSString *text,CGFloat textHeight);
//
//
/////必须在这里面改变控件textView的高度 否则控件高度不会变
//- (void)ls_textViewHeightChangeBlock:(void (^)(NSString *text,CGFloat textHeight))textViewHeightChangeBlock;
//
//@end
