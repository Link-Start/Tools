//
//  CodeView.h
//  CodeView
//
//  Created by meb on 2019/9/11.
//  Copyright © 2019 meb. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, CodeStyle) {
    CodeStyle_line, //下划线格式
    CodeStyle_border //带边框格式
};
typedef void(^SelectCodeBlock)(NSString *);
@interface CodeView : UIView
@property(nonatomic,copy)SelectCodeBlock codeBlock;//验证码回调
- (instancetype)initWithFrame:(CGRect)frame codeNumber:(NSInteger)codeNumber space:(CGFloat)space style:(CodeStyle)style bgColor:(nullable UIColor *)bgColor labelFont:(UIFont *)labelFont labelTextColor:(UIColor *)labelTextColor mainColor:(UIColor *)mainColor normalColor:(UIColor *)normalColor selectCodeBlock:(SelectCodeBlock)CodeBlock;

/// 加密
@property (nonatomic, assign) BOOL encryptedText;


- (void)startEdit;
- (void)endEdit;
/// 清除输入框
- (void)clearTextField;


@end

NS_ASSUME_NONNULL_END
