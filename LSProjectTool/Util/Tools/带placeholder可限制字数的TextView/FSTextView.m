//
//  FSTextView.m
//  FSTextView
//
//  Created by Steven on 2016/9/27.
//  Copyright © 2016年 Steven. All rights reserved.
//

#import "FSTextView.h"

#pragma makr - 限制文本长度
CGFloat const kFSTextViewPlaceholderVerticalMargin  = 8.0; ///< placeholder垂直方向边距
CGFloat const kFSTextViewPlaceholderHorizontalMargin = 6.0; ///< placeholder水平方向边距

@interface FSTextView ()

#pragma makr - 限制文本长度
///< 文本改变Block
@property (nonatomic, copy) FSTextViewHandler changeHandler;
///< 达到最大限制字符数Block
@property (nonatomic, copy) FSTextViewHandler maxHandler;
///< placeholderLabel
@property (nonatomic, weak) UILabel *placeholderLabel;


#pragma mark - 根据文本内容调整控件高度
///文字高度
@property (nonatomic, assign) NSInteger textHeight;
///文字最大高度
@property (nonatomic, assign) NSInteger maxTextHeight;

@end

@implementation FSTextView

#pragma mark - Super Methods

- (void)awakeFromNib {
    [super awakeFromNib];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 10.0) {
        [self layoutIfNeeded];
    }
    [self initialize];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    [self initialize];
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _changeHandler = NULL;
    _maxHandler = NULL;
}

#pragma mark - Private

- (void)initialize {
    #pragma makr - 限制文本长度
    // 监听文本变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    
    // 基本配置
    _maxLength = NSUIntegerMax;
    _placeholderColor = [UIColor colorWithRed:0.780 green:0.780 blue:0.804 alpha:1.000];
    
    // 基本设定
    self.backgroundColor = [UIColor whiteColor];
    self.font = [UIFont systemFontOfSize:15.f];
    
    // placeholderLabel
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.font = self.font;
    placeholderLabel.textColor = _placeholderColor;
    placeholderLabel.numberOfLines = 0;
    placeholderLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:placeholderLabel];
    _placeholderLabel = placeholderLabel;
    
    // constraint
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0
                                                      constant:kFSTextViewPlaceholderVerticalMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0
                                                      constant:kFSTextViewPlaceholderHorizontalMargin]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel
                                                     attribute:NSLayoutAttributeWidth
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeWidth
                                                    multiplier:1.0
                                                      constant:-kFSTextViewPlaceholderHorizontalMargin*2]];
    [self addConstraint:[NSLayoutConstraint constraintWithItem:placeholderLabel
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0
                                                      constant:-kFSTextViewPlaceholderVerticalMargin*2]];
    #pragma mark - 根据文本内容调整控件高度
    self.scrollEnabled = NO;
    self.scrollsToTop = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.enablesReturnKeyAutomatically = YES;
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    _textViewType = LimitedTextLength;//限制文本长度
}

//
- (void)ls_textViewHeightChangeBlock:(void (^)(NSString *, CGFloat))textViewHeightChangeBlock {
    if (textViewHeightChangeBlock) {
        textViewHeightChangeBlock = _yz_textHeightChangeBlock;
    }
}

#pragma mark - Getter
// SuperGetter
- (NSString *)text {
    NSString *currentText = [super text];
    return [currentText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; // 去除首尾的空格和换行.
}

#pragma mark - Setter
// SuperStter
- (void)setText:(NSString *)text {
    [super setText:text];
    _placeholderLabel.hidden = [@(text.length) boolValue];
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    _placeholderLabel.font = font;
}

//设置圆角
- (void)setCornerRadius:(CGFloat)cornerRadius {
    _cornerRadius = cornerRadius;
    self.layer.cornerRadius = _cornerRadius;
}
//边框颜色
- (void)setBorderColor:(UIColor *)borderColor {
    if (!borderColor) return;
    _borderColor = borderColor;
    self.layer.borderColor = _borderColor.CGColor;
}
//边框宽度
- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}
//占位文字
- (void)setPlaceholder:(NSString *)placeholder {
    if (!placeholder) return;
    _placeholder = placeholder;
    if (_placeholder.length > 0) {
        _placeholderLabel.text = _placeholder;
    }
}
//占位文本字体
- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    if (!placeholderFont) return;
    _placeholderFont = placeholderFont;
    _placeholderLabel.font = _placeholderFont;
}

//设置类型 限制文本长度 / 控件根据文本内容自动调整高度
-  (void)setTextViewType:(LSTextViewInputType)textViewType {
    _textViewType = textViewType;
}
- (void)setMaxNumberOfLines:(NSUInteger)maxNumberOfLines {
    _maxNumberOfLines = maxNumberOfLines;
    
    // 计算最大高度 = (每行高度 * 总行数 + 文字上下间距)
    _maxTextHeight = ceil(self.font.lineHeight * maxNumberOfLines + self.textContainerInset.top + self.textContainerInset.bottom);
}
- (void)setYz_textHeightChangeBlock:(void (^)(NSString *, CGFloat))yz_textChangeBlock {
    _yz_textHeightChangeBlock = yz_textChangeBlock;
    
    [self textDidChange];
}


#pragma mark - NSNotification
- (void)textDidChange {
    // 根据字符数量显示或者隐藏placeholderLabel
    _placeholderLabel.hidden = [@(self.text.length) boolValue];
    
    
    switch (_textViewType) {
        case LimitedTextLength: //限制文本长度
        {
            // 禁止第一个字符输入空格或者换行
            if (self.text.length == 1) {
                if ([self.text isEqualToString:@" "] || [self.text isEqualToString:@"\n"]) {
                    self.text = @"";
                }
            }
            
            if (_maxLength != NSUIntegerMax) { // 只有当maxLength字段的值不为无穷大整型时才计算限制字符数.
                NSString    *toBeString    = self.text;
                UITextRange *selectedRange = [self markedTextRange];
                UITextPosition *position   = [self positionFromPosition:selectedRange.start offset:0];
                if (!position) {
                    if (toBeString.length > _maxLength) {
                        self.text = [toBeString substringToIndex:_maxLength]; // 截取最大限制字符数.
                        _maxHandler?_maxHandler(self):NULL; // 回调达到最大限制的Block.
                    }
                }
            }
            
            // 回调文本改变的Block.
            _changeHandler?_changeHandler(self):NULL;
        }
            break;
            
        case AutomaticAdjustmentHeight://根据文本内容调整控件高度
        {
            //ceilf 向上取整
            //sizeThatFits:会计算出最优的 size 但是不会改变 自己的 size
            NSInteger height = ceilf([self sizeThatFits:CGSizeMake(self.bounds.size.width, MAXFLOAT)].height);
            
            if (_textHeight != height) { // 高度不一样，就改变了高度
                
                // 文本高度 < 设置的最大高度   不能滚动
                // 文本高度 > 设置的最大高度   可以滚动
                self.scrollEnabled = height > _maxTextHeight && _maxTextHeight > 0;
                
                _textHeight = height;
                
                //
                if (_yz_textHeightChangeBlock && self.scrollEnabled == NO) {
                    _yz_textHeightChangeBlock(self.text,height);
                    [self.superview layoutIfNeeded];
                }
            }

        }
            break;
        default:
            break;
    }
}

#pragma mark - Public

/*! @brief 便利构造器创建FSTextView实例.
 */
+ (instancetype)textView {
    return [[self alloc] init];
}

/*! @brief 设定文本改变Block回调. (切记弱化引用, 以免造成内存泄露.) */
- (void)addTextDidChangeHandler:(FSTextViewHandler)changeHandler{
    _changeHandler = [changeHandler copy];
}

/*! @brief 设定达到最大长度Block回调. (切记弱化引用, 以免造成内存泄露.) */
- (void)addTextLengthDidMaxHandler:(FSTextViewHandler)maxHandler {
    _maxHandler = [maxHandler copy];
}

@end
