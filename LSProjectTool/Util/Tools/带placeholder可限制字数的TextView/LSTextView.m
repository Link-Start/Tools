//
//  LSTextView.m
//  LSProjectTool
//
//  Created by Xcode on 16/11/23.
//  Copyright © 2016年 Link-Start. All rights reserved.
//

#import "LSTextView.h"

#pragma makr - 限制文本长度
CGFloat const kLSTextViewPlaceholderVerticalMargin  = 8.0; ///< placeholder垂直方向边距
CGFloat const kLSTextViewPlaceholderHorizontalMargin = 6.0; ///< placeholder水平方向边距

@interface LSTextView ()

#pragma mark - 限制文本长度
///< 文本改变Block
@property (nonatomic, copy) LSTextViewHandler changeHandler;
///placeholder label
@property (nonatomic, strong) UILabel *placeholderLabel;

#pragma mark - 根据文本内容调整控件高度
///文本高度
@property (nonatomic, assign) NSInteger textHeight;
///文本最大高度
@property (nonatomic, assign) NSInteger maxTextHeight;

/**
 *  必须在这里面改变控件textView的高度 否则控件高度不会变
 *  文字高度改变block → 文字高度改变会自动调用
 *  block参数(text) → 文字内容
 *  block参数(textHeight) → 文字高度
 */
@property (nonatomic, strong) void(^ls_textHeightChangeBlock)(NSString *text, CGFloat textHeight);

@end

@implementation LSTextView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    if ([[[UIDevice currentDevice] systemName] floatValue] >= 10.0) {
        [self layoutIfNeeded];
    }
    [self initialize];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

/// 便利构造器 创建 LSTextView 实例
+ (instancetype)textView {
    return [[self alloc] init];
}

- (void)initialize {
    
    //监听文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChanged) name:UITextViewTextDidChangeNotification object:nil];
    
    //基本配置
    _maxLength = NSUIntegerMax;//文本最大长度
    //占位字符串颜色
    _placeholderColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.780 alpha:1.000];
    
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:16.f];
    
    //placeHolderLabel
    _placeholderLabel = [[UILabel alloc] init];
    _placeholderLabel.font = self.font;
    _placeholderLabel.textColor = _placeholderColor;
    _placeholderLabel.numberOfLines = 0;
    _placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_placeholderLabel];
    
    
    //约束
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholderLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:kLSTextViewPlaceholderVerticalMargin]]; //上
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholderLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:kLSTextViewPlaceholderHorizontalMargin]];//左
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholderLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:1.0 constant:-kLSTextViewPlaceholderHorizontalMargin * 2]];//宽
    [self addConstraint:[NSLayoutConstraint constraintWithItem:_placeholderLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:1.0 constant:-kLSTextViewPlaceholderVerticalMargin * 2]];//高
    
    
#pragma mark - 根据文本内容调整控件高度
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //限制文本长度
    _textViewType = LSTextViewInputTypeLimitedTextLength;
}

#pragma mark - 通知 监听方法
- (void)textDidChanged {
    //根据字符数量 显示/隐藏 placeholderLabel
    _placeholderLabel.hidden = [@(self.text.length) boolValue];
    
    switch (_textViewType) {
        case LSTextViewInputTypeLimitedTextLength://限制文本长度
        {
            //禁止第一个字符输入空格或者换换符
            if (self.text.length == 1) {
                if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
                    self.text = @"";
                }
            }
            
            //只有当 maxLength字段的值不为无穷大的整型时才进行限制字符数的计算
            if (_maxLength != NSUIntegerMax) {
                NSString *toBeString = self.text;
                UITextRange *selectedRange = [self markedTextRange];
                UITextPosition *position = [self positionFromPosition:selectedRange.start offset:0];
                if (!position) {
                    if (toBeString.length > _maxLength) {
                        self.text = [toBeString substringToIndex:_maxLength];//截取最大限制字符串
                        _changeHandler ? _changeHandler(self) : NULL;//回调 达到最大限制的block
                    }
                }
            } else {
                //改变的文本
                _changeHandler ? _changeHandler(self) : NULL;
            }
        }
            break;
        case LSTextViewInputTypeAutomaticAdjustmentHeight: //根据文本高度自动调整控件高度
        {
            //ceilf 向上取整
            //sizeThatFits:会计算出最优的 size 但是不会改变 自己的 size
            NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
            
            // 高度不一样，就改变了高度
            if (_textHeight != height) {
                
                // 文本高度 < 设置的最大高度   不能滚动
                // 文本高度 > 设置的最大高度   可以滚动
                self.scrollEnabled = height > _maxTextHeight && _maxTextHeight > 0;
                
                _textHeight = height;
                
                if (_ls_textHeightChangeBlock && self.scrollEnabled == NO) {
                    _ls_textHeightChangeBlock(self.text, height);//返回，字符串和文本高度
                    
                    [self.superview layoutIfNeeded];
                }
            }
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - 根据文本高度自动调整控件高度 返回文本高度
///必须在这里改变控件textView的高度，否则控件的高度不会变
- (void)textViewHeightChangeBlock:(void (^)(NSString *, CGFloat))textViewHeightChangeBlock {
    _ls_textHeightChangeBlock = textViewHeightChangeBlock;
}

#pragma mark - 限制文本长度
///文本改变 的block回调
- (void)textViewTextDidChangedHander:(void(^)(LSTextView *textView))textViewChangeHandler {
    _changeHandler = textViewChangeHandler;
}

#pragma mark - setter方法
- (void)setLs_textHeightChangeBlock:(void (^)(NSString *, CGFloat))ls_textHeightChangeBlock {
    _ls_textHeightChangeBlock = ls_textHeightChangeBlock;
    
    [self textDidChanged];
}

//设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}

//设置边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    if (!borderColor) {
        return;
    }
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}

//设置边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

//设置占位字符串
- (void)setPlaceholder:(NSString *)placeholder {
    if (!placeholder) {
        return;
    }
    _placeholder = placeholder;
    if (_placeholder.length > 0) {
        _placeholderLabel.text = _placeholder;
    }
}

//设置占位字符串字体
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (!placeholderFont) {
        return;
    }
    _placeholderFont = placeholderFont;
    _placeholderLabel.font = _placeholderFont;
}

//设置文本类型:限制文本长度 / 控件根据文本内容自动调整高度
- (void)setTextViewType:(LSTextViewInputType)textViewType {
    _textViewType = textViewType;
}

//设置最大行数
- (void)setMaxNumberOfLines:(NSInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    
    //计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextHeight = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}

- (void)setText:(NSString *)text {
    [super setText:text];
    _placeholderLabel.hidden = [@(text.length) boolValue];
}

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderLabel.font = font;
}

#pragma mark - getter
- (NSString *)text {
    NSString *currentText = [super text];
    //去除首尾的空格和换行
    return [currentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (void)dealloc {
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    _changeHandler = NULL;
}

#pragma mark - 链式编程测试
+ (instancetype)ls_textView:(void (^)(LSTextView *textView))initBlock {
    
    LSTextView *textView = [[LSTextView alloc] init];
    
    if (initBlock) {
        initBlock(textView);
    }
    
    return textView;
}
- (LSTextView *)ls_and {
    return self;
}
- (LSTextView *)ls_width {
    return self;
}
///设置文本最大长度
- (LSTextView *(^)(NSInteger maxLength))ls_maxLength {
    return ^id(NSInteger maxLength) {
        _maxLength = maxLength;
        return self;
    };
}
///圆角半径
- (LSTextView *(^)(CGFloat cornerRadius))ls_cornerRadius {
    return ^id(CGFloat cornerRadius) {
        _cornerRadius = cornerRadius;
        self.layer.cornerRadius = _cornerRadius;
        return self;
    };
}
///边框宽度
- (LSTextView *(^)(CGFloat borderWidth))ls_borderWidth {
    return ^id(CGFloat borderWidth) {
        _borderWidth = borderWidth;
        self.layer.borderWidth = borderWidth;
        return self;
    };
}
///边框颜色
- (LSTextView *(^)(UIColor *borderColor))ls_borderColor {
    return ^id(UIColor *borderColor) {
        _borderColor = borderColor;
        self.layer.borderColor = borderColor.CGColor;
        return self;
    };
}
///placeholder
- (LSTextView *(^)(NSString *placeholder))ls_placeholder {
    return ^id(NSString *placeholder) {
        _placeholder = placeholder;
        if (_placeholder.length > 0) {
            _placeholderLabel.text = _placeholder;
        }
        return self;
    };
}
///占位字符串颜色
- (LSTextView *(^)(UIColor *placeholderColor))ls_placeholderColor {
    return ^id(UIColor *placeholderColor) {
        _placeholderColor = placeholderColor;
        _placeholderLabel.textColor = _placeholderColor;
        return self;
    };
}
///placeholder 字体
- (LSTextView *(^)(UIFont *placeholderFont))ls_placeholderFont {
    return ^id(UIFont *placeholderFont) {
        _placeholderFont = placeholderFont;
        _placeholderLabel.font = _placeholderFont;
        return self;
    };
}
///设置类型
- (LSTextView *(^)(LSTextViewInputType textViewType))ls_textViewType {
    return ^id(LSTextViewInputType textViewType) {
        _textViewType = textViewType;
        return self;
    };
}
///设置最大行数
- (LSTextView *(^)(NSInteger maxNumberOfLines))ls_maxNumberOfLines {
    return ^id(NSInteger maxNumberOfLines) {
        _maxNumberOfLines = maxNumberOfLines;
        
        //计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
        _maxTextHeight = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
        return self;
    };
}

@end
